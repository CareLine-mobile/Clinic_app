// lib/features/booking/data/repository/booking_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result_handler.dart';
import '../../domain/entities/appointment_request_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repository/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../model/appointment_request_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BookingListEntity>> getUserBookings({int page = 1}) async {
    return ResultHandler.handle(() async {
      final result = await remoteDataSource.getUserBookings(page: page);
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> makeAppointment(AppointmentRequestEntity request) async {
    return ResultHandler.handle(() async {
      await remoteDataSource.makeAppointment(
        AppointmentRequestModel(
          clinicalId: request.clinicalId,
          doctorId: request.doctorId,
          date: request.date,
          time: request.time,
          notes: request.notes,
        ),
      );
    });
  }

  @override
  Future<Either<Failure, void>> cancelBooking(int bookingId) async {
    return ResultHandler.handle(() async {
      await remoteDataSource.cancelBooking(bookingId);
    });
  }
}