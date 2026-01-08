// lib/features/clinics/data/datasources/fake/clinic_fake_data.dart

import 'package:flutter/material.dart';
import 'dart:math';
import '../../clinic_details_model.dart';


/// Fake Data Factory for Testing
class ClinicFakeData {
  static final Random _random = Random();

  // Fake Data Lists
  static const List<String> _clinicNames = [
    'عيادة الدكتور أحمد محمود',
    'مركز النخبة الطبي',
    'عيادة الشفاء',
    'مستشفى السلام',
    'عيادة الأمل الطبية',
  ];

  static const List<String> _specialties = [
    'طب الأسنان',
    'القلب والأوعية الدموية',
    'العظام',
    'الجلدية',
    'الأطفال',
    'النساء والتوليد',
    'العيون',
    'الأنف والأذن والحنجرة',
  ];

  static const List<String> _doctorNames = [
    'د. أحمد محمود',
    'د. سارة علي',
    'د. محمد حسن',
    'د. نورا خالد',
    'د. عمر سعيد',
    'د. ليلى إبراهيم',
    'د. يوسف عبدالله',
    'د. منى أحمد',
  ];

  static const List<String> _locations = [
    'المعادي، القاهرة',
    'مدينة نصر، القاهرة',
    'الزمالك، القاهرة',
    'الشيخ زايد، الجيزة',
    'الرحاب، القاهرة',
    'التجمع الخامس، القاهرة',
  ];

  static const List<String> _services = [
    'تنظيف أسنان',
    'حشو عصب',
    'تركيبات',
    'تقويم أسنان',
    'تبييض',
    'زراعة',
    'خلع أسنان',
    'جراحة لثة',
  ];

  static const List<String> _facilities = [
    'موقف سيارات',
    'صيدلية',
    'معمل تحاليل',
    'غرفة طوارئ',
    'مصعد',
    'انتظار مكيف',
  ];

  static const List<String> _insuranceProviders = [
    'التأمين الصحي',
    'بوبا',
    'مصر للتأمين',
    'المهندس للتأمين',
    'التعاونية',
  ];

  static const List<String> _patientNames = [
    'أحمد علي',
    'سارة محمد',
    'محمود حسن',
    'فاطمة خالد',
    'عمر سعيد',
    'منى إبراهيم',
  ];

  static const List<String> _reviewComments = [
    'تجربة ممتازة والخدمة رائعة',
    'طبيب محترف جداً',
    'المكان نظيف والموظفين محترمين',
    'وقت الانتظار طويل لكن الخدمة جيدة',
    'أنصح بشدة بهذه العيادة',
    'خدمة ممتازة وسعر مناسب',
  ];

