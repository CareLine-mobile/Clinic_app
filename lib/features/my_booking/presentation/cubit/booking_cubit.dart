import 'package:bloc/bloc.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/CreateReviewUseCase.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/cancel_booking_usecase.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/get_user_bookings_usecase.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entity.dart';
part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetUserBookingsUseCase _getUserBookings;
  final CancelBookingUseCase _cancelBooking;
  final CreateReviewUseCase _createReview;

  BookingCubit({
    required GetUserBookingsUseCase getUserBookings,
    required CancelBookingUseCase cancelBooking,
    required CreateReviewUseCase createReview,
  })  : _getUserBookings = getUserBookings,
        _cancelBooking = cancelBooking,
        _createReview = createReview,
        super(BookingInitial());

  int _currentPage = 1;

  // ─── Load / paginate bookings ───────────────────────────────────────────

  Future<void> loadBookings() async {
    emit(BookingLoading());
    _currentPage = 1;

    final result = await _getUserBookings(page: _currentPage);
    result.fold(
          (failure) => emit(BookingError(failure.message)),
          (list) => emit(BookingLoaded(
        bookings: list.data,
        hasNextPage: list.hasNextPage,
      )),
    );
  }

  Future<void> loadMoreBookings() async {
    final current = state;
    if (current is! BookingLoaded) return;
    if (!current.hasNextPage || current.isPaginating) return;

    emit(current.copyWith(isPaginating: true));
    _currentPage++;

    final result = await _getUserBookings(page: _currentPage);
    result.fold(
          (failure) {
        _currentPage--;
        emit(current.copyWith(isPaginating: false));
        emit(BookingError(failure.message));
      },
          (list) => emit(BookingLoaded(
        bookings: [...current.bookings, ...list.data],
        hasNextPage: list.hasNextPage,
      )),
    );
  }

  // ─── Cancel booking ─────────────────────────────────────────────────────

  Future<void> cancelBooking(int bookingId) async {
    emit(CancelBookingLoading());
    final result = await _cancelBooking(bookingId);
    result.fold(
          (failure) => emit(CancelBookingError(failure.message)),
          (_) => emit(CancelBookingSuccess()),
    );
  }

  // ─── Submit review (only for completed bookings) ─────────────────────────

  Future<void> submitReview(CreateReviewParams params) async {
    emit(ReviewSubmitting());
    final result = await _createReview(params);
    result.fold(
          (failure) => emit(ReviewError(failure.message)),
          (_) => emit(ReviewSuccess()),
    );
  }
}