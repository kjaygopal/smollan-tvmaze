import 'package:flutter/material.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onTap;

  const FloatingBottomNavBar({
    super.key,
    required this.controller,
    required this.onTap,
  });

  /// Store DATA, not widgets
  static final List<Icon> items = [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.favorite),
  ];

  static const double itemWidth = 49;
  static const double indicatorSize = 55;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? controller.page ?? 1 : 1;

        return SizedBox(
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              /// NAVBAR BACKGROUND
              Positioned(
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: SizedBox(width: items.length * itemWidth, height: 25),
                ),
              ),

              /// FLOATING INDICATOR (BEHIND ICON)
              Positioned(
                bottom: 0,
                left: _indicatorLeft(context, page),
                child: Container(
                  width: indicatorSize,
                  height: indicatorSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 14,
                        offset: Offset(0, 4),
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
              ),

              /// ICON ROW (ON TOP)
              Positioned(
                bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(items.length, (i) {
                    final bool selected = (page.round() == i);

                    // final color = selected
                    //     ? Theme.of(context).colorScheme.primary
                    //     : Theme.of(context).colorScheme.primary;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: SizedBox(
                        width: itemWidth,
                        height: 56,
                        child: Center(
                          child: AnimatedScale(
                            scale: selected ? 1.20 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: items[i],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _indicatorLeft(BuildContext context, num page) {
    final totalWidth = items.length * itemWidth;
    final startX = (MediaQuery.of(context).size.width - totalWidth) / 2;

    return startX + (page * itemWidth) + (itemWidth / 2) - (indicatorSize / 2);
  }
}
