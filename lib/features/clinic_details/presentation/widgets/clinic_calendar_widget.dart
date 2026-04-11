import 'package:clinic_app/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_size.dart';

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
  final ScrollController _scrollController = ScrollController();

  List<DateTime> _getDays() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day); // midnight — strips time
    return List.generate(14, (i) => start.add(Duration(days: i)));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
    final days = _getDays();

    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'clinic.choose_date'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: vSize.s12),

        SizedBox(
          height: 85.h,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), // إضافة حركة سحب سلسة
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day.day == widget.selectedDate.day &&
                  day.month == widget.selectedDate.month &&
                  day.year == widget.selectedDate.year;
              final isToday = index == 0;

              final dayString = isArabic
                  ? day.arabicDayName
                  : day.dayName.substring(0, 3).toUpperCase();

              return Padding(
                padding: EdgeInsets.only(right: hSize.s8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 65.w, // عرض أقل لتوفير المساحة
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.accentColor
                        : isToday
                        ? widget.accentColor.withOpacity(0.08)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? widget.accentColor
                          : isToday
                          ? widget.accentColor.withOpacity(0.3)
                          : theme.dividerColor.withOpacity(0.5),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: widget.accentColor.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () => widget.onDateSelected(day),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // اسم اليوم
                          Text(
                            dayString,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          // رقم اليوم
                          Text(
                            day.day.toString(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          // اسم الشهر (يظل معتمد على intl لأنه غير موجود في الـ Extension)
                          Text(
                            DateFormat('MMM', context.locale.languageCode).format(day),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : theme.textTheme.bodySmall?.color,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
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