import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../helpers/profile_form_controller.dart';
import '../widget/profile_emergency_section.dart';
import '../widget/profile_load_error_widget.dart';
import '../widget/profile_medical_section.dart';
import '../widget/profile_personal_section.dart';
import '../widget/profile_progress_section.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = ProfileFormController();

  @override
  void initState() {
    super.initState();
    _ctrl.init();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_ctrl.birthDate == null) {
      CustomSnackBar.show(
        context,
        message: 'profile.validation.birthDateRequired'.tr(),
        type: SnackBarType.error,
      );
      return;
    }
    if (_ctrl.gender == null) {
      CustomSnackBar.show(
        context,
        message: 'profile.validation.genderRequired'.tr(),
        type: SnackBarType.error,
      );
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      fullName: _ctrl.nameController.text.trim(),
      birthDate: _ctrl.birthDate!,
      gender: _ctrl.gender!,
      bloodType: _ctrl.bloodType,
      chronicDiseases: _ctrl.chronicDiseases.isEmpty
          ? null
          : List.from(_ctrl.chronicDiseases),
      emergencyContact: _ctrl.emergencyController.text.trim(),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('profile.appBarTitle'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (_, current) =>
        current is ProfileLoaded ||
            current is ProfileLoadError ||
            current is ProfileUpdateSuccess ||
            current is ProfileUpdateFailure,
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _ctrl.populateFrom(state.profile, () => setState(() {}));
          } else if (state is ProfileLoadError) {
            CustomSnackBar.show(context,
                message: state.message, type: SnackBarType.error);
          } else if (state is ProfileUpdateSuccess) {
            CustomSnackBar.show(
              context,
              message: 'profile.messages.saveSuccess'.tr(),
              type: SnackBarType.success,
            );
            Future.delayed(const Duration(milliseconds: 900), () {
              if (mounted) Navigator.pop(context);
            });
          } else if (state is ProfileUpdateFailure) {
            CustomSnackBar.show(context,
                message: state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          if (!_ctrl.isInitialized &&
              (state is ProfileInitial || state is ProfileLoading)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_ctrl.isInitialized && state is ProfileLoadError) {
            return ProfileLoadErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }

          final isUpdating = state is ProfileUpdating;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileProgressSection(
                    progressNotifier: _ctrl.progressNotifier,
                    progressColor: _ctrl.progressColor,
                    progressHint: _ctrl.progressHint,
                  ),
                  const SizedBox(height: 20),
                  ProfilePersonalSection(
                    nameController: _ctrl.nameController,
                    birthDate: _ctrl.birthDate,
                    gender: _ctrl.gender,
                    onPickDate: () =>
                        _ctrl.pickDate(context, () => setState(() {})),
                    onGenderChanged: (v) =>
                        _ctrl.onGenderChanged(v, () => setState(() {})),
                    formatDate: _ctrl.formatDate,
                  ),
                  const SizedBox(height: 14),
                  ProfileMedicalSection(
                    bloodType: _ctrl.bloodType,
                    chronicDiseases: _ctrl.chronicDiseases,
                    addDiseaseController: _ctrl.addDiseaseController,
                    onBloodTypeToggle: (t) =>
                        _ctrl.onBloodTypeSelected(t, () => setState(() {})),
                    onAddDisease: () =>
                        _ctrl.addDisease(() => setState(() {})),
                    onRemoveDisease: (d) =>
                        _ctrl.removeDisease(d, () => setState(() {})),
                  ),
                  const SizedBox(height: 14),
                  ProfileEmergencySection(
                    controller: _ctrl.emergencyController,
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    text: 'profile.actions.save'.tr(),
                    onPressed: isUpdating ? null : _submit,
                    isLoading: isUpdating,
                    horizontalPadding: 0,
                    verticalPadding: 0,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}