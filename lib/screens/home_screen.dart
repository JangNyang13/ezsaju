import 'package:ezsaju/screens/search_screen.dart';
import 'package:ezsaju/screens/settings_screen.dart';
import 'package:ezsaju/screens/today_screen.dart';
import 'package:ezsaju/screens/week_screen.dart';
import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = const [
    WeekScreen(),
    TodayScreen(),
    AnalysisScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week), label: '한 주간'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: '오늘'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: '나의 사주'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: '지인 사주'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}