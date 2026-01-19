// ==================== components/clinic_app_bar.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/app_buton.dart';
import '../../../domain/entites/clinic_entities.dart';


class ClinicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ClinicEntity clinic;
  final bool isTransparent;
  final bool isFavorite; // أضف هذا
  final VoidCallback onFavoriteToggle; // أضف هذا

  const ClinicAppBar({
    Key? key,
    required this.clinic,
    required this.isTransparent,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isTransparent ? Colors.transparent : Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: AppBarButton(
        icon: Icons.arrow_back_ios_new, // شكل عصري أكثر
        isTransparent: isTransparent,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // زر المشاركة
        AppBarButton(
          icon: Icons.share_outlined,
          isTransparent: isTransparent,
          onPressed: onFavoriteToggle,
        ),
        // زر المفضلة
        AppBarButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          isTransparent: isTransparent,
          onPressed: onFavoriteToggle,
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}