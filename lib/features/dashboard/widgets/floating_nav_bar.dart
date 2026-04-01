import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/utils/app_size.dart';
import '../../../core/widgets/CustomIcon.dart';

class FloatingNavBar extends StatelessWidget {
  final List<String> displayIcons;
  final int currentIndex;
  final bool isRTL;
  final int totalIcons;
  final Color activeColor;
  final Color inactiveColor;
  final Color glassColor;
  final Color borderColor;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    required this.displayIcons,
    required this.currentIndex,
    required this.isRTL,
    required this.totalIcons,
    required this.activeColor,
    required this.inactiveColor,
    required this.glassColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeApp.s30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: SizeApp.s70,
          padding: EdgeInsets.symmetric(horizontal: SizeApp.s4),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(SizeApp.s30),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(displayIcons.length, (displayIndex) {
              final actualIndex =
              isRTL ? (totalIcons - 1 - displayIndex) : displayIndex;
              final isSelected = currentIndex == actualIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(actualIndex),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: SizeApp.s8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(isSelected ? SizeApp.s8 : 0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? activeColor.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(SizeApp.s12),
                          ),
                          child: CustomIcon(
                            assetPath: displayIcons[displayIndex],
                            size: SizeApp.s24 + SizeApp.s2,
                            color: isSelected ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}