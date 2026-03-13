part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

// ─── List states ─────────────────────────────────────────────────────────────

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingEntity> bookings;
  final bool hasNextPage;
  final bool isPaginating;

  const BookingLoaded({
    required this.bookings,
    required this.hasNextPage,
    this.isPaginating = false,
  });

  BookingLoaded copyWith({
    List<BookingEntity>? bookings,
    bool? hasNextPage,
    bool? isPaginating,
  }) =>
      BookingLoaded(
        bookings: bookings ?? this.bookings,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        isPaginating: isPaginating ?? this.isPaginating,
      );

  @override
  List<Object?> get props => [bookings, hasNextPage, isPaginating];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Cancel states ────────────────────────────────────────────────────────────

class CancelBookingLoading extends BookingState {}

class CancelBookingSuccess extends BookingState {}

class CancelBookingError extends BookingState {
  final String message;
  const CancelBookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Review states ────────────────────────────────────────────────────────────

class ReviewSubmitting extends BookingState {}

class ReviewSuccess extends BookingState {}

class ReviewError extends BookingState {
  final String message;
  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}