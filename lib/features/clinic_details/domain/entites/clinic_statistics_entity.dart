import 'package:equatable/equatable.dart';

class ClinicStatisticsEntity extends Equatable {
  final int totalVisits;
  final int totalBookings;
  final int totalDoctors;
  final int satisfactionRate;

  const ClinicStatisticsEntity({
    required this.totalVisits,
    required this.totalBookings,
    required this.totalDoctors,
    required this.satisfactionRate,
  });

  // Business Logic
  bool get isHighlySatisfied => satisfactionRate >= 80;

  String get satisfactionLevel {
    if (satisfactionRate >= 90) return 'ممتاز';
    if (satisfactionRate >= 80) return 'جيد جداً';
    if (satisfactionRate >= 70) return 'جيد';
    if (satisfactionRate >= 60) return 'مقبول';
    return 'ضعيف';
  }

  @override
  List<Object?> get props => [
    totalVisits, totalBookings,
    totalDoctors, satisfactionRate,
  ];
}