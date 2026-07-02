import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  /// Fetches notifications for the assistant.
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// Marks all unread notifications as read.
  Future<Either<Failure, void>> markAllAsRead();
}
