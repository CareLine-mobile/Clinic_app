import 'package:flutter/material.dart';
import '../../../../core/utils/app_size.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SizeApp.s16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeApp.s16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(SizeApp.s16),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
              size: SizeApp.s20,
            ),
            SizedBox(width: SizeApp.s8),
            Text(
              'تسجيل الخروج',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: SizeApp.s16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}