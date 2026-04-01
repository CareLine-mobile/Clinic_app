
import 'package:flutter/material.dart';

class LocationBanner extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const LocationBanner({
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF59E0B), // amber-500 — visible, not garish
        padding: EdgeInsets.only(
          top: topPadding + 10,
          bottom: 10,
          left: 16,
          right: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            const Icon(
              Icons.location_off_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),

            // Message — expands to fill available space
            Expanded(
              child: Text(
                'خدمة الموقع معطّلة. اضغط هنا لتفعيلها',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),

            // Divider
            Container(
              width: 1,
              height: 20,
              color: Colors.white.withOpacity(0.4),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),

            // Dismiss button — separate tap area, doesn't trigger onTap
            GestureDetector(
              onTap: onDismiss,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
