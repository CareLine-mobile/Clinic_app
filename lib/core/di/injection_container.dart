import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:clinic_app/core/api/dio_client.dart';
import 'package:clinic_app/features/my_booking/data/data_sources/review_local_data_source.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/review_local_data_source.dart';
import 'package:clinic_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:clinic_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:clinic_app/features/search/domain/repositories/search_repository.dart';
import 'package:clinic_app/features/search/domain/usecases/search_clinics_usecase.dart';
import 'package:clinic_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Features - Auth
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/send_forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Features - My Booking
import '../../features/favourite/data/datasources/favourite_remote_data_source.dart';
import '../../features/favourite/data/datasources/favourite_remote_data_source_impl.dart';
import '../../features/favourite/data/repositories/favourite_repository_impl.dart';
import '../../features/favourite/domain/repositories/favourite_repository.dart';
import '../../features/favourite/domain/usecases/get_favourites_usecase.dart';
import '../../features/favourite/domain/usecases/toggle_favourite_usecase.dart';
import '../../features/favourite/presentation/cubit/favourite_cubit.dart';
import '../../features/my_booking/presentation/cubit/booking_cubit.dart';
import 'package:clinic_app/features/home/domain/usecases/get_nearby_clinics_usecase.dart';
import 'package:clinic_app/features/my_booking/data/data_sources/my_booking_remote_data_source.dart';
import 'package:clinic_app/features/my_booking/domain/repositories/review_repository.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/CreateReviewUseCase.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/cancel_booking_usecase.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/get_user_bookings_usecase.dart';
import 'package:clinic_app/features/my_booking/data/repositories/my_booking_repository_impl.dart';

// Features - Clinic Details
import '../../features/clinic_details/data/datasources/clinic_local_data_source.dart';
import '../../features/clinic_details/data/repositories/clinic_repository_impl.dart';
import '../../features/clinic_details/domain/repositories/clinic_repository.dart';
import '../../features/clinic_details/domain/usecases/get_clinic_details_usecase.dart';
import '../../features/clinic_details/domain/usecases/make_appointment_usecase.dart';
import '../../features/clinic_details/domain/usecases/toggle_favorite_usecase.dart'
    as clinic_details;
import '../../features/clinic_details/presentation/cubit/clinic_details_cubit.dart';

// Features - Home
import '../../features/home/data/datasources/localdatasource/location_data_source.dart';
import '../../features/home/data/datasources/localdatasource/location_data_source_impl.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/data/repositories/location_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/repositories/location_repository.dart';
import '../../features/home/domain/usecases/get_clinics_usecase.dart';
import '../../features/home/domain/usecases/get_latest_clinics_usecase.dart';
import '../../features/home/domain/usecases/location/get_current_location_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/home_ui_cubit.dart';
import '../../features/user_data/user_repo.dart';
import '../api/model/endpoints.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  setUpDio();
  setUpLocalDb();
  setUpAuthModule();
  setUpHomeModule();
  setUpMyBookingModule();
  setUpClinicModule();
  setUpSearchModule();
  setUpFavouriteModule();

  sl.registerLazySingleton(() => UserRepository());
}

void setUpDio() {
  final dio = Dio(BaseOptions(
    baseUrl: Endpoints.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton<BaseApiServices>(
    () => DioApiService(sl()),
  );
}

void setUpLocalDb() {
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );

  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl()),
  );
}

void setUpAuthModule() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiServices: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SendForgotPasswordUseCase(sl()));

  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      signupUseCase: sl(),
      userRepository: sl(),
      verifyOtpUseCase: sl(),
      authRepository: sl(),
      logoutUseCase: sl(),
      sendForgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
}

