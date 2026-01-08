// lib/features/clinics/presentation/widgets/reviews_section_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_size.dart';
import '../../data/clinic_details_model.dart';
import '../../domain/entites/clinic_entities.dart';

class ReviewsSectionWidget extends StatelessWidget {
  final List<Review> reviews;
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
                return _ReviewCard(review: review);
              },
            ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Container(
      margin: EdgeInsets.only(bottom: vSize.s16),
      padding: EdgeInsets.all(hSize.s16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(hSize.s12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(review.patientImageUrl),
                onBackgroundImageError: (exception, stackTrace) {},
                child: ClipOval(
                  child: Image.network(
                    review.patientImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 24.r,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: hSize.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: vSize.s2),
                    Text(
                      DateFormat('dd/MM/yyyy', 'ar').format(review.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: hSize.s8,
                  vertical: vSize.s4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(hSize.s8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 16.r, color: Colors.amber),
                    SizedBox(width: hSize.s4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: vSize.s12),
          Text(
            review.comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: vSize.s8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: hSize.s8,
              vertical: vSize.s4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(hSize.s6),
            ),
            child: Text(
              'مع: ${review.doctorName}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}