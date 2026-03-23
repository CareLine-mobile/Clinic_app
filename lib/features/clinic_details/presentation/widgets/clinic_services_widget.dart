import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/components/section_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class ClinicServicesWidget extends StatelessWidget {
  final List<String> services;
  final List<String> facilities;
  final List<String> insuranceAccepted;

  const ClinicServicesWidget({
    Key? key,
    required this.services,
    required this.facilities,
    required this.insuranceAccepted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    if (services.isEmpty && facilities.isEmpty && insuranceAccepted.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.medical_services_outlined,
        title: 'clinic.services.empty_title'.tr(),
        subtitle: 'clinic.services.empty_subtitle'.tr(),
        enableBackButton: false,
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (services.isNotEmpty) ...[
            _ServiceSection(
              title: 'clinic.services.services'.tr(),
              icon: Icons.medical_services_outlined,
              items: services,
              color: ColorsManager.infoFill,
            ),
            SizedBox(height: vSize.s16),
          ],
          if (facilities.isNotEmpty) ...[
            _ServiceSection(
              title: 'clinic.services.facilities'.tr(),
              icon: Icons.business_outlined,
              items: facilities,
              color: ColorsManager.successFill,
            ),
            SizedBox(height: vSize.s16),
          ],
          if (insuranceAccepted.isNotEmpty)
            _ServiceSection(
              title: 'clinic.services.insurance'.tr(),
              icon: Icons.verified_user_outlined,
              items: insuranceAccepted,
              color: ColorsManager.warningFill,
            ),
        ],
      ),
    );
  }
}

// ==================== Service Section ====================
class _ServiceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Color color;

  const _ServiceSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(hSize.s16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(hSize.s12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceHeader(
            icon: icon,
            title: title,
            color: color,
            itemCount: items.length,
          ),
          SizedBox(height: vSize.s16),
          ...items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : vSize.s12),
              child: _ServiceItem(text: entry.value, color: color),
            );
          }),
        ],
      ),
    );
  }
}

// ==================== Service Header ====================
class _ServiceHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int itemCount;

  const _ServiceHeader({
    required this.icon,
    required this.title,
    required this.color,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(hSize.s10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(hSize.s10),
          ),
          child: Icon(icon, size: 24.r, color: color),
        ),
        SizedBox(width: hSize.s12),
        Expanded(
          child: SectionHeader(title: title, accentColor: color),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: hSize.s10, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(hSize.s12),
          ),
          child: Text(
            '$itemCount',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Service Item ====================
class _ServiceItem extends StatelessWidget {
  final String text;
  final Color color;

  const _ServiceItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(Icons.check_circle, size: 20.r, color: color),
        ),
        SizedBox(width: hSize.s12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}