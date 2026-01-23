import 'dart:math';
import 'package:flutter/material.dart';

class WavyTermBar extends StatefulWidget {
  final String label;
  final String? subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  const WavyTermBar({
    super.key,
    required this.label,
    this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  State<WavyTermBar> createState() => _WavyTermBarState();
}

class _WavyTermBarState extends State<WavyTermBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 절기 바는 항상 밝은 흰색 계열로
    final Color fixedPastelBg = const Color(0xFFFAF9F6);

    // ✅ 기존 primary/secondary는 그대로 사용
    final textColor = const Color(0xFF222222);
    final subTextColor = Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, _) {
                    final t = (_controller.lastElapsedDuration?.inMilliseconds ?? 0) / 1000.0;
                    return CustomPaint(
                      painter: _WavePainter(
                        time: t,
                        color1: widget.primaryColor,
                        color2: widget.secondaryColor,
                        // ✅ 다크모드 여부와 상관없이 밝은 배경 유지
                        backgroundColor: fixedPastelBg,
                      ),
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          widget.subtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: subTextColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class _WavePainter extends CustomPainter {
  final double time;
  final Color color1;
  final Color color2;
  final Color backgroundColor;

  const _WavePainter({
    required this.time,
    required this.color1,
    required this.color2,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final baseHeight = size.height * 0.4;
    const waveHeight1 = 6.0;
    const waveHeight2 = 9.0;

    const speed1 = 0.3;
    const speed2 = 0.45;
    const freq1 = 2 * pi / 240;
    const freq2 = 2 * pi / 200;
    const phaseShift = pi / 3;

    final path1 = Path();
    final path2 = Path();

    for (double x = 0; x <= size.width; x++) {
      final y1 = baseHeight + sin(x * freq1 + time * speed1 * 2 * pi) * waveHeight1;
      final y2 = baseHeight + sin(x * freq2 + time * speed2 * 2 * pi + phaseShift) * waveHeight2;
      if (x == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }

    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [color1.withValues(alpha: 0.6), color1.withValues(alpha: 0.3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [color2.withValues(alpha: 0.35), color2.withValues(alpha: 0.15)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => oldDelegate.time != time;
}
