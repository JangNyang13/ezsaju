import 'package:flutter/material.dart';

class SajuCard extends StatelessWidget {
  final String title;
  final String value;

  const SajuCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 72,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }
}
