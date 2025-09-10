// lib/screens/profile_form_screen.dart
// --------------------------------------------------------------
// 프로필 입력/수정 폼
//  - profile + index 파라미터가 주어지면 "편집" 모드, 없으면 "추가" 모드
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/profiles_repository.dart';
import '../providers/profiles_provider.dart';
import '../models/user_profile.dart';

// ✅ 추가
import '../utils/lunar_converter.dart'; //음력->양력 변환
import '../models/saju_form_result.dart'; //재활용

enum CalendarKind { solar, lunarPlain, lunarLeap }

class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({super.key, this.profile, this.index, this.popResultOnly = false,});

  final UserProfile? profile; // 편집 대상
  final int? index;           // 해당 인덱스
  final bool popResultOnly; //조회용 확인

  bool get isEdit => profile != null && index != null;

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  String _gender = 'M';
  DateTime _birthDate = DateTime(2000, 1, 1);
  TimeOfDay _birthTime = const TimeOfDay(hour: 12, minute: 0);
  bool _timeUnknown = false; // 기본값: 시간 입력
  CalendarKind _calKind = CalendarKind.solar;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      final p = widget.profile!;
      _nameCtrl.text = p.name;
      _gender = p.gender;
      _birthDate = DateTime(p.birth.year, p.birth.month, p.birth.day);
      _birthTime = TimeOfDay(hour: p.birth.hour, minute: p.birth.minute);
      _timeUnknown = p.timeUnknown; // 시간 모름 상태 유지
      // 캘린더 종류는 저장 안 하므로 기본 solar 유지
    }
  }

  String _datePrefix() {
    switch (_calKind) {
      case CalendarKind.solar: return '양력';
      case CalendarKind.lunarPlain: return '음력';
      case CalendarKind.lunarLeap: return '음력(윤달)';
    }
  }

  String _ymd(DateTime d) => '${d.year}년 ${d.month}월 ${d.day}일';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.black87),
        title: Text(widget.isEdit ? '프로필 편집' : '프로필 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _nameGenderRow(),
              const SizedBox(height: 24),
              _calendarKindSegment(context),
              const SizedBox(height: 24),
              _birthRow(),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),        // ✅ 필수
                label: const Text('저장'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ── 위젯 파트 ─────────────────────────────── */
  Widget _nameGenderRow() => Row(children: [
    Expanded(
      child: TextFormField(
        controller: _nameCtrl,
        decoration: const InputDecoration(labelText: '이름'),
        validator: (v) => v == null || v.trim().isEmpty ? '이름은 필수입니다' : null,
      ),
    ),
    const SizedBox(width: 12),
    ToggleButtons(
      isSelected: [_gender == 'M', _gender == 'F'],
      onPressed: (i) => setState(() => _gender = i == 0 ? 'M' : 'F'),
      children: const [
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('남')),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('여')),
      ],
    ),
  ]);

  Widget _calendarKindSegment(BuildContext ctx) => SizedBox(
    width: double.infinity,
    child: SegmentedButton<CalendarKind>(
      segments: const [
        ButtonSegment(value: CalendarKind.solar, label: Text('양력')),
        ButtonSegment(value: CalendarKind.lunarPlain, label: Text('음력 평달')),
        ButtonSegment(value: CalendarKind.lunarLeap, label: Text('음력 윤달')),
      ],
      selected: {_calKind},
      onSelectionChanged: (s) => setState(() => _calKind = s.first),
    ),
  );

  Widget _birthRow() => Row(children: [
    Expanded(
      child: ListTile(
        title: const Text('출생일'),
        subtitle: Text('${_datePrefix()} ${_ymd(_birthDate)}'),
        onTap: _pickDate,
      ),
    ),
    const SizedBox(width: 8),
    Expanded(
      child: ListTile(
        title: const Text('출생 시간'),
        subtitle: Text(_timeUnknown ? '모름' : '${_birthTime.hour}시 ${_birthTime.minute}분'),
        onTap: _pickTime,
      ),
    ),
  ]);

  /* ── Picker 메서드 (날짜/시간) ───────────────── */
  Future<void> _pickDate() async {
    DateTime temp = _birthDate;
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 280,
        child: Column(children: [
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _birthDate,
              minimumDate: DateTime(1900, 1, 1),
              maximumDate: DateTime(2100, 12, 31),
              onDateTimeChanged: (d) => temp = d,
            ),
          ),
          CupertinoButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _birthDate = temp);
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _pickTime() async {
    TimeOfDay temp = _birthTime;
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SizedBox(
          height: 320,
          child: Column(children: [
            SwitchListTile(
              title: const Text('시간 모름'),
              value: _timeUnknown,
              onChanged: (v) => setModalState(() => _timeUnknown = v),
            ),
            if (!_timeUnknown)
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(2024, 1, 1, temp.hour, temp.minute),
                  use24hFormat: true,
                  onDateTimeChanged: (d) => setModalState(() => temp = TimeOfDay.fromDateTime(d)),
                ),
              ),
            CupertinoButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _timeUnknown ? _birthTime = const TimeOfDay(hour: 12, minute: 0) : _birthTime = temp;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }

  /* ── 저장 ─────────────────────────────────────────── */
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // 1) 사용자가 선택한 날짜(양력 or 음력)를 '양력'으로 변환
    DateTime? solarDate;
    if (_calKind == CalendarKind.solar) {
      solarDate = _birthDate;
    } else {
      final isLeap = _calKind == CalendarKind.lunarLeap;
      solarDate = await LunarConverter.lunarToSolar(
        lunarYear: _birthDate.year,
        lunarMonth: _birthDate.month,
        lunarDay: _birthDate.day,
        isLeapMonth: isLeap,
      );
      if (solarDate == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('해당 음력 날짜를 양력으로 변환할 수 없습니다. 윤달/일자 확인')),
        );
        return;
      }
    }

    // 2) 시간 모름이면 12:00 고정
    final birthDT = DateTime(
      solarDate.year,
      solarDate.month,
      solarDate.day,
      _timeUnknown ? 12 : _birthTime.hour,
      _timeUnknown ? 0  : _birthTime.minute,
    );

    // 3) 결과만 돌려주는 모드라면 저장하지 않고 pop
    if (widget.popResultOnly) {
      if (!mounted) return;
      Navigator.pop(
        context,
        SajuFormResult(
          name: _nameCtrl.text.trim(),
          birth: birthDT,
          gender: _gender,
          timeUnknown: _timeUnknown,
        ),
      );
      return;
    }

    // 4) 저장/업데이트 (기존 로직 유지)
    try {
      if (widget.isEdit) {
        final updated = widget.profile!.copyWith(
          name: _nameCtrl.text.trim(),
          gender: _gender,
          birth: birthDT,
          timeUnknown: _timeUnknown,
        );
        await ProfilesRepository.instance.updateProfile(widget.index!, updated);
      } else {
        await ProfilesRepository.instance.addProfile(
          name: _nameCtrl.text.trim(),
          birth: birthDT,
          gender: _gender,
          timeUnknown: _timeUnknown,
        );
      }
      if (!mounted) return;
      ref.invalidate(profilesProvider);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}
