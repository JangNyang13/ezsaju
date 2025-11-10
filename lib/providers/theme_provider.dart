import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/profile_model.dart';

/// ===============================================================
/// 🔹 테마 상태 관리
/// ===============================================================
class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_key);
    if (mode == 'dark') {
      state = ThemeMode.dark;
    } else if (mode == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setString(_key, 'dark');
    } else {
      state = ThemeMode.light;
      await prefs.setString(_key, 'light');
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

/// ===============================================================
/// 🔹 프로필 상태 관리 (전역 + SharedPreferences 동기화)
/// ===============================================================
class ProfilesNotifier extends AsyncNotifier<List<Profile>> {
  static const _storageKey = 'profiles_data';

  @override
  Future<List<Profile>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null) return [];
    final List<dynamic> data = jsonDecode(jsonStr);
    return data.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _saveProfiles(List<Profile> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  /// ✅ addProfile
  Future<void> addProfile(Profile profile) async {
    final current = [...(state.value ?? <Profile>[])];
    current.add(profile);
    state = AsyncData(current);
    await _saveProfiles(current);
  }

  /// ✅ updateProfile
  Future<void> updateProfile(Profile profile) async {
    final current = [...(state.value ?? <Profile>[])];
    final updated = [
      for (final p in current) if (p.id == profile.id) profile else p,
    ];
    state = AsyncData(updated);
    await _saveProfiles(updated);
  }

  /// ✅ deleteProfile
  Future<void> deleteProfile(String id) async {
    final current = [...(state.value ?? <Profile>[])];
    final filtered = current.where((p) => p.id != id).toList();
    state = AsyncData(filtered);
    await _saveProfiles(filtered);
  }

  Future<void> setProfiles(List<Profile> profiles) async {
    state = AsyncData(profiles);
    await _saveProfiles(profiles);
  }

  Future<void> clearAll() async {
    state = const AsyncData([]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final profilesProvider =
AsyncNotifierProvider<ProfilesNotifier, List<Profile>>(
  ProfilesNotifier.new,
  name: 'profilesProvider',
);

