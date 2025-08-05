import 'package:ezsaju/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const EZSajuApp());
}

class EZSajuApp extends StatelessWidget {
  const EZSajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZ-Saju',
      // ✅ 한글 로캘 등록
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
      home: MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
