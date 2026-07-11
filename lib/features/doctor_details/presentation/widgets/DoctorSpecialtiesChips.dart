import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/Loading_widget.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/widgets/empty_state_widget.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/review_card.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_app/features/doctor_details/presentation/cubit/doctor_profile_cubit.dart';
import 'package:clinic_app/features/doctor_details/presentation/widgets/doctor_rating_dialog.dart';
import 'package:clinic_app/features/doctor_details/presentation/widgets/specialty_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text_widgets.dart';
import '../widgets/Info_tile.dart';
class DoctorSpecialtiesChips extends StatelessWidget {
  final DoctorProfileEntity doctor;

  const DoctorSpecialtiesChips({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    // Build chips from specialty + languages for SEO tags
    final tags = <String>[];
    if (doctor.specialty.isNotEmpty) tags.add(doctor.specialty);
    tags.addAll(doctor.languages.map(
          (l) => 'doctorProfile.languageTag'.tr(namedArgs: {'language': l}),
    ));

    if (tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
              'doctorProfile.specialtiesTags'.tr(),
              icon: Icons.tag_rounded),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: tags.map((tag) => SpecialtyChip(label: tag)).toList(),
          ),
        ],
      ),
    );
  }
}
