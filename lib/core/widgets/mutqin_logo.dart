import 'package:flutter/material.dart';

class MutqinIcon extends StatelessWidget {
  final double size;
  final bool isDark;

  const MutqinIcon({super.key, this.size = 48, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final double squareSize = (size - 6) / 2;
    final Color normalColor = isDark ? Colors.white : const Color(0xFF1C2624);
    final Color goldColor = const Color(0xFFC99A46);
    final double borderRadiusValue = (size * 0.08).clamp(2, 6).toDouble();

    return SizedBox(
      width: size,
      height: size,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: size * 0.08,
        crossAxisSpacing: size * 0.08,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Top Left Rounded Square
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: normalColor, width: (size * 0.05).clamp(1.5, 3.0)),
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
          ),
          // Top Right Rounded Square
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: normalColor, width: (size * 0.05).clamp(1.5, 3.0)),
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
          ),
          // Bottom Left Rounded Square
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: normalColor, width: (size * 0.05).clamp(1.5, 3.0)),
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
          ),
          // Bottom Right Solid Gold Square with Checkmark
          Container(
            decoration: BoxDecoration(
              color: goldColor,
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
            child: Center(
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: size * 0.32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MutqinLogo extends StatelessWidget {
  final double size;
  final bool isDark;
  final bool showText;

  const MutqinLogo({
    super.key,
    this.size = 48,
    this.isDark = false,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color inkColor = isDark ? Colors.white : const Color(0xFF1C2624);
    final Color stoneColor = isDark ? Colors.white70 : const Color(0xFF8B8478);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MutqinIcon(size: size, isDark: isDark),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'مُتْقِن',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: size * 0.55,
              fontWeight: FontWeight.bold,
              color: inkColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'M U T Q I N',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: size * 0.22,
              fontWeight: FontWeight.w600,
              color: inkColor,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'منصة إكساء الشقق السكنية',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: size * 0.26,
              fontWeight: FontWeight.w500,
              color: stoneColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}
