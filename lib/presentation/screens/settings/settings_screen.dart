import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitforge/presentation/providers/app_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final unitAsync = ref.watch(unitProvider);
    final themeModeAsync = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('Appearance', tt),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: Text(
              _themeLabel(themeModeAsync.valueOrNull ?? ThemeMode.system),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context),
          ),
          _buildSectionHeader('Units', tt),
          ListTile(
            leading: const Icon(Icons.straighten),
            title: const Text('Weight Unit'),
            subtitle: Text(unitAsync.valueOrNull?.toUpperCase() ?? 'LBS'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showUnitPicker(context),
          ),
          _buildSectionHeader('Progression', tt),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Progression Type'),
            subtitle: const Text('Linear Progression'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showProgressionInfo(context),
          ),
          ListTile(
            leading: const Icon(Icons.percent),
            title: const Text('Weight Increase Rate'),
            subtitle: const Text('5% when target reps hit'),
          ),
          _buildSectionHeader('Data', tt),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('WebDAV Sync'),
            subtitle: const Text('Not configured'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showWebdavSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Clear All Data'),
            subtitle: const Text('Remove all workout data'),
            onTap: () => _showClearDataDialog(context),
          ),
          _buildSectionHeader('About', tt),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('FitForge'),
            subtitle: const Text('v0.2.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: tt.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };
  }

  void _showThemePicker(BuildContext context) {
    final current = ref.read(themeModeProvider).valueOrNull ?? ThemeMode.system;
    showDialog<void>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: ThemeMode.values.map((mode) {
          return SimpleDialogOption(
            onPressed: () async {
              final repo = ref.read(settingsRepositoryProvider);
              await repo.setThemeMode(switch (mode) {
                ThemeMode.system => 'system',
                ThemeMode.light => 'light',
                ThemeMode.dark => 'dark',
              });
              ref.invalidate(themeModeProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  mode == current
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                const SizedBox(width: 8),
                Text(_themeLabel(mode)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showUnitPicker(BuildContext context) {
    final current = ref.read(unitProvider).valueOrNull ?? 'lbs';
    showDialog<void>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Weight Unit'),
        children: ['lbs', 'kg'].map((unit) {
          return SimpleDialogOption(
            onPressed: () async {
              final repo = ref.read(settingsRepositoryProvider);
              await repo.setUnit(unit);
              ref.invalidate(unitProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  unit == current
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                const SizedBox(width: 8),
                Text(unit.toUpperCase()),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showProgressionInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Linear Progression'),
        content: const Text(
          'When you hit your target reps for an exercise, '
          'the weight increases by 5% (rounded to nearest 2.5) '
          'and reps drop back. If you miss your target, weight stays '
          'the same and reps increase by 2.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showWebdavSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _WebdavConfigSheet(),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all workout data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.workoutSetDao.deleteAllSets();
              if (context.mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All workout data cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _WebdavConfigSheet extends ConsumerStatefulWidget {
  const _WebdavConfigSheet();

  @override
  ConsumerState<_WebdavConfigSheet> createState() => _WebdavConfigSheetState();
}

class _WebdavConfigSheetState extends ConsumerState<_WebdavConfigSheet> {
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _urlController.text = await repo.getWebdavUrl() ?? '';
    _usernameController.text = await repo.getWebdavUsername() ?? '';
    _passwordController.text = await repo.getWebdavPassword() ?? '';
    setState(() {});
  }

  Future<void> _saveSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setWebdavUrl(_urlController.text);
    await repo.setWebdavUsername(_usernameController.text);
    await repo.setWebdavPassword(_passwordController.text);
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    await _saveSettings();

    final sync = ref.read(webdavSyncProvider);
    final success = await sync.testConnection();

    setState(() {
      _isLoading = false;
      _statusMessage = success ? 'Connection successful!' : 'Connection failed';
      _isSuccess = success;
    });
  }

  Future<void> _exportBackup() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final sync = ref.read(webdavSyncProvider);
    final db = ref.read(databaseProvider);
    final success = await sync.uploadBackup(db);

    setState(() {
      _isLoading = false;
      _statusMessage = success ? 'Backup uploaded!' : 'Upload failed';
      _isSuccess = success;
    });
  }

  Future<void> _importBackup() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final sync = ref.read(webdavSyncProvider);
    final db = ref.read(databaseProvider);
    final backups = await sync.listRemoteBackups();

    if (backups.isEmpty) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'No backups found';
        _isSuccess = false;
      });
      return;
    }

    if (!mounted) return;
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Backup'),
        children: backups.map((name) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, name),
            child: Text(name),
          );
        }).toList(),
      ),
    );

    if (selected == null) {
      setState(() => _isLoading = false);
      return;
    }

    final count = await sync.downloadAndImport(db, selected);
    setState(() {
      _isLoading = false;
      _statusMessage = 'Imported $count sets';
      _isSuccess = count > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('WebDAV Sync', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'https://your-webdav-server.com/dav/',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cloud),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            if (_statusMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(color: _isSuccess ? Colors.green : cs.error),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _testConnection,
                    child: const Text('Test'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoading ? null : _saveSettings,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _exportBackup,
                    icon: const Icon(Icons.cloud_upload, size: 18),
                    label: const Text('Export'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _importBackup,
                    icon: const Icon(Icons.cloud_download, size: 18),
                    label: const Text('Import'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
