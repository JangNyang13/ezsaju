import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ezsaju/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'constants/themes.dart';

class EZSajuApp extends StatelessWidget {
  const EZSajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사주픽', //사주픽
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // ✅ 이게 핵심!!
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}
