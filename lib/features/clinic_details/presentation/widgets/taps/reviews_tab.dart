// ==================== tabs/reviews_tab.dart ====================
import 'package:flutter/material.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../widgets/reviews_section_widget.dart';

class ReviewsTab extends StatelessWidget {
  final ClinicEntity clinic;

  const ReviewsTab({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReviewsSectionWidget(
      reviews: clinic.reviews,
      averageRating: clinic.rating,
      totalReviews: clinic.reviewsCount,
    );
  }
}