// lib/features/home/data/datasources/fake/home_fake_data.dart

import 'dart:math';
import 'package:clinic_app/features/home/data/model/clinic_model.dart';


class HomeFakeData {
  static final Random _random = Random();

  // Arabic clinic names
  static const List<String> _clinicNames = [
    'مركز القلب الطبي',
    'عيادة الجلدية المتخصصة',
    'مستشفى الأطفال التخصصي',
    'عيادة الدكتور أحمد محمود',
    'مركز العناية بالبشرة',
    'عيادة العيون المتخصصة',
    'مركز الطب النفسي',
    'عيادة الأطفال الحديثة',
  ];

  // Arabic specialties
  static const List<String> _specialties = [
    'قلب وأوعية دموية',
    'أمراض جلدية',
    'طب الأطفال',
    'طب الأسنان',
    'طب العيون',
    'الطب النفسي',
    'العظام',
    'الباطنة',
  ];

  // Arabic locations
  static const List<String> _locations = [
    'الرياض، السعودية',
    'جدة، السعودية',
    'الدمام، السعودية',
    'مكة المكرمة، السعودية',
    'المدينة المنورة، السعودية',
    'القاهرة، مصر',
    'الإسكندرية، مصر',
    'دبي، الإمارات',
  ];

  // Image URLs
  static const List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
    'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800',
    'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
    'https://images.unsplash.com/photo-1632833239869-a37e3a5806d2?w=800',
    'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=800',
    'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800',
    'https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800',
    'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
  ];

  /// Generate a single clinic
  static ClinicsHomeModel generateClinic({int? id}) {
    final clinicId = id ?? _random.nextInt(10000);

    return ClinicsHomeModel(
      id: clinicId,
      name: _clinicNames[_random.nextInt(_clinicNames.length)],
      imageUrls: _generateImageUrls(),
      specialty: _specialties[_random.nextInt(_specialties.length)],
      reviewsCount: '50' ,
      location: _locations[_random.nextInt(_locations.length)],
      rating: '21' ,
      isOpen: _random.nextBool(),
      doctorsCount: '2',
      isFavorite: _random.nextBool(),
    );
  }

  /// Generate list of clinics
  static List<ClinicsHomeModel> generateClinicsList({int count = 10}) {
    return List.generate(
      count,
          (index) => generateClinic(id: index + 1),
    );
  }

  /// Generate featured clinics - matches your API data
  static List<ClinicsHomeModel> generateFeaturedClinics() {
    return [
      const ClinicsHomeModel(
        id: 2,
        name: 'مركز القلب الطبي',
        imageUrls: [
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800',
        ],
        specialty: 'قلب وأوعية دموية',
        reviewsCount: '150',
        location: 'الرياض، السعودية',
        rating: '4.8',
        isOpen: true,
        doctorsCount: '3',
        isFavorite: false,
      ),
      const ClinicsHomeModel(
        id: 3,
        name: 'عيادة الجلدية المتخصصة',
        imageUrls: [
          'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
          'https://images.unsplash.com/photo-1632833239869-a37e3a5806d2?w=800',
        ],
        specialty: 'أمراض جلدية',
        reviewsCount: '89',
        location: 'جدة، السعودية',
        rating: '4.5',
        isOpen: true,
        doctorsCount: '3',
        isFavorite: false,
      ),
      const ClinicsHomeModel(
        id: 4,
        name: 'مستشفى الأطفال التخصصي',
        imageUrls: [
          'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=800',
          'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800',
        ],
        specialty: 'طب الأطفال',
        reviewsCount: '230',
        location: 'الدمام، السعودية',
        rating: '4.9',
        isOpen: true,
        doctorsCount: '3',
        isFavorite: false,
      ),
    ];
  }

  /// Generate nearby clinics
  static List<ClinicsHomeModel> generateNearbyClinics() {
    return [
      const ClinicsHomeModel(
        id: 5,
        name: 'عيادة العيون المتخصصة',
        imageUrls: [
          'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
        ],
        specialty: 'طب العيون',
        reviewsCount: '132',
        location: 'الرياض، السعودية',
        rating: '4.6',
        isOpen: true,
        doctorsCount: '4',
        isFavorite: false,
      ),
      const ClinicsHomeModel(
        id: 6,
        name: 'مركز الطب النفسي',
        imageUrls: [
          'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=800',
        ],
        specialty: 'الطب النفسي',
        reviewsCount: '98',
        location: 'جدة، السعودية',
        rating: '4.5',
        isOpen: true,
        doctorsCount: '3',
        isFavorite: true,
      ),
      const ClinicsHomeModel(
        id: 7,
        name: 'عيادة الأطفال الحديثة',
        imageUrls: [
          'https://images.unsplash.com/photo-1551190822-a9333d879b1f?w=800',
        ],
        specialty: 'طب الأطفال',
        reviewsCount:' 276',
        location: 'الدمام، السعودية',
        rating: '4.9',
        isOpen: true,
        doctorsCount: '7',
        isFavorite: false,
      ),
      const ClinicsHomeModel(
        id: 8,
        name: 'عيادة الدكتور أحمد محمود',
        imageUrls: [
          'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
        ],
        specialty: 'طب الأسنان',
        reviewsCount: '156',
        location: 'مكة المكرمة، السعودية',
        rating:' 4.8',
        isOpen: true,
        doctorsCount: '5',
        isFavorite: false,
      ),
    ];
  }

  /// Helper: Generate image URLs (1-3 images per clinic)
  static List<String> _generateImageUrls() {
    final count = 1 + _random.nextInt(3); // 1 to 3 images
    final shuffled = List<String>.from(_imageUrls)..shuffle();
    return shuffled.take(count).toList();
  }
}