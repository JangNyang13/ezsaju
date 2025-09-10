// lib/screens/saju_lookup_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/text_styles.dart';
import '../widgets/saju_analysis_panel.dart';
import '../screens/profile_form_screen.dart';
import '../models/saju_form_result.dart';

class SajuLookupScreen extends StatefulWidget {
  const SajuLookupScreen({super.key});

  @override
  State<SajuLookupScreen> createState() => _SajuLookupScreenState();
}

class _SajuLookupScreenState extends State<SajuLookupScreen> {
  static const _storeKey = 'lookup_entries_v1';

  final TextEditingController _q = TextEditingController();
  final List<_LookupEntry> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _q.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final pref = await SharedPreferences.getInstance();
    final raw = pref.getString(_storeKey);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List)
          .map((e) => _LookupEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      _items
        ..clear()
        ..addAll(list);
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    final pref = await SharedPreferences.getInstance();
    final raw = jsonEncode(_items.map((e) => e.toJson()).toList());
    await pref.setString(_storeKey, raw);
  }

  void _addEntry(_LookupEntry e) {
    setState(() => _items.insert(0, e));
    _save();
  }

  void _deleteAt(int index) {
    setState(() => _items.removeAt(index));
    _save();
  }

  List<_LookupEntry> get _filtered {
    final q = _q.text.trim();
    if (q.isEmpty) return _items;
    return _items.where((e) => e.name.contains(q)).toList();
  }

  String _formatEntry(_LookupEntry e) {
    final y = e.date.year.toString().padLeft(4, '0');
    final m = e.date.month.toString().padLeft(2, '0');
    final d = e.date.day.toString().padLeft(2, '0');
    final time = e.timeMinutes == null
        ? 'T--:--'
        : 'T${(e.timeMinutes! ~/ 60).toString().padLeft(2, '0')}:${(e.timeMinutes! % 60).toString().padLeft(2, '0')}';
    return '$y.$m.$d $time';
  }

  // 상단 “추가” → 프로필 폼을 결과만 받는 모드로 열기
  Future<void> _openAdd() async {
    final result = await Navigator.push<SajuFormResult>(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileFormScreen(popResultOnly: true),
      ),
    );
    if (result == null) return;

    final dt = result.birth; // 이미 양력으로 보정
    _addEntry(
      _LookupEntry(
        name: result.name,
        date: DateTime(dt.year, dt.month, dt.day),
        timeMinutes: result.timeUnknown ? null : dt.hour * 60 + dt.minute,
        gender: result.gender,
      ),
    );
  }

  Future<void> _openAnalysis(_LookupEntry e) async {
    final birth = _entryToDateTime(e); // 시간 모름이면 12:00
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            foregroundColor: Theme.of(ctx).colorScheme.onSurface,
            title: Text(e.name),
          ),
          body: SajuAnalysisPanel(
            title: e.name,
            birth: birth,
            gender: e.gender,
            timeUnknown: e.timeMinutes == null,
          ),
        ),
      ),
    );
  }

  DateTime _entryToDateTime(_LookupEntry e) {
    if (e.timeMinutes == null) {
      return DateTime(e.date.year, e.date.month, e.date.day, 12, 0);
    }
    final h = e.timeMinutes! ~/ 60;
    final m = e.timeMinutes! % 60;
    return DateTime(e.date.year, e.date.month, e.date.day, h, m);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _q,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: '이름으로 검색',
                      filled: true,
                      fillColor: scheme.surface,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: scheme.outlineVariant.withValues(alpha: .6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.primary, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => setState(() {}),
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('검색'),
                ),
              ],
            ),
          ),

          // 상단 [+] 추가 타일 (유일한 추가 버튼)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _openAdd,
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: .6),
                  ),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: scheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '추가',
                      style:
                      AppTextStyles.body.copyWith(color: scheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 리스트 (👉 더 이상 마지막에 +추가 아이템 없음)
          Expanded(
            child: _filtered.isEmpty
                ? Center(
              child: Text(
                '저장된 항목이 없습니다.\n위의 [추가] 버튼을 눌러 등록하세요.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final e = _filtered[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openAnalysis(e),
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: .6),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${e.name}  |  ${_formatEntry(e)}',
                            style: AppTextStyles.body,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            final realIndex = _items.indexOf(e);
                            if (realIndex >= 0) _deleteAt(realIndex);
                          },
                          icon: const Icon(Icons.delete_outline),
                          tooltip: '삭제',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ─── 간단 엔트리 모델 ─── */
class _LookupEntry {
  final String name;
  final DateTime date;     // yyyy-MM-dd
  final int? timeMinutes;  // null이면 시간모름
  final String gender;     // 'M' | 'F'

  const _LookupEntry({
    required this.name,
    required this.date,
    required this.timeMinutes,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': DateTime(date.year, date.month, date.day).toIso8601String(),
    'timeMin': timeMinutes,
    'gender': gender,
  };

  factory _LookupEntry.fromJson(Map<String, dynamic> j) => _LookupEntry(
    name: j['name'] as String,
    date: DateTime.parse(j['date'] as String),
    timeMinutes: j['timeMin'] == null ? null : j['timeMin'] as int,
    gender: (j['gender'] as String?) ?? 'M',
  );
}
