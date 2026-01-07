import 'package:ezsaju/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(profilesProvider.future); // 강제 초기화

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ProviderScope(
        child: EZSajuApp(),
      ),
    ),
  );
}
