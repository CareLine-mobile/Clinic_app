import 'package:clinic_app/features/booking/domain/repository/booking_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';

class GetUserBookingsUseCase {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  Future<Either<Failure, BookingListEntity>> call({int page = 1}) {
    return repository.getUserBookings(page: page);
  }
}