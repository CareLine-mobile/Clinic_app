import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showArrow;
  final Color? iconColor;
  final Color? iconBgColor;

  const SettingsItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.showArrow = true,
    this.iconColor,
    this.iconBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = AppSizeVertical.instance;
    final h = AppSizeHorizontal.instance;
    final t = TextSizeApp.instance;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: h.s16,
            vertical: v.s12,
          ),
          child: Row(
            children: [
              // ─── Icon ──────────────────────────────────────────
              Container(
                width: h.s40,
                height: h.s40,
                decoration: BoxDecoration(
                  color: iconBgColor ??
                      (iconColor ?? ColorsManager.primaryColor)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: t.s18,
                  color: iconColor ?? ColorsManager.primaryColor,
                ),
              ),
              SizedBox(width: h.s12),

              // ─── Text ──────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: v.s2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Trailing ──────────────────────────────────────
              if (trailing != null)
                trailing!
              else if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.hintColor.withOpacity(0.4),
                  size: TextSizeApp.instance.s20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}