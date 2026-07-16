import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_cached_notifications_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_as_read_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetCachedNotificationsUseCase getCachedNotificationsUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  int _currentPage = 1;
  bool _hasMore = true;
  final List<NotificationEntity> _notifications = [];

  NotificationCubit({
    required this.getCachedNotificationsUseCase,
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
  }) : super(NotificationInitial());

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _notifications.clear();
      // Only show loading if we are explicitly refreshing or starting fresh
      emit(const NotificationLoading(isFirstFetch: true));
    } else {
      if (_currentPage == 1) {
        // Try to load cache first to show UI instantly
        final cached = await getCachedNotificationsUseCase();
        cached.fold(
          (failure) {}, // Ignore cache miss
          (paginated) {
            if (_notifications.isEmpty) { // Only if we haven't loaded anything yet
              _notifications.addAll(paginated.notifications);
              _hasMore = paginated.hasMore;
              emit(NotificationLoaded(
                notifications: List.from(_notifications),
                hasMore: _hasMore,
                isPaginating: false,
              ));
            }
          },
        );
        // If we still have no data, show loading
        if (_notifications.isEmpty) {
          emit(const NotificationLoading(isFirstFetch: true));
        }
      } else {
        if (!_hasMore) return;
        emit(NotificationLoaded(
          notifications: List.from(_notifications),
          hasMore: _hasMore,
          isPaginating: true,
        ));
      }
    }

    final result = await getNotificationsUseCase(_currentPage);

    result.fold(
      (failure) {
        if (_notifications.isNotEmpty) {
          emit(NotificationError(failure: failure, oldData: _notifications));
        } else {
          emit(NotificationError(failure: failure));
        }
      },
      (paginatedData) {
        if (refresh || _currentPage == 1) {
          _notifications.clear();
        }

        // Merge logic: avoid duplicates based on id
        for (var notif in paginatedData.notifications) {
          if (!_notifications.any((e) => e.id == notif.id)) {
            _notifications.add(notif);
          }
        }

        _hasMore = paginatedData.hasMore;
        _currentPage++;

        emit(NotificationLoaded(
          notifications: List.from(_notifications),
          hasMore: _hasMore,
          isPaginating: false,
        ));
      },
    );
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((e) => e.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      // Optimistic update
      final oldNotif = _notifications[index];
      _notifications[index] = NotificationEntity(
        id: oldNotif.id,
        type: oldNotif.type,
        title: oldNotif.title,
        body: oldNotif.body,
        dataPayload: oldNotif.dataPayload,
        readAt: DateTime.now().toIso8601String(),
        createdAt: oldNotif.createdAt,
      );
      emit(NotificationLoaded(
        notifications: List.from(_notifications),
        hasMore: _hasMore,
        isPaginating: false,
      ));

      await markNotificationAsReadUseCase(id);
    }
  }

  Future<void> markAllAsRead() async {
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        final oldNotif = _notifications[i];
        _notifications[i] = NotificationEntity(
          id: oldNotif.id,
          type: oldNotif.type,
          title: oldNotif.title,
          body: oldNotif.body,
          dataPayload: oldNotif.dataPayload,
          readAt: oldNotif.readAt ?? DateTime.now().toIso8601String(),
          createdAt: oldNotif.createdAt,
        );
        changed = true;
      }
    }

    if (changed) {
      emit(NotificationLoaded(
        notifications: List.from(_notifications),
        hasMore: _hasMore,
        isPaginating: false,
      ));
      await markAllNotificationsAsReadUseCase();
    }
  }
}
