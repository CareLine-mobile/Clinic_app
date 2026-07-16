import 'dart:developer';

import 'package:clinic_app/features/my_booking/data/model/booking_model.dart';
import 'package:clinic_app/features/my_booking/data/model/review_request_model.dart';
import '../../../../../../core/api/base_api_services.dart';
import '../../../../../../core/api/model/http_method.dart';
import '../../../../core/api/model/endpoints.dart';

abstract class MyBookingRemoteDataSource {
  Future<BookingListModel> getUserBookings({int page = 1});
  Future<void> cancelBooking(int bookingId);
  Future<void> createReview({
    required int clinicId,
    required ReviewRequestModel request,
  });
  Future<List<BookingModel>> getFollowUps(int bookingId);
}

class MyBookingRemoteDataSourceImpl implements MyBookingRemoteDataSource {
  final BaseApiServices _apiServices;

  const MyBookingRemoteDataSourceImpl({required BaseApiServices apiServices})
      : _apiServices = apiServices;

  @override
  Future<BookingListModel> getUserBookings({int page = 1}) async {
    final response = await _apiServices.request(
      method: HttpMethod.get,
      url: Endpoints.getListBooking,
      queryParams: {'page': page},
    );
    return BookingListModel.fromJson(response);
  }

  @override
  Future<void> cancelBooking(int bookingId) async {
    await _apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.cancelBooking(bookingId),
    );
  }

  @override
  Future<void> createReview({
    required int clinicId,
    required ReviewRequestModel request,
  }) async {
    log('asdasd ${request.toJson()}');
    // Fire-and-forget: server returns 200 + message on success
    await _apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.createReview(clinicId),
      body: request.toJson(),
    );
  }

  @override
  Future<List<BookingModel>> getFollowUps(int bookingId) async {
    final response = await _apiServices.request(
      method: HttpMethod.get,
      url: '/auth/follow-ups/$bookingId',
    );
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}