import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/themes.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 온보딩 여부 체크
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

  runApp(
    ProviderScope(
      child: EZSajuApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class EZSajuApp extends StatelessWidget {
  final bool seenOnboarding;
  const EZSajuApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '운세픽',
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      home: seenOnboarding
          ? MainNavigationScreen(key: MainNavigationScreen.navKey)
          : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,

      // ✅ 시스템 글꼴 크기 무시하고 고정
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

