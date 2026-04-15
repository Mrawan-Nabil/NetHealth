import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ThemeMode Notifier
// Persists the user's preferred theme to SecureStorage so it survives restarts.
// ─────────────────────────────────────────────────────────────────────────────

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'nh_theme_mode';

  @override
  ThemeMode build() {
    _loadPersistedTheme(); // fire-and-forget async init
    return ThemeMode.system; // safe default while storage reads
  }

  Future<void> _loadPersistedTheme() async {
    final saved = await _storage.read(key: _key);
    if (saved != null) {
      state = _parse(saved);
    }
  }

  /// Flips between light and dark. Clears the "system" default after first toggle.
  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    await _storage.write(key: _key, value: next.name);
  }

  /// Explicitly set a ThemeMode (e.g. from a segmented control).
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _storage.write(key: _key, value: mode.name);
  }

  // ── Private ────────────────────────────────────────────────────────────────
  ThemeMode _parse(String v) => switch (v) {
        'light' => ThemeMode.light,
        'dark'  => ThemeMode.dark,
        _       => ThemeMode.system,
      };
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
