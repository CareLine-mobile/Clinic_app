import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_local_data_source.dart';
import '../data_sources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PaginatedNotificationEntity>> getNotifications(int page) async {
    try {
      final remoteData = await remoteDataSource.getNotifications(page);
      
      // Cache the first page
      if (page == 1) {
        await localDataSource.cacheNotifications(remoteData);
      }

      return Right(remoteData);
    } catch (e) {
      // If network/server fails, attempt to return cache for page 1
      if (page == 1) {
        final cached = await localDataSource.getCachedNotifications();
        if (cached != null) {
          return Right(cached);
        }
      }
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedNotificationEntity>> getCachedNotifications() async {
    try {
      final cached = await localDataSource.getCachedNotifications();
      if (cached != null) {
        return Right(cached);
      }
      return const Left(CacheFailure('No cached notifications found'));
    } catch (e) {
      return const Left(CacheFailure('Error reading cache'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await remoteDataSource.markAsRead(id);
      await localDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      await localDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
