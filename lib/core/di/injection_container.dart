import 'package:clinic_app/core/api/api_service.dart';
import 'package:clinic_app/features/home/domain/usecases/get_nearby_clinics_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Features - Clinic Details
import '../../features/clinic_details/data/datasources/clinic_local_data_source.dart';
import '../../features/clinic_details/data/datasources/clinic_remote_data_source.dart';
import '../../features/clinic_details/data/repositories/clinic_repository_impl.dart';
import '../../features/clinic_details/domain/repositories/clinic_repository.dart';
import '../../features/clinic_details/domain/usecases/get_clinic_details_usecase.dart';
import '../../features/clinic_details/domain/usecases/toggle_favorite_usecase.dart' as clinic_details;
import '../../features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import '../../features/clinic_details/presentation/cubit/clinic_ui_cubit.dart';

// Features - Home
import '../../features/home/data/datasources/localdatasource/location_data_source.dart';
import '../../features/home/data/datasources/localdatasource/location_data_source_impl.dart';
import '../../features/home/data/datasources/remotedatasource/remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/data/repositories/location_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/repositories/location_repository.dart';
import '../../features/home/domain/usecases/get_clinics_usecase.dart';
import '../../features/home/domain/usecases/get_latest_clinics_usecase.dart';
import '../../features/home/domain/usecases/location/get_current_location_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/home_ui_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // External Dependencies
  // ==========================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ==========================
  // Core - Network & API
  // ==========================

  // Dio instance
  sl.registerLazySingleton<Dio>(() => Dio());

  // ApiService (will configure Dio internally)
  sl.registerLazySingleton<ApiService>(
        () => ApiService(sl()),
  );

  sl.registerLazySingleton<LocationDataSource>(
        () => LocationDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(dataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(
        () => GetCurrentLocationUseCase(sl()),
  );

  // ==========================
  // Feature: Home
  // ==========================

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(
      apiService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetClinicsUseCase>(
        () => GetClinicsUseCase(sl()),
  );
  sl.registerLazySingleton<GetLatestClinicsUseCase>(
        () => GetLatestClinicsUseCase(sl()),
  );
  sl.registerLazySingleton<GetNearByClinicsUseCase>(
        () => GetNearByClinicsUseCase(getCurrentLocationUseCase: sl(),repository: sl()),
  );

  // Cubits (Factory - new instance each time)
  sl.registerFactory<HomeCubit>(
        () => HomeCubit(
      getLatestClinicsUseCase: sl(),
      getClinicsUseCase: sl(),
      getNearByClinicsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );

  sl.registerFactory<HomeUiCubit>(
        () => HomeUiCubit(),
  );

  // ==========================
  // Feature: Clinic Details
  // ==========================

  // Data Sources
  sl.registerLazySingleton<ClinicRemoteDataSource>(
        () => ClinicRemoteDataSourceImpl(
      apiService: sl(),
    ),
  );

  sl.registerLazySingleton<ClinicLocalDataSource>(
        () => ClinicLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ClinicRepository>(
        () => ClinicRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetClinicDetailsUseCase>(
        () => GetClinicDetailsUseCase(sl()),
  );

  sl.registerLazySingleton<clinic_details.ToggleFavoriteUseCase>(
        () => clinic_details.ToggleFavoriteUseCase(sl()),
  );


  // Cubits (Factory - new instance each time)
  sl.registerFactory<ClinicDetailsCubit>(
        () => ClinicDetailsCubit(
      getClinicDetailsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );

  sl.registerFactory<ClinicUiCubit>(
        () => ClinicUiCubit(),
  );
}