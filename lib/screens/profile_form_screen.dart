import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/profile_model.dart';
import '../providers/selected_profile_provider.dart';
import '../providers/theme_provider.dart'; // profilesProvider 들어있음
import '../constants/app_colors.dart';
import '../services/manse_loader.dart';
import '../screens/saju_viewer_screen.dart';

class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();

  bool _isUnknownTime = false;
  bool _isLunar = false;
  bool _isLeapMonth = false;
  String _gender = '남';
  Profile? _editingProfile;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Profile) {
        setState(() {
          _editingProfile = args;
          _nameController.text = args.name;

          // 음력 저장된 경우 원본 값으로 복원
          if (args.isLunar && args.lunarYear != null) {
            _birthController.text =
            '${args.lunarYear!.toString().padLeft(4, '0')}${args.lunarMonth!.toString().padLeft(2, '0')}${args.lunarDay!.toString().padLeft(2, '0')}';
          } else {
            // 양력 저장된 경우 그대로 표시
            _birthController.text =
            '${args.birthDate.year.toString().padLeft(4, '0')}${args.birthDate.month.toString().padLeft(2, '0')}${args.birthDate.day.toString().padLeft(2, '0')}';
          }

          _hourController.text = args.isUnknownTime
              ? ''
              : args.birthDate.hour.toString().padLeft(2, '0');
          _minuteController.text = args.isUnknownTime
              ? ''
              : args.birthDate.minute.toString().padLeft(2, '0');
          _isUnknownTime = args.isUnknownTime;
          _isLunar = args.isLunar;
          _isLeapMonth = args.isLeapMonth;
          _gender = args.gender;
        });
      }
    });
  }


  // ----------------------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  bool _validateDate(String v) {
    if (v.length != 8) {
      _showError('생년월일은 8자리로 입력하세요 (예: 19981231)');
      return false;
    }

    final year = int.tryParse(v.substring(0, 4)) ?? 0;
    final month = int.tryParse(v.substring(4, 6)) ?? 0;
    final day = int.tryParse(v.substring(6, 8)) ?? 0;

    if (year < 1900 || year > 2100) {
      _showError('연도는 1900~2100 사이여야 합니다.');
      return false;
    }
    if (month < 1 || month > 12) {
      _showError('월은 1~12 사이여야 합니다.');
      return false;
    }
    if (day < 1 || day > 31) {
      _showError('일은 1~31 사이여야 합니다.');
      return false;
    }
    return true;
  }

  bool _validateTime() {
    if (_isUnknownTime) return true;

    final hour = int.tryParse(_hourController.text) ?? -1;
    final minute = int.tryParse(_minuteController.text) ?? -1;
    if (hour < 0 || hour > 23) {
      _showError('시간(시)은 0~23 사이여야 합니다.');
      return false;
    }
    if (minute < 0 || minute > 59) {
      _showError('분은 0~59 사이여야 합니다.');
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    final v = _birthController.text.trim();
    if (!_validateDate(v) || !_validateTime()) return;

    final year = int.parse(v.substring(0, 4));
    final month = int.parse(v.substring(4, 6));
    final day = int.parse(v.substring(6, 8));
    final hour = _isUnknownTime ? 12 : int.tryParse(_hourController.text) ?? 12;
    final minute = _isUnknownTime ? 0 : int.tryParse(_minuteController.text) ?? 0;

    // 🔹 기본적으로 입력값 기준 날짜 생성
    DateTime birthDate = DateTime(year, month, day, hour, minute);

    // 🔹 음력 입력 시 -> 양력으로 변환
    if (_isLunar) {
      try {
        final converted = await ManseLoader.lunarToSolar(
          lunarYear: year,
          lunarMonth: month,
          lunarDay: day,
          isLeapMonth: _isLeapMonth,
        );
        if (converted != null) {
          birthDate = DateTime(
            converted.year,
            converted.month,
            converted.day,
            hour,
            minute,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('⚠️ 음력 변환 실패: $e')),
          );
        }
      }
    }

    // 프로필 객체 생성 (양력 기준으로 저장) 음력 입력 시 원본도 함께 저장
    final newProfile = Profile(
      id: _editingProfile?.id ?? const Uuid().v4(),
      name: _nameController.text.trim().isEmpty ? '이름없음' : _nameController.text.trim(),
      birthDate: birthDate,
      isLunar: _isLunar,
      isLeapMonth: _isLeapMonth,
      isUnknownTime: _isUnknownTime,
      gender: _gender,
      memo: '',
      lunarYear: _isLunar ? year : null,
      lunarMonth: _isLunar ? month : null,
      lunarDay: _isLunar ? day : null,
    );

    // 로딩 다이얼로그 표시
    if(!mounted)return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ManseLoader.load(); // 🔹 만세력 데이터 캐시 로드
    } finally {
      if (mounted) Navigator.pop(context);
    }

    final profilesNotifier = ref.read(profilesProvider.notifier);

    // 1. 추가 또는 수정
    if (_editingProfile == null) {
      await profilesNotifier.addProfile(newProfile);
    } else {
      await profilesNotifier.updateProfile(newProfile);
    }

    // 2. 선택 프로필로 지정
    await ref.read(selectedProfileProvider.notifier).select(newProfile);

    // 3. 사주 보기로 이동
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SajuViewerScreen(profileOverride: newProfile),
      ),
    );
  }


  // ----------------------------
  @override
  Widget build(BuildContext context) {
    final isEditMode = _editingProfile != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '프로필 수정' : '프로필 입력'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // 이름 + 성별
                const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(8),
                        selectedColor: Colors.white,
                        fillColor: AppColors.primary,
                        isSelected: [_gender == '남', _gender == '여'],
                        onPressed: (index) {
                          setState(() => _gender = index == 0 ? '남' : '여');
                        },
                        constraints:
                        const BoxConstraints(minHeight: 40, minWidth: 48),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text('남'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text('여'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 생년월일 + 양력/음력/윤달
                const Text('생년월일 (8자리)', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _birthController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: const InputDecoration(
                          hintText: '19981231',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterChip(
                            showCheckmark: false,
                            label: const Text('양력'),
                            selected: !_isLunar,
                            onSelected: (v) {
                              setState(() {
                                _isLunar = false;
                                _isLeapMonth = false;
                              });
                            },
                            backgroundColor: Colors.grey.shade200,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: !_isLunar ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          FilterChip(
                            showCheckmark: false,
                            label: const Text('음력'),
                            selected: _isLunar,
                            onSelected: (v) {
                              setState(() {
                                _isLunar = v;
                                if (!v) _isLeapMonth = false;
                              });
                            },
                            backgroundColor: Colors.grey.shade200,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _isLunar ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          FilterChip(
                            showCheckmark: false,
                            label: const Text('윤달'),
                            selected: _isLeapMonth && _isLunar,
                            onSelected: _isLunar
                                ? (v) => setState(() => _isLeapMonth = v)
                                : null,
                            backgroundColor: _isLunar
                                ? Colors.grey.shade200
                                : Colors.grey.withValues(alpha: 0.3),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _isLeapMonth && _isLunar
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 시간
                const Text('출생 시간', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hourController,
                        enabled: !_isUnknownTime,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(hintText: '시 (0~23)',hintStyle: TextStyle(color: Colors.grey),),
                        onChanged: (v) {
                          if (v.length == 2) FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _minuteController,
                        enabled: !_isUnknownTime,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(hintText: '분 (0~59)',hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: _isUnknownTime,
                      onChanged: (v) => setState(() => _isUnknownTime = v ?? false),
                    ),
                    const Text('모름'),
                  ],
                ),
                const SizedBox(height: 24),

                // 저장 후 보기
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isEditMode ? '수정 후 사주 보기' : '저장 후 사주 보기',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
