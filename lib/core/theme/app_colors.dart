import 'package:flutter/material.dart';

abstract class AppColors {
  // اللون الأساسي الحكومي (الأخضر الغامق)
  static const Color primary = Color(0xFF042623);

  // لون ذهبي من الهوية
  static const Color accentGold = Color(0xFFB9A779);

  // الخلفيات (جو حكومي رسمي، دافئ شوي مو أبيض فاقع)
  static const Color backgroundLight = Color(
    0xFFEDEBE0,
  ); // من الأوف-وايت بالهوية
  static const Color backgroundDark = Color(0xFF0B0E10);

  static const Color form = Color(0xFFF7F5EE); // فورم أفتح شوي من الخلفية
  static const Color border = Color(0xFFCAC4B0); // رمادي مائل للبيج

  // البطاقات
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  // النصوص
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);

  // الحالات
  static const Color success = Color(0xFF16A34A); // أخضر مقبول وواضح
  static const Color warning = accentGold; // استغلال الذهبي كتحذير/تنبيه
  static const Color error = Color(0xFFDC2626); // أحمر واضح للأخطاء
}
