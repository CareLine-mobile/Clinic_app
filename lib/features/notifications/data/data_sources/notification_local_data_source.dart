import 'dart:convert';
import '../../../../core/db/shared_pref_helper.dart';
import '../../../../core/utils/app_constans.dart';
import '../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<PaginatedNotificationModel?> getCachedNotifications();
  Future<void> cacheNotifications(PaginatedNotificationModel paginatedModel);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  @override
  Future<PaginatedNotificationModel?> getCachedNotifications() async {
    final cached = await SharedPrefHelper.getJson(key: AppConstants.notificationsCache);
    if (cached != null) {
      return PaginatedNotificationModel.fromJson(cached);
    }
    return null;
  }

  @override
  Future<void> cacheNotifications(PaginatedNotificationModel paginatedModel) async {
    final map = {
      'data': paginatedModel.notifications.map((e) => (e as NotificationModel).toJson()).toList(),
      'meta': {
        'current_page': 1,
        'last_page': paginatedModel.hasMore ? 2 : 1,
      },
      'links': {
        'next': paginatedModel.hasMore ? 'next_link' : null,
      }
    };
    await SharedPrefHelper.saveJson(key: AppConstants.notificationsCache, value: map);
  }

  @override
  Future<void> markAsRead(String id) async {
    final cached = await getCachedNotifications();
    if (cached != null) {
      final notifications = cached.notifications.map((e) {
        if (e.id == id) {
          return NotificationModel(
            id: e.id,
            type: e.type,
            title: e.title,
            body: e.body,
            dataPayload: e.dataPayload,
            readAt: DateTime.now().toIso8601String(),
            createdAt: e.createdAt,
          );
        }
        return e as NotificationModel;
      }).toList();

      await cacheNotifications(PaginatedNotificationModel(
        notifications: notifications,
        hasMore: cached.hasMore,
      ));
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final cached = await getCachedNotifications();
    if (cached != null) {
      final notifications = cached.notifications.map((e) {
        return NotificationModel(
          id: e.id,
          type: e.type,
          title: e.title,
          body: e.body,
          dataPayload: e.dataPayload,
          readAt: e.readAt ?? DateTime.now().toIso8601String(),
          createdAt: e.createdAt,
        );
      }).toList();

      await cacheNotifications(PaginatedNotificationModel(
        notifications: notifications,
        hasMore: cached.hasMore,
      ));
    }
  }
}
