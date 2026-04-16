import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitforge/app.dart' as app;
import 'package:fitforge/core/theme/app_theme.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FitForgeApp()));
}

class FitForgeApp extends ConsumerWidget {
  const FitForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FitForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeModeAsync.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, _) => ThemeMode.system,
      ),
      routerConfig: app.router,
    );
  }
}
