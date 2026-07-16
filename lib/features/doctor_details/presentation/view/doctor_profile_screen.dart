import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/Loading_widget.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/widgets/empty_state_widget.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/review_card.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_app/features/doctor_details/presentation/cubit/doctor_profile_cubit.dart';
import 'package:clinic_app/features/doctor_details/presentation/widgets/doctor_rating_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text_widgets.dart';
import '../widgets/DoctorAvailableSlotsSection.dart';
import '../widgets/DoctorClinicCard.dart';
import '../widgets/DoctorExperienceSection.dart';
import '../widgets/DoctorReviewsSection.dart';
import '../widgets/DoctorSpecialtiesChips.dart';
import '../widgets/Info_tile.dart';
import '../widgets/doctor_bio_section.dart';
import '../widgets/doctor_quick_actions.dart';
import '../widgets/doctor_rating_section.dart';
import '../widgets/doctor_sliver_appBar.dart';
import '../widgets/section_divider.dart';

class DoctorProfileScreen extends StatefulWidget {
  final int doctorId;

  const DoctorProfileScreen({Key? key, required this.doctorId})
      : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarSolid = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    context.read<DoctorProfileCubit>().loadDoctor(widget.doctorId);
  }

  void _handleScroll() {
    final solid = _scrollController.offset > 200;
    if (solid != _isAppBarSolid) {
      setState(() => _isAppBarSolid = solid);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
      listener: _handleStateChanges,
      builder: (context, state) => switch (state) {
        DoctorProfileLoading() => const Scaffold(body: LoadingSpinner()),
        DoctorProfileError(:final message) => Scaffold(
          body: EmptyStateWidget(
            title: message,
            icon: Icons.error_outline_rounded,
            enableBackButton: true,
            onBackPressed: () => Navigator.pop(context),
            onActionPressed: () => context
                .read<DoctorProfileCubit>()
                .loadDoctor(widget.doctorId),
            actionLabel: 'common.retry'.tr(),
            subtitle: 'doctorProfile.loadErrorTitle'.tr(),
          ),
        ),
        DoctorProfileLoaded(:final doctor, :final isRatingLoading) =>
            _buildProfile(doctor, isRatingLoading),
        DoctorRatingSuccess(:final doctor) => _buildProfile(doctor, false),
        DoctorRatingError(:final doctor) => _buildProfile(doctor, false),
        _ => const Scaffold(body: LoadingSpinner()),
      },
    );
  }

  void _handleStateChanges(BuildContext ctx, DoctorProfileState state) {
    switch (state) {
      case DoctorRatingSuccess():
        CustomSnackBar.show(
          ctx,
          message: 'doctorProfile.ratingSuccess'.tr(),
          type: SnackBarType.success,
        );
        break;
      case DoctorRatingError(:final message):
        CustomSnackBar.show(
          ctx,
          message: message,
          type: SnackBarType.error,
        );
        break;
      default:
        break;
    }
  }

  Widget _buildProfile(DoctorProfileEntity doctor, bool isRatingLoading) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              DoctorSliverAppBar(
                doctor: doctor,
                isAppBarSolid: _isAppBarSolid,
                onBackTap: () => Navigator.pop(context),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorRatingSection(doctor: doctor),
                    DoctorQuickActions(
                      onShare: () => HapticFeedback.lightImpact(),
                      onSave: () => HapticFeedback.lightImpact(),
                    ),
                    const SectionDivider(),
                    DoctorBioSection(doctor: doctor),
                    const SectionDivider(),
                    DoctorExperienceSection(doctor: doctor),
                    const SectionDivider(),
                    DoctorSpecialtiesChips(doctor: doctor),
                    const SectionDivider(),
                    DoctorClinicCard(doctor: doctor),
                    const SectionDivider(),
                    DoctorAvailableSlotsSection(doctor: doctor),
                    const SectionDivider(),
                    DoctorReviewsSection(doctor: doctor),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
          // Rating loading overlay
          if (isRatingLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: const Center(child: LoadingSpinner()),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showRatingDialog(DoctorProfileEntity doctor) async {
    HapticFeedback.mediumImpact();
    final rating = await DoctorRatingDialog.show(
      context,
      doctorName: doctor.name,
    );
    if (rating != null && mounted) {
      context.read<DoctorProfileCubit>().rateDoctor(rating);
    }
  }
}

// ── Capitalize helper ─────────────────────────────────────────────────────
String capitalizeWord(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();


























