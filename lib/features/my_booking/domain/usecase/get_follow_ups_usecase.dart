import 'package:clinic_app/features/my_booking/domain/repositories/review_repository.dart';
import '../../../../../../core/errors/result_handler.dart';
import '../entities/booking_entity.dart';

class GetFollowUpsUseCase {
  final MyBookingRepository _repository;

  const GetFollowUpsUseCase(this._repository);

  ResultFuture<List<BookingEntity>> call({required int bookingId}) =>
      _repository.getFollowUps(bookingId);
}
