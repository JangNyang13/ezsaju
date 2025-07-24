import 'package:flutter/material.dart';
import 'package:ezsaju/models/saju_data.dart';
import 'package:ezsaju/services/manse_loader.dart';
import 'package:ezsaju/services/saju_calculator.dart';

import '../utils/hidden_stems.dart';

/// AnalysisScreen – 내 사주 입력 & 계산 (시간 선택 옵션 포함)
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DateTime _selectedDateTime = DateTime.now();
  bool _isTimeUnknown = false;
  SajuData? _saju;
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
      // 시간 모름인 경우, 0시 0분으로 계산
      final dt = _isTimeUnknown
          ? DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day)
          : _selectedDateTime;
      final result = SajuCalculator.fromDateTime(dt, manse);
      setState(() {
        _saju = result;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('계산 오류: \$e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('나의 사주 분석')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('출생 일시 입력', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('시간 모름'),
              value: _isTimeUnknown,
              onChanged: (v) {
                setState(() {
                  _isTimeUnknown = v!;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickDate,
                    child: Text('날짜 선택: \$dateStr'),
                  ),
                ),
                if (!_isTimeUnknown) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text('시간 선택: \$timeStr'),
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
          ],
        ),
      ),
    );
  }

  Widget _buildResult(SajuData saju) {
    Widget cell(String text) => Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );

    return Column(
      children: [
        const Divider(),
        const Text('사주팔자 결과', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // 천간 행
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cell(_isTimeUnknown ? '' : saju.hour.substring(0,1)),
            cell(saju.day.substring(0,1)),
            cell(saju.month.substring(0,1)),
            cell(saju.year.substring(0,1)),
          ],
        ),
        const SizedBox(height: 8),

        // 지지 행
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cell(_isTimeUnknown ? '' : saju.hour.substring(1,2)),
            cell(saju.day.substring(1,2)),
            cell(saju.month.substring(1,2)),
            cell(saju.year.substring(1,2)),
          ],
        ),
        const SizedBox(height: 8),

        // 지장간 행
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cell(_isTimeUnknown ? '' : (hiddenStems[saju.hour.substring(1,2)] ?? []).join(',')),
            cell((hiddenStems[saju.day.substring(1,2)] ?? []).join(',')),
            cell((hiddenStems[saju.month.substring(1,2)] ?? []).join(',')),
            cell((hiddenStems[saju.year.substring(1,2)] ?? []).join(',')),
          ],
        ),

      ],
    );
  }
}
