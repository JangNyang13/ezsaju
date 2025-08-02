// lib/screens/analysis_screen.dart
import 'package:flutter/material.dart';
import 'package:ezsaju/models/saju_data.dart';
import 'package:ezsaju/services/manse_loader.dart';
import 'package:ezsaju/services/saju_calculator.dart';
import 'package:ezsaju/services/ten_god_calculator.dart';
import 'package:ezsaju/utils/daeun_calculator.dart';

import '../utils/hidden_stems.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DateTime _selectedDateTime = DateTime.now();
  bool _isTimeUnknown = false;
  bool _isMale = true; // 성별 추가
  SajuData? _saju;
  DaeunInfo? _daeunInfo;
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _calculateSaju() async {
    setState(() => _isLoading = true);
    try {
      final manse = await ManseLoader.load();
      final dt = _isTimeUnknown
          ? DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day)
          : _selectedDateTime;
      final result = SajuCalculator.fromDateTime(dt, manse);

      // 대운 계산 추가
      final daeun = DaeunCalculator.calculate(result, _selectedDateTime, _isMale, manse);

      setState(() {
        _saju = result;
        _daeunInfo = daeun;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('계산 오류: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = "${_selectedDateTime.year}-${_selectedDateTime.month}-${_selectedDateTime.day}";
    final timeStr = "${_selectedDateTime.hour}:${_selectedDateTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text('나의 사주 분석')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('출생 일시 입력', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 성별 선택 추가
            Row(
              children: [
                const Text('성별: '),
                Radio<bool>(
                  value: true,
                  groupValue: _isMale,
                  onChanged: (value) => setState(() => _isMale = value!),
                ),
                const Text('남성'),
                Radio<bool>(
                  value: false,
                  groupValue: _isMale,
                  onChanged: (value) => setState(() => _isMale = value!),
                ),
                const Text('여성'),
              ],
            ),

            CheckboxListTile(
              title: const Text('시간 모름'),
              value: _isTimeUnknown,
              onChanged: (v) => setState(() => _isTimeUnknown = v!),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickDate,
                    child: Text('날짜 선택: $dateStr'),
                  ),
                ),
                if (!_isTimeUnknown) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text('시간 선택: $timeStr'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _calculateSaju,
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('사주 조회'),
              ),
            ),
            const SizedBox(height: 24),
            if (_saju != null) _buildResult(_saju!),
            if (_daeunInfo != null) _buildDaeunResult(_daeunInfo!),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(SajuData saju) {
    final stems = [
      saju.hourGan,
      saju.dayGan,
      saju.monthGan,
      saju.yearGan,
    ];
    final branches = [
      saju.hourZhi,
      saju.dayZhi,
      saju.monthZhi,
      saju.yearZhi,
    ];

    Widget cell(String text) => Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );

    return Column(
      children: [
        const Divider(),
        const Text('사주팔자 결과', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // 천간
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stems.map(cell).toList(),
        ),
        const SizedBox(height: 8),

        // 지지
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: branches.map(cell).toList(),
        ),

        // 지장간
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: branches.map((b) => cell((hiddenStems[b] ?? []).join(","))).toList(),
        ),
        const Divider(),

        // 십성 (천간 기준)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stems.asMap().entries.map((entry) {
            final index = entry.key;
            final gan = entry.value;
            if (index == 1) {
              return cell('나');
            } else {
              return cell(calcTenGodBySaju(saju, gan));
            }
          }).toList(),
        ),

        // 십성 (지지 기준)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: branches.map((zhi) => cell(calcTenGodBySaju(saju, zhi, isBranch: true))).toList(),
        ),
      ],
    );
  }

  Widget _buildDaeunResult(DaeunInfo daeunInfo) {
    final currentAge = DaeunCalculator.getCurrentAge(_selectedDateTime);
    final currentDaeun = DaeunCalculator.getDaeunAtAge(daeunInfo, currentAge);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const Text('대운 분석', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),

        // 현재 대운 정보
        if (currentDaeun != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '현재 대운 ($currentAge세)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentDaeun.ganzi} (${currentDaeun.startAge}세 ~ ${currentDaeun.endAge}세)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '방향: ${daeunInfo.isForward ? "순행" : "역행"}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 대운표
        const Text('대운표', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            columns: const [
              DataColumn(label: Text('나이')),
              DataColumn(label: Text('대운간지')),
              DataColumn(label: Text('천간')),
              DataColumn(label: Text('지지')),
              DataColumn(label: Text('기간')),
            ],
            rows: daeunInfo.periods.map((period) {
              final isCurrent = currentDaeun != null &&
                  period.startAge == currentDaeun.startAge;

              return DataRow(
                color: isCurrent
                    ? WidgetStateProperty.all(Colors.blue.shade100)
                    : null,
                cells: [
                  DataCell(Text('${period.startAge}')),
                  DataCell(Text(
                    period.ganzi,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(period.gan)),
                  DataCell(Text(period.zhi)),
                  DataCell(Text('${period.startAge}~${period.endAge}세')),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '대운은 ${daeunInfo.startAge}세부터 시작되며, 10년 단위로 변화합니다.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}