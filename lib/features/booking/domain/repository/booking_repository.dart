// lib/features/booking/domain/repository/booking_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment_request_entity.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingListEntity>> getUserBookings({int page = 1});
  Future<Either<Failure, void>> makeAppointment(AppointmentRequestEntity request);
  Future<Either<Failure, void>> cancelBooking(int bookingId); // ← new
}