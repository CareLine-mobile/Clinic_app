// ============================================
// 📁 Dependency Injection - GetIt Setup
// ============================================

// lib/core/di/injection_container.dart
import 'package:clinic_app/features/clinic_details/data/datasources/clinic_local_data_source.dart';
import 'package:clinic_app/features/clinic_details/data/datasources/clinic_remote_data_source.dart';
import 'package:clinic_app/features/clinic_details/domain/repositories/clinic_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/clinic_details/data/repositories/clinic_repository_impl.dart';
import '../../features/clinic_details/domain/usecases/book_appointment_usecase.dart';
import '../../features/clinic_details/domain/usecases/get_clinic_details_usecase.dart';
import '../../features/clinic_details/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import '../../features/home/presentation/cubit/clinics_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================
  // Features - Clinics
  // ============================================

  // Cubits
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
        () => ClinicRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ClinicLocalDataSource>(
        () => ClinicLocalDataSourceImpl(sharedPreferences: sl()),
  );


  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}



