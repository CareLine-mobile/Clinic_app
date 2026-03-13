// ==================== review_card.dart ====================
import 'package:clinic_app/features/clinic_details/domain/entites/review_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';


class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Container(
      margin: EdgeInsets.only(bottom: vSize.s16),
      padding: EdgeInsets.all(hSize.s16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(hSize.s12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                child: ClipOval(
                  child: Image.network(
                    review.patientImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.person, size: 20.r, color: Colors.grey[600]),
                    ),
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
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy', 'ar').format(review.date),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                      (index) => Icon(
                    index < review.rating.floor() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: vSize.s12),
          Text(review.comment, style: theme.textTheme.bodyMedium),
          SizedBox(height: vSize.s8),
          Text(
            'مع: ${review.doctorName}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}