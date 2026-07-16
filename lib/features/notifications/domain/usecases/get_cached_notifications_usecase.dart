import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetCachedNotificationsUseCase {
  final NotificationRepository repository;

  GetCachedNotificationsUseCase(this.repository);

  Future<Either<Failure, PaginatedNotificationEntity>> call() async {
    return await repository.getCachedNotifications();
  }
}
