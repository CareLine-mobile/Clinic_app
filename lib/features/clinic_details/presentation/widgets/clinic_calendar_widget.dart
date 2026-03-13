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