void setUpHomeModule() {
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(apiServices: sl()),
  );

  sl.registerLazySingleton(() => GetCurrentLocationUseCase(sl()));
  sl.registerLazySingleton<GetClinicsUseCase>(() => GetClinicsUseCase(sl()));
  sl.registerLazySingleton<GetLatestClinicsUseCase>(
      () => GetLatestClinicsUseCase(sl()));
  sl.registerLazySingleton<GetNearByClinicsUseCase>(
    () => GetNearByClinicsUseCase(
      getCurrentLocationUseCase: sl(),
      repository: sl(),
    ),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getLatestClinicsUseCase: sl(),
      getClinicsUseCase: sl(),
      getNearByClinicsUseCase: sl(),
      toggleFavouriteUseCase: sl(),
      favouriteRepository: sl(),
    ),
  );

  sl.registerFactory<HomeUiCubit>(() => HomeUiCubit());
}

void setUpMyBookingModule() {
  // ─── Data sources ───────────────────────────────────────
  sl.registerLazySingleton<MyBookingRemoteDataSource>(
    () => MyBookingRemoteDataSourceImpl(apiServices: sl()),
  );

  sl.registerLazySingleton<ReviewLocalDataSource>(
    () => ReviewLocalDataSourceImpl(),
  );

  // ─── Repository ─────────────────────────────────────────
  sl.registerLazySingleton<MyBookingRepository>(
    () => MyBookingRepositoryImpl(remoteDataSource: sl()),
  );

  // ─── Use cases ──────────────────────────────────────────
  sl.registerLazySingleton(() => GetUserBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => CreateReviewUseCase(sl()));
  sl.registerLazySingleton(() => IsClinicReviewedUseCase(sl()));
  sl.registerLazySingleton(() => MarkClinicReviewedUseCase(sl()));

  // ─── Cubit ──────────────────────────────────────────────
  sl.registerFactory(
    () => BookingCubit(
      getUserBookings: sl(),
      cancelBooking: sl(),
      createReview: sl(),
      isClinicReviewed: sl(),
      markClinicReviewed: sl(),
    ),
  );
}

