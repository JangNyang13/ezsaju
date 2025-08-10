// lib/widgets/bubbled_nav_bar.dart
// ------------------------------------------------------------------
// Flat Capsule‑Indicator Navigation Bar – Icon‑only, Rectangular
//   • 커브(모서리 라운드) 제거, 아이콘 32
//   • 상단 캡슐 인디케이터 슬라이드
// ------------------------------------------------------------------

import 'package:flutter/material.dart';

class BubbledNavBar extends StatefulWidget {
  const BubbledNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 64,
    this.indicatorHeight = 3,
    this.borderRadius = 0, // ⬅︎ 라운드 제거 (0)
    required this.backgroundColor,
    required this.activeColor,
    required this.inactiveColor,
  });

  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final double height;
  final double indicatorHeight;
  final double borderRadius;

  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<BubbledNavBar> createState() => _BubbledNavBarState();
}

class _BubbledNavBarState extends State<BubbledNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<double> _posAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _posAnim = AlwaysStoppedAnimation(widget.currentIndex.toDouble());
  }

  @override
  void didUpdateWidget(covariant BubbledNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _posAnim = Tween<double>(
        begin: _posAnim.value,
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width / widget.items.length;
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius > 0
                ? BorderRadius.circular(widget.borderRadius)
                : null,   // ⬅︎ 모서리 커브 제거
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // Capsule indicator
              AnimatedBuilder(
                animation: _posAnim,
                builder: (context, _) {
                  return Positioned(
                    top: 0,
                    left: _posAnim.value * itemWidth + itemWidth * 0.2,
                    width: itemWidth * 0.6,
                    child: Container(
                      height: widget.indicatorHeight,
                      decoration: BoxDecoration(
                        color: widget.activeColor,
                        borderRadius: BorderRadius.circular(widget.indicatorHeight),
                      ),
                    ),
                  );
                },
              ),
              // Icon buttons (label hidden)
              Row(
                children: List.generate(widget.items.length, (i) {
                  final selected = i == widget.currentIndex;
                  final color = selected ? widget.activeColor : widget.inactiveColor;
                  return Expanded(
                    child: InkWell(
                      onTap: () => widget.onTap(i),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Center(
                        child: Icon(
                          widget.items[i].icon,
                          color: color,
                          size: 38,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavBarItem {
  const NavBarItem({required this.icon, this.label = ''});
  final IconData icon;
  final String label; // unused
}
