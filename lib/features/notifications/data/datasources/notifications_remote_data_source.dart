import '../../../../core/services/database_service.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAllAsRead();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DatabaseService _databaseService;

  NotificationsRemoteDataSourceImpl(this._databaseService);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _databaseService.getData(
      endpoint: 'notifications',
    );

    // Standard format is: response['data'] as List<dynamic>
    final notificationsList = response['data'] as List<dynamic>? ?? [];

    return notificationsList.map((item) {
      return NotificationModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  @override
  Future<void> markAllAsRead() async {
    // Standard Laravel API read-all route or a custom mock updating is_read states
    await _databaseService.addData(
      endpoint: 'notifications/read-all',
      data: {},
    );
  }
}
