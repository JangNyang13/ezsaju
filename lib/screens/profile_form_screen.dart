import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/profile_model.dart';
import '../constants/app_colors.dart';
import '../services/manse_loader.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String _id = const Uuid().v4();
  String _name = '';
  DateTime _birthDate = DateTime.now();
  TimeOfDay _birthTime = const TimeOfDay(hour: 12, minute: 0);
  bool _isLunar = false;
  bool _isLeapMonth = false;
  bool _isUnknownTime = false;
  String _gender = '남';
  String _memo = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ 수정 모드일 경우 기존 데이터 불러오기
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Profile) {
      final p = args;
      _id = p.id;
      _name = p.name;
      _birthDate = p.birthDate;
      _birthTime = TimeOfDay(hour: p.birthDate.hour, minute: p.birthDate.minute);
      _isLunar = p.isLunar;
      _isLeapMonth = p.isLeapMonth;
      _isUnknownTime = p.isUnknownTime;
      _gender = p.gender;
      _memo = p.memo;
    }
  }

  // 🗓 생년월일 선택
  Future<void> _selectDate() async {
    DateTime tempDate = _birthDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('생년월일 선택',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _birthDate,
                  minimumDate: DateTime(1900, 1, 1),
                  maximumDate: DateTime(2100, 12, 31),
                  onDateTimeChanged: (newDate) => tempDate = newDate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => _birthDate = tempDate);
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🕒 시간 선택
  Future<void> _selectTime() async {
    if (_isUnknownTime) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: _birthTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _birthTime = picked);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    DateTime finalDate = DateTime(
      _birthDate.year,
      _birthDate.month,
      _birthDate.day,
      _birthTime.hour,
      _birthTime.minute,
    );

    // ✅ 음력 선택 시 → 양력으로 변환해서 저장
    if (_isLunar) {
      try {
        final manse = await ManseLoader.load();

        // ✅ 현재 _birthDate는 양력 기준 → 그에 해당하는 음력 항목을 찾아야 함
        final match = manse.firstWhere(
              (d) =>
          d.solarYear == _birthDate.year &&
              d.solarMonth == _birthDate.month &&
              d.solarDay == _birthDate.day,
          orElse: () => throw Exception('해당 날짜의 음력 데이터를 찾을 수 없습니다.'),
        );

        // ✅ 찾은 항목의 음력 정보를 실제 저장용 양력으로 변환
        finalDate = DateTime(
          match.solarYear,
          match.solarMonth,
          match.solarDay,
          _birthTime.hour,
          _birthTime.minute,
        );

        // ✅ 추가로 해당 항목의 음력 정보 표시용으로 갱신
        setState(() {
          _isLeapMonth = match.isLeapMonth;
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ 음력 변환 중 오류가 발생했습니다. (데이터 없음)')),
        );
        return;
      }
    }

    final profile = Profile(
      name: _name,
      birthDate: finalDate, // ✅ 항상 양력으로 저장
      isLunar: _isLunar,
      isLeapMonth: _isLeapMonth,
      isUnknownTime: _isUnknownTime,
      gender: _gender,
      memo: _memo,
      id: _id,
    );

    if (!mounted) return;
    Navigator.pop(context, profile);
  }


  @override
  Widget build(BuildContext context) {
    final timeLabel = _isUnknownTime
        ? '모름'
        : '${_birthTime.hour.toString().padLeft(2, '0')}:${_birthTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 추가/수정'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 이름 + 성별
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: '이름'),
                    validator: (v) => v == null || v.isEmpty ? '이름을 입력하세요' : null,
                    onSaved: (v) => _name = v!.trim(),
                  ),
                ),
                const SizedBox(width: 16),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  color: Colors.black87,
                  fillColor: AppColors.primary,
                  isSelected: [_gender == '남', _gender == '여'],
                  onPressed: (index) {
                    setState(() => _gender = index == 0 ? '남' : '여');
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('남'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('여'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 생년월일 + 시간
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ListTile(
                    title: Text(
                      '${_birthDate.year}년 ${_birthDate.month}월 ${_birthDate.day}일',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: _selectDate,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text('시간: $timeLabel', style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.access_time),
                    onTap: _isUnknownTime ? null : _selectTime,
                  ),
                ),
              ],
            ),

            // 음력/윤달 + 시간모름
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Wrap(
                    spacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('양력'),
                        selected: !_isLunar,
                        onSelected: null,
                        disabledColor: Colors.grey.shade200,
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: _isLunar ? Colors.black54 : AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      FilterChip(
                        label: const Text('음력'),
                        selected: _isLunar,
                        onSelected: (v) => setState(() => _isLunar = v),
                      ),
                      if (_isLunar)
                        FilterChip(
                          label: const Text('윤달'),
                          selected: _isLeapMonth,
                          onSelected: (v) => setState(() => _isLeapMonth = v),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SwitchListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: const Text(
                      '시간 모름',
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding: EdgeInsets.zero,
                    value: _isUnknownTime,
                    onChanged: (v) => setState(() => _isUnknownTime = v),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 메모
            TextFormField(
              initialValue: _memo,
              decoration: const InputDecoration(labelText: '메모'),
              maxLines: 3,
              onSaved: (v) => _memo = v ?? '',
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('저장', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