  static const List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
    'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
    'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?w=800',
    'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
    'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=800',
  ];

  // Generate single clinic details
  static ClinicDetailsModel generateClinicDetails({
    String? id,
    Color? accentColor,
  }) {
    final clinicId = id ?? 'clinic_${_random.nextInt(1000)}';
    final specialty = _specialties[_random.nextInt(_specialties.length)];

    return ClinicDetailsModel(
      id: clinicId,
      name: _clinicNames[_random.nextInt(_clinicNames.length)],
      specialty: specialty,
      description: _generateDescription(specialty),
      location: _locations[_random.nextInt(_locations.length)],
      fullAddress: _generateAddress(),
      latitude: 29.0 + _random.nextDouble() * 2,
      longitude: 31.0 + _random.nextDouble() * 2,
      imageUrls: _generateImageUrls(),
      rating: 3.5 + _random.nextDouble() * 1.5,
      reviewsCount: 50 + _random.nextInt(200),
      price: 200.0 + _random.nextInt(300).toDouble(),
      accentColor: accentColor ?? _generateRandomColor(),
      isFavorite: _random.nextBool(),
      isOpen: _random.nextBool(),
      openingHours: _generateOpeningHours(),
      services: _generateServices(),
      facilities: _generateFacilities(),
      insuranceAccepted: _generateInsurance(),
      doctors: generateDoctorsList(count: 3 + _random.nextInt(5)),
      reviews: generateReviewsList(count: 5 + _random.nextInt(10)),
      statistics: generateStatistics(),
      contactInfo: generateContactInfo(),
    );
  }

  // Generate list of clinic details
  static List<ClinicDetailsModel> generateClinicDetailsList({
    int count = 10,
  }) {
    return List.generate(
      count,
          (index) => generateClinicDetails(id: 'clinic_$index'),
    );
  }

  // Generate Doctor
  static DoctorModel generateDoctor({String? id}) {
    final doctorId = id ?? 'doctor_${_random.nextInt(1000)}';
    final specialty = _specialties[_random.nextInt(_specialties.length)];

    return DoctorModel(
      id: doctorId,
      name: _doctorNames[_random.nextInt(_doctorNames.length)],
      specialty: 'استشاري $specialty',
      imageUrl: 'https://i.pravatar.cc/150?img=${_random.nextInt(70)}',
      rating: 4.0 + _random.nextDouble(),
      reviewsCount: 20 + _random.nextInt(150),
      experienceYears: 5 + _random.nextInt(20),
      qualifications: _generateQualifications(),
      bio: _generateDoctorBio(),
      languages: ['العربية', 'الإنجليزية'],
      availableSlots: generateAvailabilitySlots(),
      consultationFee: 200.0 + _random.nextInt(400).toDouble(),
    );
  }

  // Generate list of doctors
  static List<DoctorModel> generateDoctorsList({int count = 5}) {
    return List.generate(
      count,
          (index) => generateDoctor(id: 'doctor_$index'),
    );
  }

  // Generate Availability Slots
  static List<DoctorAvailabilitySlotModel> generateAvailabilitySlots({
    int daysAhead = 7,
    int slotsPerDay = 8,
  }) {
    final List<DoctorAvailabilitySlotModel> slots = [];
    final now = DateTime.now();

    for (int day = 0; day < daysAhead; day++) {
      final date = now.add(Duration(days: day));

      for (int slot = 0; slot < slotsPerDay; slot++) {
        final hour = 9 + slot;
        final slotTime = DateTime(date.year, date.month, date.day, hour);
        final maxBookings = 3 + _random.nextInt(5);
        final bookedCount = _random.nextInt(maxBookings + 2);

        slots.add(
          DoctorAvailabilitySlotModel(
            dateTime: slotTime,
            timeSlot: _formatTimeSlot(hour),
            isAvailable: bookedCount < maxBookings,
            bookedCount: bookedCount,
            maxBookings: maxBookings,
          ),
        );
      }
    }

    return slots;
  }

  // Generate Review
  static ReviewModel generateReview({String? id}) {
    return ReviewModel(
      id: id ?? 'review_${_random.nextInt(1000)}',
      patientName: _patientNames[_random.nextInt(_patientNames.length)],
      patientImageUrl: 'https://i.pravatar.cc/100?img=${_random.nextInt(70)}',
      rating: 3.0 + _random.nextDouble() * 2.0,
      comment: _reviewComments[_random.nextInt(_reviewComments.length)],
      date: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
      doctorName: _doctorNames[_random.nextInt(_doctorNames.length)],
    );
  }

  // Generate list of reviews
  static List<ReviewModel> generateReviewsList({int count = 10}) {
    return List.generate(
      count,
          (index) => generateReview(id: 'review_$index'),
    );
  }

  // Generate Statistics
  static ClinicStatisticsModel generateStatistics() {
    final monthlyVisits = <String, int>{};
    final now = DateTime.now();

    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final key = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      monthlyVisits[key] = 200 + _random.nextInt(300);
    }

    return ClinicStatisticsModel(
      totalVisits: 1000 + _random.nextInt(5000),
      totalBookings: 500 + _random.nextInt(2000),
      totalDoctors: 3 + _random.nextInt(10),
      satisfactionRate: 85 + _random.nextInt(15),
      monthlyVisits: monthlyVisits,
    );
  }

  // Generate Contact Info
  static ContactInfoModel generateContactInfo() {
    return ContactInfoModel(
      phone: '+20 ${_random.nextInt(10)}${_random.nextInt(10)} ${_random.nextInt(1000)} ${_random.nextInt(10000)}',
      email: 'info@clinic${_random.nextInt(100)}.com',
      website: 'www.clinic${_random.nextInt(100)}.com',
      socialMedia: {
        'facebook': 'https://facebook.com/clinic${_random.nextInt(100)}',
        'twitter': 'https://twitter.com/clinic${_random.nextInt(100)}',
        'instagram': 'https://instagram.com/clinic${_random.nextInt(100)}',
      },
    );
  }

  // Helper Methods

  static String _generateDescription(String specialty) {
    return 'عيادة متخصصة في $specialty مع أحدث التقنيات والمعدات الطبية المتطورة. نقدم خدمات طبية عالية الجودة مع فريق من الأطباء المتخصصين.';
  }

  static String _generateAddress() {
    final street = _random.nextInt(50) + 1;
    final building = _random.nextInt(20) + 1;
    return 'شارع $street، مبنى $building، ${_locations[_random.nextInt(_locations.length)]}';
  }

  static List<String> _generateImageUrls() {
    final count = 2 + _random.nextInt(4);
    return List.generate(
      count,
          (index) => _imageUrls[_random.nextInt(_imageUrls.length)],
    );
  }

  static String _generateOpeningHours() {
    final openingHours = [
      'السبت - الخميس: 9 ص - 9 م',
      'الأحد - الخميس: 10 ص - 8 م',
      'يومياً: 8 ص - 10 م',
      'السبت - الأربعاء: 9 ص - 5 م',
    ];
    return openingHours[_random.nextInt(openingHours.length)];
  }

  static List<String> _generateServices() {
    final count = 3 + _random.nextInt(6);
    final shuffled = List<String>.from(_services)..shuffle();
    return shuffled.take(count).toList();
  }

  static List<String> _generateFacilities() {
    final count = 2 + _random.nextInt(4);
    final shuffled = List<String>.from(_facilities)..shuffle();
    return shuffled.take(count).toList();
  }

  static List<String> _generateInsurance() {
    final count = 2 + _random.nextInt(4);
    final shuffled = List<String>.from(_insuranceProviders)..shuffle();
    return shuffled.take(count).toList();
  }

  static String _generateQualifications() {
    final quals = [
      'بكالوريوس طب وجراحة',
      'ماجستير في التخصص',
      'دكتوراه في التخصص',
      'زمالة الكلية الملكية',
    ];
    return quals[_random.nextInt(quals.length)];
  }

  static String _generateDoctorBio() {
    return 'طبيب متخصص مع خبرة واسعة في المجال، حاصل على شهادات دولية ومعتمد من أفضل الجامعات.';
  }

  static String _formatTimeSlot(int hour) {
    final period = hour < 12 ? 'ص' : 'م';
    final displayHour = hour > 12 ? hour - 12 : hour;
    return '$displayHour:00 $period';
  }

  static Color _generateRandomColor() {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D),
      const Color(0xFF95E1D3),
      const Color(0xFFF38181),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  // Quick Presets

  static ClinicDetailsModel dental() {
    return generateClinicDetails(
      id: 'dental_clinic',
      accentColor: const Color(0xFF6C63FF),
    );
  }

  static ClinicDetailsModel cardiology() {
    return generateClinicDetails(
      id: 'cardiology_clinic',
      accentColor: const Color(0xFFFF6B6B),
    );
  }

  static ClinicDetailsModel pediatrics() {
    return generateClinicDetails(
      id: 'pediatrics_clinic',
      accentColor: const Color(0xFF4ECDC4),
    );
  }
}


