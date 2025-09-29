import 'package:flutter/material.dart';
import '../models/analysis_report.dart';

class StrengthDetailScreen extends StatelessWidget {
  final AnalysisReport report;

  const StrengthDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("신강도 해석 - ${report.strengthLevel}")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("신강도: ${report.strengthScore} (${report.strengthLevel})"),
          const SizedBox(height: 12),

          if (report.patterns.isNotEmpty)
            Text("격국: ${report.patterns.join(', ')}"),
          if (report.eokbu.isNotEmpty)
            Text("억부용신: ${report.eokbu.join(', ')}"),
          if (report.johu.isNotEmpty)
            Text("조후용신: ${report.johu.join(', ')}"),
          if (report.unhelpfulGods.isNotEmpty)
            Text("기신(꺼리는 요소): ${report.unhelpfulGods.join(', ')}"),
          if (report.reasons.isNotEmpty) ...report.reasons.map((r) => Text(r)),


          const SizedBox(height: 20),
          Divider(),

          // 긴 내러티브 출력
          ...report.narrations.map((line) {
            final isCategory = line.startsWith("🔎") ||
                line.startsWith("💼") ||
                line.startsWith("💖") ||
                line.startsWith("🤝") ||
                line.startsWith("🎯");
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line,
                style: isCategory
                    ? TextStyle(fontWeight: FontWeight.bold, color: scheme.primary)
                    : TextStyle(color: scheme.onSurface),
              ),
            );
          }),
        ],
      ),
    );
  }
}
