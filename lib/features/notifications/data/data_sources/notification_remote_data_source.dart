import '../../../../core/api/base_api_services.dart';
import '../../../../core/api/model/http_method.dart';
import '../../../../core/api/model/endpoints.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<PaginatedNotificationModel> getNotifications(int page);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final BaseApiServices apiServices;

  NotificationRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<PaginatedNotificationModel> getNotifications(int page) async {
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.notifications,
      queryParams: {'page': page.toString()},
    );

    return PaginatedNotificationModel.fromJson(response);
  }

  @override
  Future<void> markAsRead(String id) async {
    await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.markNotificationAsRead.replaceAll('{id}', id),
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.markAllNotificationsAsRead,
    );
  }
}
