import 'package:fitforge/data/database/app_database.dart';

class SettingsRepository {
  final AppDatabase _database;

  SettingsRepository(this._database);

  SettingsDao get _dao => _database.settingsDao;

  Future<String?> get(String key) => _dao.getValue(key);

  Stream<String?> watch(String key) => _dao.watchValue(key);

  Future<void> set(String key, String value) => _dao.setValue(key, value);

  Future<void> remove(String key) => _dao.deleteValue(key);

  Future<String> getUnit() async {
    return await get('units') ?? 'lbs';
  }

  Future<void> setUnit(String unit) => set('units', unit);

  Future<String> getProgressionType() async {
    return await get('progression_type') ?? 'linear';
  }

  Future<void> setProgressionType(String type) => set('progression_type', type);

  Future<double> getProgressionRate() async {
    final value = await get('progression_rate');
    return value != null ? double.parse(value) : 0.05;
  }

  Future<void> setProgressionRate(double rate) =>
      set('progression_rate', rate.toString());

  Future<String> getThemeMode() async {
    return await get('theme_mode') ?? 'system';
  }

  Future<void> setThemeMode(String mode) => set('theme_mode', mode);

  Future<bool> isWebdavEnabled() async {
    return (await get('webdav_enabled')) == 'true';
  }

  Future<void> setWebdavEnabled(bool enabled) =>
      set('webdav_enabled', enabled.toString());

  Future<String?> getWebdavUrl() => get('webdav_url');

  Future<void> setWebdavUrl(String url) => set('webdav_url', url);

  Future<String?> getWebdavUsername() => get('webdav_username');

  Future<void> setWebdavUsername(String username) =>
      set('webdav_username', username);

  Future<String?> getWebdavPassword() => get('webdav_password');

  Future<void> setWebdavPassword(String password) =>
      set('webdav_password', password);
}
