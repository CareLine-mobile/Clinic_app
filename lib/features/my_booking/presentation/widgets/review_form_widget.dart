import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:clinic_app/features/my_booking/domain/usecase/CreateReviewUseCase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';

class ReviewFormWidget extends StatefulWidget {
  final BookingEntity booking;

  const ReviewFormWidget({super.key, required this.booking});

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  double _rating = 5.0;
  final _commentController = TextEditingController();

  // null = جاري التحقق، true = راجع، false = لسه
  bool? _alreadyReviewed;

  @override
  void initState() {
    super.initState();
    _checkIfReviewed();
  }

  Future<void> _checkIfReviewed() async {
    final reviewed = await context
        .read<BookingCubit>()
        .isClinicReviewed(widget.booking.clinical.id);
    if (mounted) setState(() => _alreadyReviewed = reviewed);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_commentController.text.trim().isEmpty) return;
    context.read<BookingCubit>().submitReview(
      CreateReviewParams(
        clinicId: widget.booking.clinical.id,
        bookingId: widget.booking.id,
        rating: _rating,
        comment: _commentController.text.trim(),
        doctorId: widget.booking.doctor.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // جاري التحقق من الكاش
    if (_alreadyReviewed == null) return const SizedBox.shrink();

    // عمل review قبل كده
    if (_alreadyReviewed!) return const _SuccessBanner();

    final theme = Theme.of(context);

    return BlocConsumer<BookingCubit, BookingState>(
      listenWhen: (_, curr) => curr is ReviewSuccess || curr is ReviewError,
      listener: (context, state) {
        if (state is ReviewSuccess) {
          // الـ cubit حفظ في الكاش بالفعل — بس نحدث الـ UI
          setState(() => _alreadyReviewed = true);
        } else if (state is ReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ReviewSubmitting;

        return Container(
          margin: EdgeInsets.only(top: 8.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.rate_review_outlined,
                      color: theme.primaryColor, size: 22.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'reviews.form.title'.tr(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              Divider(height: 24.h),
              Text('reviews.form.ratingLabel'.tr(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              _StarRatingRow(
                rating: _rating,
                onChanged: (v) => setState(() => _rating = v),
                enabled: !isLoading,
              ),
              SizedBox(height: 16.h),
              Text('reviews.form.commentLabel'.tr(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _commentController,
                enabled: !isLoading,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'reviews.form.commentHint'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide:
                    BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : Text('reviews.form.submit'.tr(),
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StarRatingRow extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const _StarRatingRow({
    required this.rating,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final starValue = (i + 1).toDouble();
        return GestureDetector(
          onTap: enabled ? () => onChanged(starValue) : null,
          child: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              rating >= starValue
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: Colors.amber[700],
              size: 32.sp,
            ),
          ),
        );
      }),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'reviews.form.success'.tr(),
              maxLines: 2,
              style: const TextStyle(
                  color: Color(0xFF2E7D32), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}