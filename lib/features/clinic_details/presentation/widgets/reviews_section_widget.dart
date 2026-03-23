import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/review_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/components/section_header.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/review_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';

class ReviewsSectionWidget extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final double averageRating;
  final int totalReviews;

  const ReviewsSectionWidget({
    Key? key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'clinic.reviews.title'.tr()),
          SizedBox(height: vSize.s20),

          // Overall Rating Card
          Container(
            padding: EdgeInsets.all(hSize.s20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                // ── Big number ──────────────────────────────────
                Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                            (i) => Icon(
                          i < averageRating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: ColorsManager.warningFill,
                          size: 16.r,
                        ),
                      ),
                    ),
                    SizedBox(height: vSize.s4),
                    Text(
                      'clinic.reviews.total'
                          .tr(namedArgs: {'count': '$totalReviews'}),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: hSize.s24),

                // ── Distribution bars ────────────────────────────
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final stars = 5 - i;
                      final count = reviews
                          .where((r) => r.rating.floor() == stars)
                          .length;
                      final pct =
                      totalReviews > 0 ? count / totalReviews : 0.0;

                      return Padding(
                        padding: EdgeInsets.only(bottom: vSize.s6),
                        child: Row(
                          children: [
                            Text('$stars', style: theme.textTheme.labelSmall),
                            SizedBox(width: 4.w),
                            Icon(Icons.star_rounded,
                                size: 11.sp,
                                color: ColorsManager.warningFill),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 5.h,
                                  backgroundColor:
                                  theme.dividerColor.withOpacity(0.15),
                                  color: ColorsManager.warningFill,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            SizedBox(
                              width: 28.w,
                              child: Text(
                                '${(pct * 100).toInt()}%',
                                style: theme.textTheme.labelSmall,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: vSize.s20),

          SectionHeader(title: 'clinic.reviews.patients_reviews'.tr()),
          SizedBox(height: vSize.s12),

          if (reviews.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(vSize.s32),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64.r,
                      color: theme.hintColor,
                    ),
                    SizedBox(height: vSize.s16),
                    Text(
                      'clinic.reviews.empty'.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (_, index) => ReviewCard(review: reviews[index]),
            ),
        ],
      ),
    );
  }
}