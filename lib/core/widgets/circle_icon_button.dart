import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool heroic;
  const CircleIconButton(
      {required this.onTap, required this.icon, this.heroic = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.r),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: heroic ? Colors.black38 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: heroic ? Colors.white : Theme.of(context).iconTheme.color,
          size: 20.sp,
        ),
      ),
    );
  }
}