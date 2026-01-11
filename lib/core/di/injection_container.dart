import 'package:clinic_app/core/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Features - Clinic Details
import '../../features/clinic_details/data/datasources/clinic_local_data_source.dart';
import '../../features/clinic_details/data/datasources/clinic_remote_data_source.dart';
import '../../features/clinic_details/data/repositories/clinic_repository_impl.dart';
import '../../features/clinic_details/domain/repositories/clinic_repository.dart';
import '../../features/clinic_details/domain/usecases/book_appointment_usecase.dart';
import '../../features/clinic_details/domain/usecases/get_clinic_details_usecase.dart';
import '../../features/clinic_details/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import '../../features/clinic_details/presentation/cubit/clinic_ui_cubit.dart';

// Features - Home
import '../../features/home/data/datasources/remotedatasource/remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_clinics_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/home_ui_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // Core - MUST BE FIRST
  // ==========================

  // Dio instance
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://clinicalapp22-001-site1.ltempurl.com/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    return dio;
  });

  // ApiService
  sl.registerLazySingleton<ApiService>(
        () => ApiService(sl()),
  );

  // ==========================
  // Feature: Home
  // ==========================

  // Bloc/Cubit
  sl.registerFactory(() => HomeCubit(homeRepository: sl()));
  sl.registerFactory(() => HomeUiCubit());

  // Use Cases
  sl.registerLazySingleton(() => GetClinicsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(
      apiService: sl(),
      useFakeData: true, // ✅ Use fake data while backend fixes CORS
    ),
  );

  // ==========================
  // Feature: Clinic Details
  // ==========================

  // Bloc/Cubit
  sl.registerFactory(
        () => ClinicDetailsCubit(
      getClinicDetailsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      bookAppointmentUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ClinicUiCubit());

  // Use Cases
  sl.registerLazySingleton(() => GetClinicDetailsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => BookAppointmentUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ClinicRepository>(
        () => ClinicRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ClinicRemoteDataSource>(
        () => ClinicRemoteDataSourceImpl(apiService: sl(),useFakeData: true),
  );

  sl.registerLazySingleton<ClinicLocalDataSource>(
        () => ClinicLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================
  // External
  // ==========================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}