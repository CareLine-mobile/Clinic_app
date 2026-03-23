// lib/features/clinics/presentation/widgets/reviews_section_widget.dart

import 'package:clinic_app/features/clinic_details/domain/entites/review_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/review_card.dart' show ReviewCard;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_size.dart';
import '../../domain/entites/clinic_entities.dart';

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

    return SingleChildScrollView(
      padding: EdgeInsets.all(hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التقييمات والآراء',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: vSize.s20),

          // Overall Rating Card
          Container(
            padding: EdgeInsets.all(hSize.s20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(hSize.s16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                // Rating Number
                Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          index < averageRating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20.r,
                        ),
                      ),
                    ),
                    SizedBox(height: vSize.s4),
                    Text(
                      '$totalReviews تقييم',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(width: hSize.s32),

                // Rating Distribution
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final stars = 5 - index;
                      final count = reviews
                          .where((r) => r.rating.floor() == stars)
                          .length;
                      final percentage = totalReviews > 0
                          ? (count / totalReviews * 100)
                          : 0.0;

                      return Padding(
                        padding: EdgeInsets.only(bottom: vSize.s8),
                        child: Row(
                          children: [
                            Text(
                              '$stars',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(width: hSize.s4),
                            Icon(Icons.star, size: 14.r, color: Colors.amber),
                            SizedBox(width: hSize.s8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey[200],
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(width: hSize.s8),
                            Text(
                              '${percentage.toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall,
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

          SizedBox(height: vSize.s24),

          // Reviews List
          Text(
            'آراء المرضى',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: vSize.s16),

          if (reviews.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(vSize.s32),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64.r,
                      color: Theme.of(context).hintColor,
                    ),
                    SizedBox(height: vSize.s16),
                    Text(
                      'لا توجد تقييمات بعد',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
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
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(review: review);
              },
            ),
        ],
      ),
    );
  }
}

