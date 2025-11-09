import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // ← AppColors를 인식시키기 위해 추가

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
    // ✅ primaryColor가 water 또는 fire이면 글씨를 흰색으로
    final bool isWater = widget.primaryColor == AppColors.water;
    final bool isFire = widget.primaryColor == AppColors.fire;
    final bool isBright = isWater || isFire; // 둘 다 어두운 배경이므로 흰색 텍스트

    final Color textColor = isBright ? const Color(0xFF222222) : const Color(0xFF222222);
    final Color subTextColor = isBright ? Colors.white : Colors.black;


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
                        backgroundColor: widget.backgroundColor,
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
                          color: textColor, //조건부 색상 적용
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
                            color: subTextColor, //조건부 색상 적용
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
