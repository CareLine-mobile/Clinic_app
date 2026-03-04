// lib/features/booking/domain/usecases/cancel_booking_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repository/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<Either<Failure, void>> call(int bookingId) =>
      repository.cancelBooking(bookingId);
}