void setUpClinicModule() {
  sl.registerLazySingleton<ClinicLocalDataSource>(
    () => ClinicLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ClinicRepository>(
    () => ClinicRepositoryImpl(
      apiServices: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<GetClinicDetailsUseCase>(
    () => GetClinicDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<MakeAppointmentUseCase>(
    () => MakeAppointmentUseCase(sl()),
  );
  sl.registerLazySingleton<clinic_details.ToggleFavoriteUseCase>(
    () => clinic_details.ToggleFavoriteUseCase(sl()),
  );

  sl.registerFactory<ClinicDetailsCubit>(
    () => ClinicDetailsCubit(
      getClinicDetailsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      makeAppointmentUseCase: sl(),
    ),
  );
}

void setUpSearchModule() {
// Search feature
// 1. Cubit
  sl.registerFactory(() => SearchCubit(searchClinicsUseCase: sl()));

  // 2. UseCase
  sl.registerLazySingleton(() => SearchClinicsUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );

  // 4. Data Source
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(
      apiServices: sl(),
    ),
  );
}

void setUpFavouriteModule() {
  // ── Favourite feature ──────────────────────────────────────────

// Data Sources
  sl.registerLazySingleton<FavouriteRemoteDataSource>(
    () => FavouriteRemoteDataSourceImpl(sl()),
  );

// Repository — SINGLETON so the broadcast stream is shared app-wide
  sl.registerLazySingleton<FavouriteRepository>(
    () => FavouriteRepositoryImpl(sl()),
  );

// Use Cases
  sl.registerLazySingleton(() => GetFavouritesUseCase(sl()));

// This unified ToggleFavouriteUseCase replaces the old clinic_details one
  sl.registerLazySingleton(() => ToggleFavouriteUseCase(sl()));

// Cubit — factory so each tab gets a fresh instance
  sl.registerFactory(
    () => FavouriteCubit(
      getFavouritesUseCase: sl(),
      toggleFavouriteUseCase: sl(),
      favouriteRepository: sl(),
      userRepository: sl(),
    ),
  );
}
/*
╔╣ Request ║ POST
I/flutter (32075): ║  https://clinical.khorogat.com/api/auth/register
I/flutter (32075): ╚══════════════════════════════════════════════════════════════════════════════════════════╝
I/flutter (32075): ╔ Headers
I/flutter (32075): ╟ content-type: application/json
I/flutter (32075): ╟ contentType: application/json
I/flutter (32075): ╟ responseType: ResponseType.json
I/flutter (32075): ╟ followRedirects: true
I/flutter (32075): ╟ connectTimeout: 0:00:30.000000
I/flutter (32075): ╟ receiveTimeout: 0:00:30.000000
I/flutter (32075): ╚══════════════════════════════════════════════════════════════════════════════════════════╝
I/flutter (32075): ╔ Body
I/flutter (32075): ╟ name: زياد محمد
I/flutter (32075): ╟ email: zyadmuhammed05@gmail.com
I/flutter (32075): ╟ phone: 01142214358
I/flutter (32075): ╟ password: zyadmohamed
I/flutter (32075): ╟ password_confirmation: zyadmohamed
I/flutter (32075): ╚══════════════════════════════════════════════════════════════════════════════════════════╝
I/flutter (32075): ║ {name: زياد محمد, email: zyadmuhammed05@gmail.com, phone: 01142214358, password: zyadmoham
I/flutter (32075): ║ ed, password_confirmation: zyadmohamed}
I/flutter (32075):
I/flutter (32075): ╔╣ Response ║ POST ║ Status: 200 OK  ║ Time: 1218 ms
I/flutter (32075): ║  https://clinical.khorogat.com/api/auth/register
I/flutter (32075): ╚══════════════════════════════════════════════════════════════════════════════════════════╝
I/flutter (32075): ╔ Body
I/flutter (32075): ║
I/flutter (32075): ║    {
I/flutter (32075): ║         "message": "Registration successful Check OTP",
I/flutter (32075): ║         "status": 200,
I/flutter (32075): ║         "data": {email: zyadmuhammed05@gmail.com}
I/flutter (32075): ║    }
I/flutter (32075): ║
I/flutter (32075): ╚══════════════════════════════════════════════════════════════════════════════════════════╝
I/flutter (32075): fjdofjdofdof {"message":"Registration successful Check OTP","status":200,"data":{"email":"zyadmuhammed05@gmail.com"}}
E/flutter (32075): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: type 'String' is not a subtype of type 'Map<String, dynamic>' in type cast
E/flutter (32075): #0      AppRouter.onGenerateRoute (package:clinic_app/core/routes/app_routes.dart:84:41)
E/flutter (32075): #1      _WidgetsAppState._onGenerateRoute (package:flutter/src/widgets/app.dart:1553:37)
E/flutter (32075): #2      NavigatorState._routeNamed (package:flutter/src/widgets/navigator.dart:4661:47)
E/flutter (32075): #3      NavigatorState.pushNamed (package:flutter/src/widgets/navigator.dart:4729:21)
E/flutter (32075): #4      Navigator.pushNamed (package:flutter/src/widgets/navigator.dart:1896:34)
E/flutter (32075): #5      _SignupTabState.build.<anonymous closure> (package:clinic_app/features/auth/presentation/widget/taps/signup_tab.dart:49:21)
E/flutter (32075): #6      _BlocConsumerState.build.<anonymous closure> (package:flutter_bloc/src/bloc_consumer.dart:160:26)
E/flutter (32075): #7      _BlocListenerBaseState._subscribe.<anonymous closure> (package:flutter_bloc/src/bloc_listener.dart:215:30)
E/flutter (32075): #8      _RootZone.runUnaryGuarded (dart:async/zone.dart:1778:10)
E/flutter (32075): #9      _BufferingStreamSubscription._sendData (dart:async/stream_impl.dart:381:11)
E/flutter (32075): #10     _DelayedData.perform (dart:async/stream_impl.dart:573:14)
E/flutter (32075): #11     _PendingEvents.handleNext (dart:async/stream_impl.dart:678:11)
E/flutter (32075): #12     _PendingEvents.schedule.<anonymous closure> (dart:async/stream_impl.dart:649:7)
E/flutter (32075): #13     _microtaskLoop (dart:async/schedule_microtask.dart:40:21)
 */