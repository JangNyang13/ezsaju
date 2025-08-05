import 'package:flutter/material.dart';
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
  int _selectedIndex = 2; // 0:사주조회,1:일진달력,2:오늘의운세(초기),3:내사주,4:설정

  final _pages = const [
    SajuLookupScreen(),
    DailyCalendarScreen(),
    FortuneTodayScreen(),
    MySajuScreen(),
    SettingsScreen(),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '사주조회'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '일진달력'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '오늘의 운세'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 사주조회'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
