import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// TODO: تأكد من مسار ColorsManager و EmptyStateWidget
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class ClinicServicesWidget extends StatelessWidget {
  final List<String> services;
  final List<String> facilities;
  final List<String> insuranceAccepted;

  const ClinicServicesWidget({
    super.key,
    required this.services,
    required this.facilities,
    required this.insuranceAccepted,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty && facilities.isEmpty && insuranceAccepted.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.dashboard_customize_outlined,
        title: 'clinic.services.empty_title'.tr(),
        subtitle: 'clinic.services.empty_subtitle'.tr(),
        enableBackButton: false,
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (services.isNotEmpty) ...[
            _SectionWrapper(
              title: 'clinic.services.services'.tr(),
              count: services.length,
              child: _buildServicesList(services, context),
            ),
            SizedBox(height: 32.h),
          ],

          if (facilities.isNotEmpty) ...[
            _SectionWrapper(
              title: 'clinic.services.facilities'.tr(),
              count: facilities.length,
              child: _buildDotChips(facilities, context),
            ),
            SizedBox(height: 32.h),
          ],

          if (insuranceAccepted.isNotEmpty)
            _SectionWrapper(
              title: 'clinic.services.insurance'.tr(),
              count: insuranceAccepted.length,
              child: _buildDotChips(insuranceAccepted, context),
            ),
        ],
      ),
    );
  }

  // ─── 1. تصميم الخدمات ───
  Widget _buildServicesList(List<String> items, BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            // ✨ التعديل هنا: استخدمنا لون السطح مع شفافية عشان يشتغل في الفاتح والغامق
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  items[index],
                  // ✨ التعديل هنا: اعتمدنا على لون الـ Theme الافتراضي (أسود في الفاتح وأبيض في الغامق)
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── 2. تصميم المرافق والتأمينات ───
  Widget _buildDotChips(List<String> items, BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10.w,
      runSpacing: 12.h,
      children: items.map((item) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              // ✨ التعديل هنا: لون الحدود يتكيف مع الـ Dark Mode
              color: theme.dividerColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                item,
                // ✨ التعديل هنا: عدم إجبار النص على لون ثابت
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── هيدر القسم ───
class _SectionWrapper extends StatelessWidget {
  final String title;
  final int count;
  final Widget child;

  const _SectionWrapper({
    required this.title,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              // ✨ التعديل هنا: نعتمد على theme.textTheme مباشرة
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '$count',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        child,
      ],
    );
  }
}