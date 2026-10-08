import 'package:clinic_app/core/widgets/card/clinic_list.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_statistics_entity.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/doctor_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/clinic_statistics_widget.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/doctor_card.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:clinic_app/features/home/presentation/widget/home_shimmer_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  const sizes = [
    Size(320, 640),
    Size(360, 800),
    Size(390, 844),
    Size(768, 1024),
    Size(1280, 800),
  ];
  const locales = [Locale('ar'), Locale('en')];
  const scales = [1.0, 1.5];

  final clinic = ClinicSummary(
    id: 1,
    name: 'CareLine Medical Center',
    imageUrls: const [],
    specialty: 'Pediatrics',
    reviewsCount: '120',
    location: 'Beni Suef',
    rating: '4.8',
    isOpen: true,
    doctorsCount: '12',
  );
  final doctor = DoctorEntity(
    id: '1',
    name: 'د. حسن عبدالعزيز Hassan Abdelaziz',
    specialty: 'Pediatrics',
    imageUrl: '',
    rating: 4.8,
    reviewsCount: 120,
    experienceYears: 20,
    qualifications: '',
    bio: '',
    languages: const ['Arabic', 'English'],
    consultationFee: 460,
    availableSlots: const [],
  );
  const statistics = ClinicStatisticsEntity(
    totalVisits: 5000,
    totalBookings: 240,
    totalDoctors: 12,
    satisfactionRate: 84,
  );

  for (final size in sizes) {
    for (final scale in scales) {
      for (final locale in locales) {
        testWidgets(
          'responsive clinic and shimmer layouts at $size, scale $scale, ${locale.languageCode}',
          (tester) async {
            await tester.binding.setSurfaceSize(size);
            addTearDown(() => tester.binding.setSurfaceSize(null));
            Widget localized(Widget child) => EasyLocalization(
              supportedLocales: locales,
              path: 'assets/translations',
              fallbackLocale: const Locale('ar'),
              startLocale: locale,
              child: ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                builder: (localContext, _) => MaterialApp(
                  locale: locale,
                  supportedLocales: locales,
                  localizationsDelegates: localContext.localizationDelegates,
                  home: MediaQuery(
                    data: MediaQueryData(
                      size: size,
                      textScaler: TextScaler.linear(scale),
                    ),
                    child: Scaffold(body: child),
                  ),
                ),
              ),
            );

            await tester.pumpWidget(
              localized(
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ClinicStatisticsWidget(
                        statistics: statistics,
                        accentColor: Colors.teal,
                      ),
                      DoctorCard(
                        doctor: doctor,
                        selectedDate: DateTime(2026, 10, 8),
                        isSelected: false,
                        onTap: () {},
                        accentColor: Colors.teal,
                      ),
                      HorizontalClinicsCarousel(
                        clinics: [clinic],
                        onTap: (_) {},
                      ),
                      FeaturedClinicsSection(clinics: [clinic], onTap: (_) {}),
                    ],
                  ),
                ),
              ),
            );
            await tester.pump();
            await tester.pump(const Duration(seconds: 2));
            expect(tester.takeException(), isNull);

            await tester.pumpWidget(localized(const HomeBodyShimmer()));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
