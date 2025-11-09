import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../models/saju_data.dart';
import '../services/module/shibsung_module.dart';
import '../services/module/sinsal_module.dart';
import '../services/module/unse_module.dart';
import 'saju_column.dart';

class SajuBoxView extends StatelessWidget {
  final SajuData saju;
  final Profile profile;

  const SajuBoxView({super.key, required this.saju, required this.profile});

  @override
  Widget build(BuildContext context) {
    final tenGods = ShibsungModule.interpret(saju);
    final unse = UnseModule.interpret(saju);
    final sinsal = SinsalEngine.interpret(saju);

    Map<String, List<String>> extractByJu(String juLabel) {
      final good = (sinsal['길신'] as List<dynamic>)
          .cast<String>()
          .where((s) => s.contains('($juLabel)'))
          .toList();
      final bad = (sinsal['흉신'] as List<dynamic>)
          .cast<String>()
          .where((s) => s.contains('($juLabel)'))
          .toList();
      return {'good': good, 'bad': bad};
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!profile.isUnknownTime)
          SajuColumn(
            label: '시주',
            stem: saju.hourStem,
            branch: saju.hourBranch,
            tenGods: tenGods,
            unse: unse,
            sinsal: extractByJu('시주'),
            saju: saju,
          ),
        SajuColumn(
          label: '일주',
          stem: saju.dayStem,
          branch: saju.dayBranch,
          tenGods: tenGods,
          unse: unse,
          sinsal: extractByJu('일주'),
          saju: saju,
        ),
        SajuColumn(
          label: '월주',
          stem: saju.monthStem,
          branch: saju.monthBranch,
          tenGods: tenGods,
          unse: unse,
          sinsal: extractByJu('월주'),
          saju: saju,
        ),
        SajuColumn(
          label: '년주',
          stem: saju.yearStem,
          branch: saju.yearBranch,
          tenGods: tenGods,
          unse: unse,
          sinsal: extractByJu('년주'),
          saju: saju,
        ),
      ],
    );
  }
}
