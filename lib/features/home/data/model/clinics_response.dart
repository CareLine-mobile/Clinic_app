// lib/features/home/data/models/clinics_response.dart

import 'clinic_model.dart';

class ClinicsResponse {
  final List<ClinicsHomeModel> clinics;
  final bool hasMorePage;
  final int currentPage;

  const ClinicsResponse({
    required this.clinics,
    required this.hasMorePage,
    required this.currentPage,
  });

  factory ClinicsResponse.fromJson(Map<String, dynamic> json) {
    return ClinicsResponse(
      clinics: (json['data'] as List<dynamic>?)
          ?.map((e) => ClinicsHomeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      hasMorePage: json['hasMorePage'] as bool? ?? false,
      currentPage: json['current_page'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': clinics.map((e) => e.toJson()).toList(),
      'hasMorePage': hasMorePage,
      'current_page': currentPage,
    };
  }

  ClinicsResponse copyWith({
    List<ClinicsHomeModel>? clinics,
    bool? hasMorePage,
    int? currentPage,
  }) {
    return ClinicsResponse(
      clinics: clinics ?? this.clinics,
      hasMorePage: hasMorePage ?? this.hasMorePage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}