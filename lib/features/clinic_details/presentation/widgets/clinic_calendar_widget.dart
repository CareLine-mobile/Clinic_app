// lib/features/clinics/presentation/widgets/details/

// ==================== clinic_calendar_widget.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';
import 'package:intl/intl.dart';
import '../../data/clinic_details_model.dart';
import '../../domain/entites/clinic_entities.dart';



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

class DoctorListWidget extends StatelessWidget {
  final List<Doctor> doctors;
  final DateTime selectedDate;
  final Doctor? selectedDoctor;
  final Function(Doctor) onDoctorSelected;
  final Color accentColor;

  const DoctorListWidget({
    Key? key,
    required this.doctors,
    required this.selectedDate,
    required this.selectedDoctor,
    required this.onDoctorSelected,
    required this.accentColor,
  }) : super(key: key);

  List<Doctor> _getAvailableDoctors() {
    // Filter doctors who have available slots for selected date
    return doctors.where((doctor) {
      return doctor.availableSlots.any((slot) =>
      slot.dateTime.day == selectedDate.day &&
          slot.dateTime.month == selectedDate.month &&
          slot.dateTime.year == selectedDate.year &&
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
        SizedBox(height: vSize.s16),

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
class DoctorCard extends StatelessWidget {
  final Doctor doctor;
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

  List<DoctorAvailabilitySlot> _getAvailableSlots() {
    return doctor.availableSlots.where((slot) =>
    slot.dateTime.day == selectedDate.day &&
        slot.dateTime.month == selectedDate.month &&
        slot.dateTime.year == selectedDate.year &&
        slot.isAvailable).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
    final availableSlots = _getAvailableSlots();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: vSize.s12),
        padding: EdgeInsets.all(hSize.s16),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.1)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(hSize.s16),
          border: Border.all(
            color: isSelected ? accentColor : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Doctor Image
                CircleAvatar(
                  radius: 32.r,
                  backgroundImage: NetworkImage(doctor.imageUrl),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: ClipOval(
                    child: Image.network(
                      doctor.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: accentColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            size: 32.r,
                            color: accentColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: hSize.s12),

                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: vSize.s4),
                      Text(
                        doctor.specialty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: vSize.s4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.r,
                            color: Colors.amber,
                          ),
                          SizedBox(width: hSize.s4),
                          Text(
                            '${doctor.rating} (${doctor.reviewsCount})',
                            style: theme.textTheme.bodySmall,
                          ),
                          SizedBox(width: hSize.s12),
                          Icon(
                            Icons.work_outline,
                            size: 16.r,
                            color: theme.hintColor,
                          ),
                          SizedBox(width: hSize.s4),
                          Text(
                            '${doctor.experienceYears} سنوات',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${doctor.consultationFee.toInt()} ج.م',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      'سعر الكشف',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),

            // Available Time Slots
            if (availableSlots.isNotEmpty) ...[
              SizedBox(height: vSize.s12),
              const Divider(),
              SizedBox(height: vSize.s8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.r,
                    color: theme.hintColor,
                  ),
                  SizedBox(width: hSize.s8),
                  Text(
                    'المواعيد المتاحة:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: vSize.s8),
              Wrap(
                spacing: hSize.s8,
                runSpacing: vSize.s8,
                children: availableSlots.take(4).map((slot) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: hSize.s12,
                      vertical: vSize.s6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentColor
                          : accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(hSize.s8),
                    ),
                    child: Text(
                      slot.timeSlot,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected ? Colors.white : accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (availableSlots.length > 4)
                Padding(
                  padding: EdgeInsets.only(top: vSize.s8),
                  child: Text(
                    '+${availableSlots.length - 4} مواعيد أخرى',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],

            // View Details Button
            SizedBox(height: vSize.s12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(hSize.s10),
                  ),
                ),
                child: Text(
                  'عرض التفاصيل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== review_card.dart ====================
class ReviewCard extends StatelessWidget {
  final ReviewModel review;

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