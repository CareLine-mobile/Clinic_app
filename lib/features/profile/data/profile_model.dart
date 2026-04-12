import 'package:equatable/equatable.dart';
class ProfileResponseModel{
  final ProfileModel? profile;
  final bool success;

  ProfileResponseModel({required this.profile, required this.success});
  // factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
  //   return ProfileResponseModel(
  //     profile: ProfileModel.fromJson(json['data']),
  //     success: json['success'],
  //   );
  // }

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ProfileResponseModel(
      profile: (data != null && data is Map<String, dynamic>)
          ? ProfileModel.fromJson(data)
          : null,
      success: json['success'] as bool? ?? false,
    );
  }
}
class ProfileModel extends Equatable {
  final int? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? avatar;
  final DateTime? birthDate;
  final String? gender;
  final String? bloodType;
  final List<String>? chronicDiseases;
  final String? emergencyContact;

  const ProfileModel({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.avatar,
    this.birthDate,
    this.gender,
    this.bloodType,
    this.chronicDiseases,
    this.emergencyContact,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle both wrapped { data: {...} } and direct responses
    final d = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ProfileModel(
      id: d['id'] as int?,
     
      fullName: d['full_name'] as String? ?? d['name'] as String?,
      email: d['email'] as String?,
      phone: d['phone'] as String?,
      avatar: d['avatar'] as String?,
      birthDate: d['birth_date'] != null
          ? DateTime.tryParse(d['birth_date'] as String)
          : null,
      gender: d['gender'] as String?,
      bloodType: d['blood_type'] as String?,
      chronicDiseases: d['chronic_diseases'] != null
          ? List<String>.from(d['chronic_diseases'] as List)
          : null,
      emergencyContact: d['emergency_contact'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'full_name': fullName,
      'birth_date': birthDate != null
          ? '${birthDate!.year}-'
          '${birthDate!.month.toString().padLeft(2, '0')}-'
          '${birthDate!.day.toString().padLeft(2, '0')}'
          : null,
    //  'gender': gender!.toLowerCase(),
      'gender': gender!,
      'emergency_contact': emergencyContact,
    };
    if (bloodType != null) map['blood_type'] = bloodType;
    if (chronicDiseases != null) map['chronic_diseases'] = chronicDiseases;
    return map;
  }

  ProfileModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatar,
    DateTime? birthDate,
    String? gender,
    String? bloodType,
    List<String>? chronicDiseases,
    String? emergencyContact,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }

  /// 5 tracked fields × 20 % each = 100 %
  /// Required: fullName, birthDate, gender, emergencyContact (4 × 20 = 80 %)
  /// Optional but tracked: bloodType (1 × 20 = 20 %)
  double get completionPercentage {
    int count = 0;
    if (fullName != null && fullName!.trim().isNotEmpty) count++;
    if (birthDate != null) count++;
    if (gender != null && gender!.isNotEmpty) count++;
    if (bloodType != null && bloodType!.isNotEmpty) count++;
    if (emergencyContact != null && emergencyContact!.trim().isNotEmpty) count++;
    return count / 5.0;
  }

  @override
  List<Object?> get props => [
    id, fullName, email, phone, avatar,
    birthDate, gender, bloodType, chronicDiseases, emergencyContact,
  ];
  bool get hasData {
    return id != null ||
        (fullName != null && fullName!.trim().isNotEmpty) ||
        (email != null && email!.isNotEmpty) ||
        (phone != null && phone!.isNotEmpty) ||
        birthDate != null ||
        (gender != null && gender!.isNotEmpty) ||
        (bloodType != null && bloodType!.isNotEmpty) ||
      //  (chronicDiseases != null && chronicDiseases!.isNotEmpty) ||
        (emergencyContact != null && emergencyContact!.trim().isNotEmpty);
  }
}