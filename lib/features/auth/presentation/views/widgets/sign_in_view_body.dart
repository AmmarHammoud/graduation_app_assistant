import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../cubits/sign_in/sign_in_cubit.dart';
import 'AuthImage.dart';
import 'SignInTextFieldSection.dart';
import 'footer_text.dart';
import 'login_card.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF7F9FC), // Soft light background tint
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Header Section
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF111827),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.domain, // Placeholder building icon
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Project Owner',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'أهلاً بك مجدداً. يرجى إدخال بياناتك للوصول\nإلى لوحة التحكم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Main Login Card
                const LoginCard(),
                const SizedBox(height: 40),

                // Bottom Footer
                const FooterText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:loading_indicator/loading_indicator.dart';
//
// import '../../../../../core/theme/app_text_styles.dart';
// import '../../cubits/sign_in/sign_in_cubit.dart';
// import 'AuthImage.dart';
// import 'SignInTextFieldSection.dart';
//
// class SignInViewBody extends StatefulWidget {
//   const SignInViewBody({super.key});
//
//   @override
//   State<SignInViewBody> createState() => _SignInViewBodyState();
// }
//
// class _SignInViewBodyState extends State<SignInViewBody> {
//   final _formKey = GlobalKey<FormBuilderState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32),
//       child: ListView(
//         children: [
//           SizedBox(height: 48),
//           // AuthImage(),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 32),
//             child: Text('تسجيل الدخول', style: AppTextStyles.headlineSmall),
//           ),
//           SignInTextFieldSection(formKey: _formKey),
//           SizedBox(
//             width: 200,
//             child: BlocBuilder<SignInCubit, SignInState>(
//               builder: (context, state) {
//                 return AbsorbPointer(
//                   absorbing: state is SignInLoading,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState?.saveAndValidate() ?? false) {
//                         final email =
//                             _formKey.currentState?.value['email'] as String;
//                         final password =
//                             _formKey.currentState?.value['password'] as String;
//                         context.read<SignInCubit>().signIn(email, password);
//                       }
//                     },
//                     child: state is SignInLoading
//                         ? SizedBox(
//                             width: 25,
//                             child: LoadingIndicator(
//                               indicatorType: Indicator.ballPulse,
//                               colors: [Colors.white],
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Text('تسجيل الدخول'),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'ليس لديك حساب؟',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//           SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
// }
