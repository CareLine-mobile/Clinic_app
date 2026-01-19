// lib/features/clinics/presentation/widgets/details/

// ==================== clinic_calendar_widget.dart ====================
import 'package:clinic_app/features/clinic_details/domain/entites/doctor_entity.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/review_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';
import 'package:intl/intl.dart';



class ClinicCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Color accentColor;

  const ClinicCalendarWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<ClinicCalendarWidget> createState() => _ClinicCalendarWidgetState();
}

class _ClinicCalendarWidgetState extends State<ClinicCalendarWidget> {
  late DateTime _currentMonth;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _getDaysInWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(14, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
    final days = _getDaysInWeek();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر التاريخ',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: vSize.s16),

        // Horizontal Calendar
        SizedBox(
          height: 90.h,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day.day == widget.selectedDate.day &&
                  day.month == widget.selectedDate.month &&
                  day.year == widget.selectedDate.year;
              final isToday = day.day == DateTime.now().day &&
                  day.month == DateTime.now().month &&
                  day.year == DateTime.now().year;

              return GestureDetector(
                onTap: () => widget.onDateSelected(day),
                child: Container(
                  width: 70.w,
                  margin: EdgeInsets.only(right: hSize.s8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.accentColor
                        : isToday
                        ? widget.accentColor.withOpacity(0.1)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(hSize.s12),
                    border: Border.all(
                      color: isSelected
                          ? widget.accentColor
                          : isToday
                          ? widget.accentColor.withOpacity(0.5)
                          : theme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE', 'ar').format(day),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: vSize.s4),
                      Text(
                        day.day.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.titleLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM', 'ar').format(day),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==================== doctor_list_widget.dart ====================

// lib/features/clinics/presentation/widgets/details/doctor_list_widget.dart
class DoctorListWidget extends StatelessWidget {
  final List<DoctorEntity> doctors;
  final DateTime selectedDate;
  final DoctorEntity? selectedDoctor;
  final Function(DoctorEntity) onDoctorSelected;
  final Color accentColor;

  const DoctorListWidget({
    Key? key,
    required this.doctors,
    required this.selectedDate,
    required this.selectedDoctor,
    required this.onDoctorSelected,
    required this.accentColor,
  }) : super(key: key);

  String _getDayName(DateTime date) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[date.weekday - 1];
  }

  List<DoctorEntity> _getAvailableDoctors() {
    final dayName = _getDayName(selectedDate);

    return doctors.where((doctor) {
      // Check if doctor has any available slots for the selected day
      return doctor.availableSlots.any((slot) =>
      slot.day.toLowerCase() == dayName.toLowerCase() &&
          slot.isAvailable);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final availableDoctors = _getAvailableDoctors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأطباء المتاحون (${availableDoctors.length})',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (availableDoctors.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(vSize.s32),
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64.r,
                    color: theme.hintColor,
                  ),
                  SizedBox(height: vSize.s16),
                  Text(
                    'لا يوجد أطباء متاحون في هذا التاريخ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableDoctors.length,
            itemBuilder: (context, index) {
              final doctor = availableDoctors[index];
              return DoctorCard(
                doctor: doctor,
                selectedDate: selectedDate,
                isSelected: selectedDoctor?.id == doctor.id,
                onTap: () => onDoctorSelected(doctor),
                accentColor: accentColor,
              );
            },
          ),
      ],
    );
  }
}
// ==================== doctor_card.dart ====================
// lib/features/clinics/presentation/widgets/details/doctor_card.dart
class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final DateTime selectedDate;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.selectedDate,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  }) : super(key: key);

  String _getDayName(DateTime date) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    // Get slots for selected date
    final dayName = _getDayName(selectedDate);
    final availableSlots = doctor.availableSlots
        .where((slot) =>
    slot.day.toLowerCase() == dayName.toLowerCase() &&
        slot.isAvailable)
        .toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP ROW: Image + Info + Price ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 65.w,
                      height: 65.w,
                      color: Colors.grey.shade100,
                      child: Icon(Icons.person, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // 2. Main Info (Name, Spec, Rating)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doctor.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Rating & Experience Row
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 16.sp, color: Colors.amber),
                          SizedBox(width: 4.w),
                          Text(
                            doctor.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(Icons.work_outline,
                              size: 14.sp, color: Colors.grey.shade400),
                          SizedBox(width: 4.w),
                          Text(
                            '${doctor.experienceYears} سنة',
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Price (Right side)
                Column(
                  children: [
                    Text(
                      '${doctor.consultationFee.toInt()}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      'ج.م',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // --- BOTTOM SECTION: Slots ---
            SizedBox(height: 16.h),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12.h),

            if (availableSlots.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: availableSlots.map((slot) {
                    return Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? accentColor : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: isSelected
                                ? accentColor
                                : Colors.grey.shade200),
                      ),
                      child: Text(
                        slot.timeSlot,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16.sp, color: Colors.grey.shade400),
                  SizedBox(width: 6.w),
                  Text(
                    'لا توجد مواعيد متاحة اليوم',
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey.shade500),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== review_card.dart ====================
class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

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
                          size: 20.r,
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
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                    index < review.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 16.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: vSize.s12),
          Text(
            review.comment,
            style: theme.textTheme.bodyMedium,
          ),
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


