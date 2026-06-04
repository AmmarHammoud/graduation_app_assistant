import 'package:flutter/material.dart';

import '../../../../../core/utils/app_images.dart';

class AuthImage extends StatelessWidget {
  const AuthImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Image.asset(AppImages.imagesSyrianLogoIconGold),
    );
  }
}
