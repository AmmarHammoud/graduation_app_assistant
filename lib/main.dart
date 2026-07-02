import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graduation_app_assistant/core/services/token_storage.dart';
import 'package:graduation_app_assistant/features/auth/presentation/views/sign_in_view.dart';


import 'core/services/app_logger.dart';
import 'core/services/fcm_notification_service.dart';
import 'core/services/get_it_service.dart';
import 'core/services/local_notification_service.dart';
import 'firebase_options.dart';

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LocalNotificationService localNotificationService = LocalNotificationService();

  await localNotificationService.initNotification();

  FCMNotificationsService fcmService = FCMNotificationsService();
  await fcmService.initPushNotifications();

  // Initialize DI
  setupSingltonGetIt();

  // Catch any uncaught errors
  runZonedGuarded(() async {
    runApp(MyApp(userSignedIn: await TokenStorage().readAccess() != null));
  }, (error, stack) {
    AppLogger.instance.error('Uncaught error', error, stack);
  });
}

class MyApp extends StatelessWidget {
  final bool userSignedIn;
  const MyApp({super.key, required this.userSignedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graduation App Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'AE'),
      home:
      // userSignedIn ? BlocProvider(
      //   create: (context) => getIt<AssignedProjectsCubit>()..loadDashboard('الكل'),
      //   child: const AssistantDashboardPage(),
      // ) :
      SignInView(),
    );
  }
}
