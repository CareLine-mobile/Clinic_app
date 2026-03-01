import 'package:clinic_app/core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../model/appointment_request_model.dart';
import '../model/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingListModel> getUserBookings({int page = 1});
  Future<void> makeAppointment(AppointmentRequestModel request);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final BaseApiServices apiServices;

  BookingRemoteDataSourceImpl({
    required this.apiServices,
  });

  @override
  Future<BookingListModel> getUserBookings({int page = 1}) async {
    // No try-catch - just data operations
    final response = await apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.getListBooking,
      queryParams: {'page': page},
    );

    final data = response['data'] ?? response;
    return BookingListModel.fromJson(data);
  }

  @override
  Future<void> makeAppointment(AppointmentRequestModel request) async {
    await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.bookAppointment,
      body: request.toJson(),
    );
  }
}