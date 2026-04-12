import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'profile_section_card.dart';
import 'profile_date_field.dart';
import 'profile_gender_selector.dart';

class ProfilePersonalSection extends StatelessWidget {
  final TextEditingController nameController;
  final DateTime? birthDate;
  final String? gender;
  final VoidCallback onPickDate;
  final ValueChanged<String?> onGenderChanged;
  final String Function(DateTime) formatDate;

  const ProfilePersonalSection({
    Key? key,
    required this.nameController,
    required this.birthDate,
    required this.gender,
    required this.onPickDate,
    required this.onGenderChanged,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      icon: Icons.person_outline_rounded,
      title: 'profile.sections.personal'.tr(),
      children: [
        AppTextField(
          controller: nameController,
          hintText: 'profile.fields.fullName'.tr(),
          prefixIcon: Icon(
            Icons.badge_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'profile.validation.nameRequired'.tr()
              : null,
        ),
        const SizedBox(height: 12),
        ProfileDateField(
          value: birthDate,
          onTap: onPickDate,
          formatDate: formatDate,
        ),
        const SizedBox(height: 16),
        ProfileGenderSelector(
          value: gender,
          onChanged: onGenderChanged,
        ),
      ],
    );
  }
}