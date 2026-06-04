import 'package:flutter/material.dart';

class FooterText extends StatelessWidget {
  const FooterText({Key? key}) : super(key: key);

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
          '© 2024 نظام إدارة العقارات المتكامل. جميع الحقوق محفوظة.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}