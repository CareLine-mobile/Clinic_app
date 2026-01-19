
import '../../domain/entites/clinic_statistics_entity.dart';

class ClinicStatisticsModel extends ClinicStatisticsEntity {
  const ClinicStatisticsModel({
    required super.totalVisits,
    required super.totalBookings,
    required super.totalDoctors,
    required super.satisfactionRate,
  });

  factory ClinicStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ClinicStatisticsModel(
      totalVisits: json['total_visits'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      totalDoctors: json['total_doctors'] ?? 0,
      satisfactionRate: json['satisfaction_rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_visits': totalVisits,
      'total_bookings': totalBookings,
      'total_doctors': totalDoctors,
      'satisfaction_rate': satisfactionRate,
    };
  }

  factory ClinicStatisticsModel.fromEntity(ClinicStatisticsEntity entity) {
    return ClinicStatisticsModel(
      totalVisits: entity.totalVisits,
      totalBookings: entity.totalBookings,
      totalDoctors: entity.totalDoctors,
      satisfactionRate: entity.satisfactionRate,
    );
  }
}
