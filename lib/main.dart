import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app_assistant/features/auth/presentation/views/sign_in_view.dart';


import 'core/services/app_logger.dart';
import 'core/services/get_it_service.dart';
import 'features/projects/presentation/views/project_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger and file logging
  await AppLogger.init();

  // Set Bloc observer so we capture cubit/bloc events
  Bloc.observer = AppBlocObserver();

  // Capture Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.instance.error('FlutterError', details.exception, details.stack);
  };

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //
  // LocalNotificationService localNotificationService = LocalNotificationService();
  //
  // await localNotificationService.initNotification();
  //
  // FCMNotificationsService fcmService = FCMNotificationsService();
  // await fcmService.initPushNotifications();

  // Initialize DI
  setupSingltonGetIt();

  // Catch any uncaught errors
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    AppLogger.instance.error('Uncaught error', error, stack);
  });
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
