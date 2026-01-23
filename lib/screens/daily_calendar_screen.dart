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

  // 전체 화면 스케일 값
  late double sw;       // width
  late double sh;       // height
  late double scale;    // 기준 스케일 (390dp 기준)
  late double tScale;   // text scale

  @override
  void initState() {
    super.initState();
    _manseFuture = ManseLoader.load();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    sw = MediaQuery.of(context).size.width;
    sh = MediaQuery.of(context).size.height;
    final textScaler = MediaQuery.of(context).textScaler;
    final tScale = textScaler.scale(1.0).clamp(0.8, 1.2);
    scale = sw / 390; // iPhone 12 width 기준 스케일

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          '만세력',
          style: TextStyle(
            fontSize: 18 * scale * tScale,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundOf(context),
      ),
      body: Column(
        children: [
          // ▫️ TabBar
          SizedBox(
            height: 40 * scale,
            child: TabBar(
              controller: _tabController,
              labelStyle: TextStyle(fontSize: 14 * scale * tScale),
              unselectedLabelStyle:
              TextStyle(fontSize: 13 * scale * tScale),
              tabs: const [
                Tab(text: '월간'),
                Tab(text: '주간'),
              ],
              labelColor: AppColors.fire,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorWeight: 2 * scale,
            ),
          ),

          // ▫️ Tab View (월간 / 주간)
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
