import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

class CalendarDayCell extends StatelessWidget {
  final Map<String, dynamic>? record;
  const CalendarDayCell({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    if (record == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final isHoliday = record!['holiday'] == 1;
    final dayNum = int.parse(record!['cd_sd']);

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$dayNum',
              style: AppTextStyles.body.copyWith(
                  color: isHoliday ? cs.error : cs.onSurface)),
          Text(record!['cd_hdganjee'],
              style: AppTextStyles.caption.copyWith(
                fontFamily: 'SourceHanSansSC',
                fontFamilyFallback: const ['NotoSansKR'],
                fontSize: 12,
              )),
          if (record!['cd_terms_time'] != null)
            Text(record!['cd_terms_time'],
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  color: cs.primary,
                )),
        ],
      ),
    );
  }
}
