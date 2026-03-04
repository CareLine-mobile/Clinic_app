// lib/features/booking/presentation/cubit/booking_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/appointment_request_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_user_bookings_usecase.dart';
import '../../domain/usecases/make_appointment_usecase.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final MakeAppointmentUseCase makeAppointmentUseCase;
  final CancelBookingUseCase cancelBookingUseCase; // ← new

  BookingCubit({
    required this.getUserBookingsUseCase,
    required this.makeAppointmentUseCase,
    required this.cancelBookingUseCase,
  }) : super(BookingInitial());

  int _currentPage = 1;

  Future<void> loadBookings() async {
    emit(BookingLoading());
    _currentPage = 1;

    final result = await getUserBookingsUseCase(page: _currentPage);
    result.fold(
          (failure) => emit(BookingError(failure.message)),
          (bookingList) => emit(BookingLoaded(
        bookings: bookingList.data,
        hasNextPage: bookingList.hasNextPage,
      )),
    );
  }

  Future<void> loadMoreBookings() async {
    final currentState = state;
    if (currentState is! BookingLoaded) return;
    if (!currentState.hasNextPage || currentState.isPaginating) return;

    emit(currentState.copyWith(isPaginating: true));
    _currentPage++;

    final result = await getUserBookingsUseCase(page: _currentPage);
    result.fold(
          (failure) {
        _currentPage--;
        emit(currentState.copyWith(isPaginating: false));
        emit(BookingError(failure.message));
      },
          (bookingList) => emit(BookingLoaded(
        bookings: [...currentState.bookings, ...bookingList.data],
        hasNextPage: bookingList.hasNextPage,
      )),
    );
  }

  Future<void> makeAppointment({
    required int clinicalId,
    required String doctorId,
    required String date,
    required String time,
    String? notes,
  }) async {
    emit(AppointmentLoading());

    final result = await makeAppointmentUseCase(
      AppointmentRequestEntity(
        clinicalId: clinicalId,
        doctorId: doctorId,
        date: date,
        time: time,
        notes: notes,
      ),
    );

    result.fold(
          (failure) => emit(AppointmentError(failure.message)),
          (_) => emit(AppointmentSuccess()),
    );
  }

  // ─── Cancel booking — only callable for 'pending' status ───────────────
  Future<void> cancelBooking(int bookingId) async {
    emit(CancelBookingLoading());

    final result = await cancelBookingUseCase(bookingId);

    result.fold(
          (failure) => emit(CancelBookingError(failure.message)),
          (_) => emit(CancelBookingSuccess()),
    );
  }
}