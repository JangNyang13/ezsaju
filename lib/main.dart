import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/themes.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const ProviderScope(child: EZSajuApp()));
}

class EZSajuApp extends StatelessWidget {
  const EZSajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZ‑Saju',
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ 다크모드 제거 → 라이트 테마만 적용
      theme: AppTheme.light(),

      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
