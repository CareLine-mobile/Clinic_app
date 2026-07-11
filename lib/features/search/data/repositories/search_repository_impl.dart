import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/result_handler.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ClinicSummary>>> searchClinics({
    required String query,
  }) =>
      ResultHandler.handle(() => remoteDataSource.searchClinics(query: query));


}