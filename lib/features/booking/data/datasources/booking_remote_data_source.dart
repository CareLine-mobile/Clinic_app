import 'package:clinic_app/core/api/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/api/api_service.dart';
import '../../../../core/api/api_error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/appointment_request_model.dart';
import '../model/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingListModel> getUserBookings({int page = 1});
  Future<void> makeAppointment(AppointmentRequestModel request);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiService apiService;

  BookingRemoteDataSourceImpl({required this.apiService});

  @override
  Future<BookingListModel> getUserBookings({int page = 1}) async {
    try {
      final response = await apiService.get(
        Endpoints.getListBooking,
        queryParameters: {'page': page},
      );

      final data = response.data['data'] ?? response.data;
      return BookingListModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.booking.list'.tr());
    }
  }

  @override
  Future<void> makeAppointment(AppointmentRequestModel request) async {
    try {
      await apiService.post(
        Endpoints.bookAppointment,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      throw ServerException('errors.booking.create'.tr());
    }
  }
}