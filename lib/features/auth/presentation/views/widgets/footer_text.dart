import 'package:flutter/material.dart';

class FooterText extends StatelessWidget {
  const FooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visual baseline indicator line matching the UI layout context
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '© 2026 منصة مُتْقِن لإكساء الشقق السكنية. جميع الحقوق محفوظة.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF8B8478), // Use Stone gray color
            height: 1.5,
          ),
        ),
      ],
    );
  }
}