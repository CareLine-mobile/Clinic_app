// ==================== review_card.dart ====================
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