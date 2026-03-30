import '../../../home/domain/entities/clinic_summary.dart';

abstract class FavouriteRemoteDataSource {

  Future<List<ClinicSummary>> getFavourites();


  Future<bool> toggleFavourite(int clinicId);
}