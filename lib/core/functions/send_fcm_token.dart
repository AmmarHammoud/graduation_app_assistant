import 'package:flutter/widgets.dart';

import '../repo/send_fcm_token.dart';
import '../services/database_service.dart';
import '../services/fcm_notification_service.dart';
import '../services/get_it_service.dart';

void sendFCMToken() {
  final sendFcmToken = SendFcmToken(
    databaseService: getIt.get<DatabaseService>(),
  );
  final fcmService = FCMNotificationsService();

  fcmService
      .initNotifications((newToken) async {
    final result = await sendFcmToken.sendTokenToServer(newToken);
    result.fold((failure) {
      debugPrint('Error sending refreshed token: ${failure.errMessage}');
    }, (_) => debugPrint('Refreshed token sent ✅'));
  })
      .then((token) async {
    if (token != null && token.isNotEmpty) {
      final result = await sendFcmToken.sendTokenToServer(token);
      result.fold((failure) {
        debugPrint('Error sending token: ${failure.errMessage}');
      }, (_) => debugPrint('Token sent ✅'));
    }
  });
}