import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/mutqin_logo.dart';
import 'footer_text.dart';
import 'login_card.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Mutqin High-Fidelity Brand Logo
                  const MutqinLogo(size: 64, isDark: false),
                  const SizedBox(height: 24),
                  
                  // Main Login Card
                  const LoginCard(),
                  const SizedBox(height: 32),

                  // Bottom Footer
                  const FooterText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
