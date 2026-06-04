import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';
import 'local_notification_service.dart';

class FCMNotificationsService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotifications(
      void Function(String)? onTokenRefresh,
      ) async {
    final settings = await _firebaseMessaging.requestPermission();

    final status = settings.authorizationStatus;

    if (status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional) {
      final fcmToken = await _firebaseMessaging.getToken();

      if (onTokenRefresh != null) {
        _firebaseMessaging.onTokenRefresh.listen(onTokenRefresh);
      }

      return fcmToken;
    }

    return null;
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigatorKey.currentState?.pushNamed(
    //   MainView.routename,
    //   arguments: message,
    // );
  }

  Future<void> initPushNotifications() async {
    // app terminated state
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);
    //app in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService localNotiService = LocalNotificationService();
      localNotiService.showNotification(
        id: message.hashCode,
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });
  }
}