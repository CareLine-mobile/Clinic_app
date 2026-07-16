import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> dataPayload;
  final String? readAt;
  final String createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.dataPayload,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt != null;

  @override
  List<Object?> get props => [id, type, title, body, dataPayload, readAt, createdAt];
}

class PaginatedNotificationEntity extends Equatable {
  final List<NotificationEntity> notifications;
  final bool hasMore;

  const PaginatedNotificationEntity({
    required this.notifications,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [notifications, hasMore];
}
