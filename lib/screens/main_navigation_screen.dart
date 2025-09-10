// lib/screens/main_navigation_screen.dart
// --------------------------------------------------------------
// 하단 NavigationBar (Material 3)
//   • 활성 탭  : 배경 = primary, 아이콘·라벨 = secondary
//   • 비활성 탭: 배경 = secondary, 아이콘·라벨 = primary
// --------------------------------------------------------------

import 'package:flutter/material.dart';

import '../widgets/bubbled_nav_bar.dart';
import 'fortune_today_screen.dart';
import 'saju_lookup_screen.dart';
import 'daily_calendar_screen.dart';
import 'my_saju_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 2;

  final _pages = const [
    DailyCalendarScreen(),
    SajuLookupScreen(),
    FortuneTodayScreen(),
    MySajuScreen(),
    SettingsScreen(),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      //body: IndexedStack(index: _selectedIndex, children: _pages),
      body: _pages[_selectedIndex],

      // ── NavigationBar (Material3) ─────────────────────────────
      bottomNavigationBar: BubbledNavBar(
        items: const [
          NavBarItem(icon: Icons.calendar_today, label: '일진달력'),
          NavBarItem(icon: Icons.search,         label: '사주조회'),
          NavBarItem(icon: Icons.auto_graph_rounded, label: '오늘의 운세'),
          NavBarItem(icon: Icons.person,         label: '내 사주조회'),
          NavBarItem(icon: Icons.settings,       label: '설정'),
        ],
        currentIndex   : _selectedIndex,
        onTap          : _onTap,
        backgroundColor: Color(0xFFfaf9f6),
        activeColor    : scheme.primary,
        inactiveColor  : Color(0xFFcccccc),
      ),

    );
  }
}
