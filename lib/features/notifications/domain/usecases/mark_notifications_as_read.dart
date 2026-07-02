import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationsAsRead {
  final NotificationsRepository repository;

  MarkNotificationsAsRead(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.markAllAsRead();
  }
}
