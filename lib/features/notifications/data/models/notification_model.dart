import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.dataPayload,
    super.readAt,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final dataNode = json['data'] as Map<String, dynamic>? ?? {};
    return NotificationModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: dataNode['title'] as String? ?? '',
      body: dataNode['body'] as String? ?? '',
      dataPayload: dataNode['data'] as Map<String, dynamic>? ?? {},
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': {
        'title': title,
        'body': body,
        'data': dataPayload,
      },
      'read_at': readAt,
      'created_at': createdAt,
    };
  }
}

class PaginatedNotificationModel extends PaginatedNotificationEntity {
  const PaginatedNotificationModel({
    required super.notifications,
    required super.hasMore,
  });

  factory PaginatedNotificationModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final notifications = dataList
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final links = json['links'] as Map<String, dynamic>? ?? {};

    final currentPage = meta['current_page'] as int? ?? 1;
    final lastPage = meta['last_page'] as int? ?? 1;
    final nextLink = links['next'];

    final hasMore = (currentPage < lastPage) || (nextLink != null);

    return PaginatedNotificationModel(
      notifications: notifications,
      hasMore: hasMore,
    );
  }
}
