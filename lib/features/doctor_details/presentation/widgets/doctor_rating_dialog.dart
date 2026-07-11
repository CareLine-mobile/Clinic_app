import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';

/// A bottom-sheet style rating dialog with animated star picker.
/// Returns the selected rating (1–5) via Navigator.pop, or null if dismissed.
class DoctorRatingDialog extends StatefulWidget {
  final String doctorName;
  final double initialRating;

  const DoctorRatingDialog({
    Key? key,
    required this.doctorName,
    this.initialRating = 0,
  }) : super(key: key);

  static Future<double?> show(
      BuildContext context, {
        required String doctorName,
        double initialRating = 0,
      }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DoctorRatingDialog(
        doctorName: doctorName,
        initialRating: initialRating,
      ),
    );
  }

  @override
  State<DoctorRatingDialog> createState() => _DoctorRatingDialogState();
}

class _DoctorRatingDialogState extends State<DoctorRatingDialog>
    with SingleTickerProviderStateMixin {
  double _selectedRating = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getRatingLabel() {
    if (_selectedRating == 0) return 'doctorProfile.tapToRate'.tr();
    if (_selectedRating <= 1) return 'doctorProfile.ratingPoor'.tr();
    if (_selectedRating <= 2) return 'doctorProfile.ratingFair'.tr();
    if (_selectedRating <= 3) return 'doctorProfile.ratingGood'.tr();
    if (_selectedRating <= 4) return 'doctorProfile.ratingVeryGood'.tr();
    return 'doctorProfile.ratingExcellent'.tr();
  }

  Color _getRatingColor() {
    if (_selectedRating == 0) return Colors.grey;
    if (_selectedRating <= 2) return ColorsManager.errorFill;
    if (_selectedRating <= 3) return ColorsManager.warningFill;
    return ColorsManager.successFill;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ─────────────────────────────────────────
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),

            // ── Icon ───────────────────────────────────────────
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManager.warningFill,
                    ColorsManager.warningFill.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.warningFill.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 38.sp,
              ),
            ),
            SizedBox(height: 20.h),

            // ── Title ──────────────────────────────────────────
            Text(
              'doctorProfile.rateYourExperience'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'doctorProfile.howWasVisit'
                  .tr(namedArgs: {'name': widget.doctorName}),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),

            // ── Star selector ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starValue = (i + 1).toDouble();
                final filled = starValue <= _selectedRating;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = starValue),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: filled ? 46.sp : 40.sp,
                      color: filled
                          ? ColorsManager.warningFill
                          : theme.hintColor.withOpacity(0.4),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 12.h),

            // ── Rating label ──────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _getRatingLabel(),
                key: ValueKey(_selectedRating),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _getRatingColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // ── Submit Button ─────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _selectedRating > 0
                    ? () => Navigator.pop(context, _selectedRating)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  ColorsManager.primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'doctorProfile.submitRating'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'common.cancel'.tr(),
                style: TextStyle(color: theme.hintColor, fontSize: 14.sp),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}