// lib/screens/daily_calendar_screen.dart
import 'package:flutter/material.dart';
import '../models/calendar_day.dart';
import '../services/manse_loader.dart';
import '../constants/app_colors.dart';
import 'views/monthly_calendar_view.dart';
import 'views/weekly_calendar_view.dart';

class DailyCalendarScreen extends StatefulWidget {
  const DailyCalendarScreen({super.key});

  @override
  State<DailyCalendarScreen> createState() => _DailyCalendarScreenState();
}

class _DailyCalendarScreenState extends State<DailyCalendarScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<CalendarDay>> _manseFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _manseFuture = ManseLoader.load();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('만세력'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          //  TabBar만 따로 배치 (AppBar에서 분리)
          Container(
            height: 40, // 👈 원하는 높이로 조절 가능 (기본 48 → 줄임)
            alignment: Alignment.center,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '월간'),
                Tab(text: '주간'),
              ],
              labelColor: AppColors.fire,
              unselectedLabelColor: AppColors.textSecondary,
              labelPadding: EdgeInsets.zero,
              indicatorWeight: 2,
            ),
          ),

          //TabBarView 내용
          Expanded(
            child: FutureBuilder<List<CalendarDay>>(
              future: _manseFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final manse = snapshot.data!;
                return TabBarView(
                  controller: _tabController,
                  children: [
                    MonthlyCalendarView(manse: manse),
                    WeeklyCalendarView(manse: manse),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
