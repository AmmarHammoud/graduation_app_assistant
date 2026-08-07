import 'package:flutter/material.dart';

abstract class AppColors {
  // اللون الأساسي: حبر (Ink)
  static const Color primary = Color(0xFF1C2624);

  // لون اللمسة: ذهب نحاسي (Brass Gold)
  static const Color accentGold = Color(0xFFC99A46);

  // الخلفية: ورق (Paper)
  static const Color backgroundLight = Color(0xFFF6F2EA);
  static const Color backgroundDark = Color(0xFF0F1211); // Ink based dark bg

  // الحقول والحدود
  static const Color form = Color(0xFFFFFFFF); // أبيض ناصع للتباين فوق الخلفية الورقية
  static const Color border = Color(0xFFDCD8CF); // رمادي حجري فاتح متناغم

  // البطاقات
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1B2321); // Ink based dark card

  // النصوص
  static const Color textDark = Color(0xFF1C2624); // اللون الأساسي كحبر للنصوص الداكنة
  static const Color textGrey = Color(0xFF8B8478); // لون الحجر (Stone) للنصوص الثانوية

  // الحالات
  static const Color success = Color(0xFF006D5B); // أخضر أنيق متناغم مع الحبر والذهب
  static const Color warning = Color(0xFFE28A2B); // برتقالي نحاسي دافئ للتحذير
  static const Color error = Color(0xFFBC3434); // أحمر قرميدي للأخطاء
}
