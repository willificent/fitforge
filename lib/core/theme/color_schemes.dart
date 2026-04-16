import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const _seed = Color(0xFF4F46E5);

  static final light = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  );

  static final dark = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  );
}
