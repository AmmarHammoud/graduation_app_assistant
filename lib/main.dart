import 'package:flutter/material.dart';
import 'package:graduation_app_assistant/features/auth/presentation/views/sign_in_view.dart';
import 'package:graduation_app_assistant/service_locator.dart' as di;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graduation App Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal',
      ),
      home: const SignInView(),
    );
  }
}
