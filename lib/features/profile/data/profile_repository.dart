import 'package:clinic_app/features/profile/data/profile_model.dart';
import 'package:clinic_app/features/profile/data/profile_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:clinic_app/core/errors/error_handler.dart';
import 'package:clinic_app/core/errors/failures.dart';


/// Direct implementation — no abstract class (as requested).
class ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  ProfileRepository(this._dataSource);

  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      return Right(await _dataSource.getProfile());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profile,bool isProfileDataExists) async {
    try {
      return Right(await _dataSource.updateProfile(profile,isProfileDataExists));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}