// lib/features/clinics/presentation/widgets/clinic_services_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';

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

    return SingleChildScrollView(
      padding: EdgeInsets.all(hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخدمات والمرافق',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: vSize.s20),

          // Services Section
          _buildServiceCard(
            context,
            title: 'الخدمات المتاحة',
            icon: Icons.medical_services,
            items: services,
            color: Colors.blue,
          ),

          SizedBox(height: vSize.s16),

          // Facilities Section
          _buildServiceCard(
            context,
            title: 'المرافق',
            icon: Icons.business,
            items: facilities,
            color: Colors.green,
          ),

          SizedBox(height: vSize.s16),

          // Insurance Section
          _buildServiceCard(
            context,
            title: 'التأمينات المقبولة',
            icon: Icons.verified_user,
            items: insuranceAccepted,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<String> items,
        required Color color,
      }) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Container(
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
              Container(
                padding: EdgeInsets.all(hSize.s8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(hSize.s8),
                ),
                child: Icon(icon, size: 24.r, color: color),
              ),
              SizedBox(width: hSize.s12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: vSize.s12),
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: vSize.s8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20.r,
                  color: color,
                ),
                SizedBox(width: hSize.s12),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}