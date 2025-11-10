// lib/screens/main_navigation_screen.dart
import 'package:ezsaju/screens/saju_entry_screen.dart';
import 'package:flutter/material.dart';
import 'daily_calendar_screen.dart';
import 'daily_info_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  static final GlobalKey<MainNavigationScreenState> navKey =
  GlobalKey<MainNavigationScreenState>();

  static void goToTab(int index) => navKey.currentState?._onTap(index);

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  late final AnimationController _ctrl;
  late Animation<double> _posAnim;

  final _pages = const [
    DailyCalendarScreen(), // 1️⃣ 만세력
    DailyInfoScreen(),     // 2️⃣ 오늘의 정보
    SajuEntryScreen(),    // 3️⃣ 사주조회
    SettingsScreen(),      // 4️⃣ 설정
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _posAnim = AlwaysStoppedAnimation(_selectedIndex.toDouble());
  }

  void _onTap(int idx) {
    setState(() => _selectedIndex = idx);
    _posAnim = Tween<double>(
      begin: _posAnim.value,
      end: idx.toDouble(),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.surfaceContainerHighest;
    final active = scheme.primary;
    final inactive = scheme.secondary;

    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: SafeArea(
        child: _buildBubbledNavBar(
          activeColor: active,
          inactiveColor: inactive,
          backgroundColor: bg,
        ),
      ),
    );
  }

  // 🔹 BubbledNavBar 내부 코드 통합
  Widget _buildBubbledNavBar({
    required Color activeColor,
    required Color inactiveColor,
    required Color backgroundColor,
  }) {
    const height = 64.0;
    const indicatorHeight = 3.0;
    const icons = [
      Icons.calendar_month,
      Icons.wb_sunny_rounded,
      Icons.auto_graph_rounded,
      Icons.settings,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width / icons.length;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // 캡슐 인디케이터
              AnimatedBuilder(
                animation: _posAnim,
                builder: (context, _) {
                  return Positioned(
                    top: 0,
                    left: _posAnim.value * itemWidth + itemWidth * 0.2,
                    width: itemWidth * 0.6,
                    child: Container(
                      height: indicatorHeight,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(indicatorHeight),
                      ),
                    ),
                  );
                },
              ),
              // 아이콘 버튼들
              Row(
                children: List.generate(icons.length, (i) {
                  final selected = i == _selectedIndex;
                  final color = selected ? activeColor : inactiveColor;
                  return Expanded(
                    child: InkWell(
                      onTap: () => _onTap(i),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Center(
                        child: Icon(
                          icons[i],
                          color: color,
                          size: 38,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
