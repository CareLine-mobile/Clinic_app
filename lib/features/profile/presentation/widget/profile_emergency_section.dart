import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'profile_section_card.dart';

class ProfileEmergencySection extends StatelessWidget {
  final TextEditingController controller;

  const ProfileEmergencySection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      icon: Icons.emergency_outlined,
      title: 'profile.sections.emergency'.tr(),
      children: [
        AppTextField(
          controller: controller,
          hintText: 'profile.fields.emergencyContact'.tr(),
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'profile.validation.emergencyRequired'.tr()
              : null,
        ),
      ],
    );
  }
}