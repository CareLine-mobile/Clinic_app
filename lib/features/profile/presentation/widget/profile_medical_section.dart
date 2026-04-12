import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'profile_section_card.dart';
import 'profile_blood_type_selector.dart';
import 'profile_chronic_diseases_input.dart';

class ProfileMedicalSection extends StatelessWidget {
  final String? bloodType;
  final List<String> chronicDiseases;
  final TextEditingController addDiseaseController;
  final ValueChanged<String> onBloodTypeToggle;
  final VoidCallback onAddDisease;
  final ValueChanged<String> onRemoveDisease;

  const ProfileMedicalSection({
    Key? key,
    required this.bloodType,
    required this.chronicDiseases,
    required this.addDiseaseController,
    required this.onBloodTypeToggle,
    required this.onAddDisease,
    required this.onRemoveDisease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      icon: Icons.medical_information_outlined,
      title: 'profile.sections.medical'.tr(),
      children: [
        ProfileBloodTypeSelector(
          selected: bloodType,
          onToggle: onBloodTypeToggle,
        ),
        const SizedBox(height: 16),
        ProfileChronicDiseasesInput(
          diseases: chronicDiseases,
          addController: addDiseaseController,
          onAdd: onAddDisease,
          onRemove: onRemoveDisease,
        ),
      ],
    );
  }
}