part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

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
  }) {
    return BookingLoaded(
      bookings: bookings ?? this.bookings,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object?> get props => [bookings, hasNextPage, isPaginating];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Appointment states
class AppointmentLoading extends BookingState {}

class AppointmentSuccess extends BookingState {}

class AppointmentError extends BookingState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}