import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'providers/selected_profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ SharedPreferences에서 저장된 프로필 불러오기
  final savedProfile = await SelectedProfileManager.load();

  runApp(
    ProviderScope(
      overrides: [
        selectedProfileProvider.overrideWith(
              (ref) => savedProfile,
        ),
      ],
      child: const EZSajuApp(),
    ),
  );
}
