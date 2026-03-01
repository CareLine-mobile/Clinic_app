// lib/features/auth/data/repositories/auth_repository_impl.dart
// ============================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result_handler.dart';
import '../../../user_data/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    return await ResultHandler.handle(() async {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.cacheUser(userModel);
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await ResultHandler.handle(() async {
      return await remoteDataSource.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
    });
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return await ResultHandler.handle(() async {
      final userModel = await localDataSource.getCachedUser();
      if (userModel == null) {
        throw Exception('No cached user found');
      }
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    return await ResultHandler.handle(() async {
      final userModel = await localDataSource.getCachedUser();
      return userModel?.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return await ResultHandler.handleVoid(() async {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
    });
  }

  @override
  Future<Either<Failure, void>> saveUserLocally(User user) async {
    return await ResultHandler.handleVoid(() async {
      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        avatar: user.avatar,
        token: user.token,
        emailVerifiedAt: user.emailVerifiedAt,
      );
      await localDataSource.cacheUser(userModel);
    });
  }
}