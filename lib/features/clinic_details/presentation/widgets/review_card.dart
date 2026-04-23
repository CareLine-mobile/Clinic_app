// ==================== review_card.dart ====================
import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/review_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';


class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  const ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
//d
    return Container(
      margin: EdgeInsets.only(bottom: vSize.s12),
      padding: EdgeInsets.all(hSize.s16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              _Avatar(
                imageUrl: review.patientImageUrl,
                name: review.patientName,
              ),
              SizedBox(width: hSize.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      DateFormat('d MMM yyyy', 'ar').format(review.date),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              _RatingPill(rating: review.rating),
            ],
          ),

          // ── Comment ──────────────────────────────────────────────
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: vSize.s10),
            Text(
              review.comment,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: theme.hintColor,
              ),
            ),
          ],

          // ── Doctor tag ───────────────────────────────────────────
          SizedBox(height: vSize.s10),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 13.sp,
                color: theme.primaryColor.withOpacity(0.7),
              ),
              SizedBox(width: 4.w),
              Text(
                'clinic.reviews.with_doctor'.tr(namedArgs: {'name': review.doctorName}),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  const _Avatar({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 20.r,
      backgroundColor: theme.primaryColor.withOpacity(0.1),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: 40.r,
          height: 40.r,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Text(
            initials,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Rating Pill ───────────────────────────────────────────────────────────────

class _RatingPill extends StatelessWidget {
  final double rating;
  const _RatingPill({required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorsManager.warningSurface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13.sp, color: ColorsManager.warningFill),
          SizedBox(width: 3.w),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.warningText,
            ),
          ),
        ],
      ),
    );
  }
}