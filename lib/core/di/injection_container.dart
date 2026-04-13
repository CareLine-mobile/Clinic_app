import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:clinic_app/core/api/dio_client.dart';
import 'package:clinic_app/features/auth/domain/usecases/google_login_usecase.dart';
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
import '../../features/auth/domain/usecases/delete_acount_usecase.dart';
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
import '../../features/profile/data/profile_remote_data_source.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/settings/data/setting_repo_impl.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
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
  setUpProfileModule();
  sl.registerLazySingleton(() => UserRepository());
  // In setUpAuthModule or a new setUpSettingsModule:
  sl.registerLazySingleton<SettingsRepositoryImpl>(
        () => SettingsRepositoryImpl(apiServices: sl()),
  );
  sl.registerFactory(() => SettingsCubit(settingsRepository: sl()));
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
  // sl.registerLazySingleton<LocationDataSource>(
  //   () => LocationDataSourceUtilits(),
  // );

  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl()),
  );
}

void setUpAuthModule() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiServices: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SendForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));


  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      signupUseCase: sl(),
      userRepository: sl(),
      verifyOtpUseCase: sl(),
      authRepository: sl(),
      logoutUseCase: sl(),
      sendForgotPasswordUseCase: sl(),
      googleLoginUseCase: sl(),
      resetPasswordUseCase: sl(),
      deleteAccountUseCase: sl()
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
    //  getCurrentLocationUseCase: sl(),
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
  // sl.registerLazySingleton<clinic_details.ToggleFavoriteUseCase>(
  //   () => clinic_details.ToggleFavoriteUseCase(sl()),
  // );

  sl.registerFactory<ClinicDetailsCubit>(
    () => ClinicDetailsCubit(
      getClinicDetailsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      makeAppointmentUseCase: sl(),
      favouriteRepository: sl(),
    ),
  );
}

void setUpSearchModule() {
// Search feature
// 1. Cubit
  sl.registerFactory(() => SearchCubit(searchClinicsUseCase: sl(),favouriteRepository: sl(),toggleFavouriteUseCase: sl()));

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
void setUpProfileModule() {
  sl.registerLazySingleton(() => ProfileRemoteDataSource(sl()));
  sl.registerLazySingleton(() => ProfileRepository(sl()));
  sl.registerFactory(() => ProfileCubit(
    repository: sl(),
    userRepository: sl(),
  ));
}