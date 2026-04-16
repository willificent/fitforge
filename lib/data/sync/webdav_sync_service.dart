import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/data/repositories/settings_repository.dart';

class WebdavSyncService {
  final SettingsRepository _settingsRepo;

  WebdavSyncService(this._settingsRepo);

  Future<webdav.Client?> _createClient() async {
    final url = await _settingsRepo.getWebdavUrl();
    final username = await _settingsRepo.getWebdavUsername();
    final password = await _settingsRepo.getWebdavPassword();

    if (url == null || url.isEmpty || username == null || password == null) {
      return null;
    }

    return webdav.newClient(url, user: username, password: password);
  }

  Future<bool> testConnection() async {
    final client = await _createClient();
    if (client == null) return false;
    try {
      await client.ping();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> exportCsv(AppDatabase db) async {
    final sets = await db.workoutSetDao.getAllSets();
    final buffer = StringBuffer();
    buffer.writeln('Date,Exercise,Category,Weight (kg),Reps,Comment');

    for (final set in sets) {
      final comment = set.comment ?? '';
      buffer.writeln(
        '${set.date},${set.exerciseName},${set.bodyPart},${set.weight},${set.reps.toInt()},$comment',
      );
    }

    return buffer.toString();
  }

  Future<int> importCsv(AppDatabase db, String csvContent) async {
    final lines = csvContent.split('\n');
    if (lines.isEmpty) return 0;

    var imported = 0;
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(',');
      if (parts.length < 5) continue;

      final date = parts[0].trim();
      final exerciseName = parts[1].trim();
      final category = parts[2].trim();
      final weight = double.tryParse(parts[3].trim()) ?? 0;
      final reps = double.tryParse(parts[4].trim()) ?? 0;
      final comment = parts.length >= 6 ? parts[5].trim() : '';

      await db.workoutSetDao.insertSet(
        WorkoutSetsCompanion.insert(
          date: date,
          exerciseName: exerciseName,
          bodyPart: category,
          weight: weight,
          reps: reps,
          comment: Value(comment.isEmpty ? null : comment),
        ),
      );
      imported++;
    }

    return imported;
  }

  Future<bool> uploadBackup(AppDatabase db) async {
    final client = await _createClient();
    if (client == null) return false;

    try {
      final csv = await exportCsv(db);
      final formatter = DateFormat('_yyyy-MM-dd_HH:mm:ss');
      final filename = 'fitforge${formatter.format(DateTime.now())}.txt';

      await client.write(filename, Uint8List.fromList(utf8.encode(csv)));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> listRemoteBackups() async {
    final client = await _createClient();
    if (client == null) return [];

    try {
      final files = await client.readDir('/');
      return files
          .where(
            (f) =>
                f.name?.startsWith('fitforge') == true &&
                f.name?.endsWith('.txt') == true,
          )
          .map((f) => f.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<int> downloadAndImport(AppDatabase db, String filename) async {
    final client = await _createClient();
    if (client == null) return 0;

    try {
      final data = await client.read(filename);
      final csv = utf8.decode(data);
      return importCsv(db, csv);
    } catch (_) {
      return 0;
    }
  }

  Future<bool> deleteRemoteBackup(String filename) async {
    final client = await _createClient();
    if (client == null) return false;

    try {
      await client.remove(filename);
      return true;
    } catch (_) {
      return false;
    }
  }
}
