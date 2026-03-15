import 'package:clinic_app/features/my_booking/data/data_sources/my_booking_remote_data_source.dart';
import 'package:clinic_app/features/my_booking/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/errors/result_handler.dart';
import '../../domain/entities/booking_entity.dart';
import '../model/review_request_model.dart';

class MyBookingRepositoryImpl implements MyBookingRepository {
  final MyBookingRemoteDataSource _remoteDataSource;

  const MyBookingRepositoryImpl({
    required MyBookingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<BookingListEntity> getUserBookings({int page = 1}) =>
      ResultHandler.handle(
            () => _remoteDataSource.getUserBookings(page: page),
      );

  @override
  ResultVoid cancelBooking(int bookingId) =>
      ResultHandler.handleVoid(
            () => _remoteDataSource.cancelBooking(bookingId),
      );

  @override
  ResultVoid createReview({
    required int clinicId,
    required int bookingId,
    required double rating,
    required String comment,
    int? doctorId,
  }) =>
      ResultHandler.handleVoid(
            () => _remoteDataSource.createReview(
          clinicId: clinicId,
              request: ReviewRequestModel.fromParams(
                rating: rating,
                comment: comment,
                doctorId: doctorId,
              ),
        ),
      );
}