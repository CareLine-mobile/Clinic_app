import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  final bool isFirstFetch;

  const NotificationLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final bool isPaginating;

  const NotificationLoaded({
    required this.notifications,
    required this.hasMore,
    this.isPaginating = false,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? hasMore,
    bool? isPaginating,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      hasMore: hasMore ?? this.hasMore,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object> get props => [notifications, hasMore, isPaginating];
}

class NotificationError extends NotificationState {
  final Failure failure;
  final List<NotificationEntity>? oldData;

  const NotificationError({required this.failure, this.oldData});

  @override
  List<Object> get props => [failure, if (oldData != null) oldData!];
}
