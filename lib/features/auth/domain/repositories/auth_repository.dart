import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

// lib/features/auth/domain/repositories/auth_repository.dart

import '../entities/user.dart';

abstract class AuthRepository {

  Future<User> login({
    required String email,
    required String password,
  });

  Future<String> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });


  Future<User> getCurrentUser();


  Future<void> logout();


  Future<void> saveUserLocally(User user);


  Future<User?> getCachedUser();
}