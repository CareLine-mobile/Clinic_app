// lib/features/home/presentation/widgets/last_booking_card.dart

import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_size.dart';

class LastBookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onTap;

  const LastBookingCard({
    Key? key,
    required this.booking,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(h.s12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(h.s16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _ClinicImage(imageUrl: booking.clinical.thumbnailUrl ?? ''),
            SizedBox(width: h.s12),
            Expanded(child: _ClinicInfo(booking: booking)),
            // ─── Show badge based on status ───────────────────────
            _StatusBadge(booking: booking),
          ],
        ),
      ),
    );
  }
}

// ─── Status Badge — handles all statuses ─────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final BookingEntity booking;
  const _StatusBadge({required this.booking});

  @override
  Widget build(BuildContext context) {
    // ─── Confirmed → show queue info ─────────────────────────────
    if (booking.isConfirmed) {
      return _QueueBadge(
        turnNumber: booking.turnNumber,
        waitTurns: booking.waitTurns,
      );
    }

    // ─── Pending → show pending pill ─────────────────────────────
    if (booking.isPending) {
      return _PendingBadge();
    }

    // ─── Cancelled / Completed → status pill ─────────────────────
    return _SimpleBadge(status: booking.status);
  }
}

// ─── Queue Badge — only for confirmed ────────────────────────────────────────

class _QueueBadge extends StatelessWidget {
  final int? turnNumber;
  final int? waitTurns;

  const _QueueBadge({
    required this.turnNumber,
    this.waitTurns,
  });

  (Color, Color) _resolveColors() => switch (waitTurns) {
    0     => (ColorsManager.successSurface, ColorsManager.successFill),
    null  => (ColorsManager.infoSurface,    ColorsManager.infoFill),
    <= 3  => (ColorsManager.warningSurface, ColorsManager.warningFill),
    _     => (ColorsManager.infoSurface,    ColorsManager.infoFill),
  };

  @override
  Widget build(BuildContext context) {
    final h = AppSizeHorizontal.instance;
    final v = AppSizeVertical.instance;
    final theme = Theme.of(context);
    final (bg, accent) = _resolveColors();

    return Container(
      constraints: BoxConstraints(minWidth: h.s60),
      padding: EdgeInsets.symmetric(horizontal: h.s12, vertical: v.s10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(h.s14),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Turn number ─────────────────────────────────────────
          if (turnNumber != null && waitTurns != 0) ...[
            Text(
              '$turnNumber',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: accent,
                height: 1.1,
              ),
            ),
            SizedBox(height: v.s2),
            Text(
              'home.last_booking.queue_position'.tr(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: accent.withOpacity(0.7),
              ),
            ),
          ],

          // ─── People ahead / Your turn ─────────────────────────────
          if (waitTurns != null)
            Text(
              waitTurns == 0
                  ? 'home.last_booking.your_turn'.tr()
                  : 'home.last_booking.people_ahead'
                  .tr(namedArgs: {'count': waitTurns.toString()}),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: accent,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

// ─── Pending Badge ────────────────────────────────────────────────────────────

class _PendingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = AppSizeHorizontal.instance;
    final v = AppSizeVertical.instance;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: h.s10, vertical: v.s8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(h.s12),
        border: Border.all(color: const Color(0xFFE65100).withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            color: const Color(0xFFE65100),
            size: h.s20,
          ),
          SizedBox(height: v.s4),
          Text(
            'bookings.status.pending'.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFE65100),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Simple Badge — cancelled / completed ────────────────────────────────────

class _SimpleBadge extends StatelessWidget {
  final String status;
  const _SimpleBadge({required this.status});

  (Color, Color, IconData) _config() => switch (status) {
    'cancelled' => (
    ColorsManager.errorSurface,
    ColorsManager.errorFill,
    Icons.cancel_outlined,
    ),
    'completed' => (
    ColorsManager.successSurface,
    ColorsManager.successFill,
    Icons.check_circle_outline_rounded,
    ),
    _ => (
    ColorsManager.infoSurface,
    ColorsManager.infoFill,
    Icons.info_outline_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final h = AppSizeHorizontal.instance;
    final v = AppSizeVertical.instance;
    final theme = Theme.of(context);
    final (bg, color, icon) = _config();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: h.s10, vertical: v.s8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(h.s12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: h.s20),
          SizedBox(height: v.s4),
          Text(
            'bookings.status.$status'.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Clinic Image ─────────────────────────────────────────────────────────────

class _ClinicImage extends StatelessWidget {
  final String imageUrl;
  const _ClinicImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final h = AppSizeHorizontal.instance;
    final theme = Theme.of(context);
    final size = h.s50 + h.s10;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(h.s12),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(h.s12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.local_hospital,
            color: theme.primaryColor,
            size: h.s32,
          ),
        ),
      ),
    );
  }
}

// ─── Clinic Info ──────────────────────────────────────────────────────────────

class _ClinicInfo extends StatelessWidget {
  final BookingEntity booking;
  const _ClinicInfo({required this.booking});

  @override
  Widget build(BuildContext context) {
    final v = AppSizeVertical.instance;
    final h = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── Badge ─────────────────────────────────────────────
        Container(
          padding: EdgeInsets.symmetric(horizontal: h.s8, vertical: v.s4),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(h.s6),
          ),
          child: Text(
            'home.last_booking.badge'.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        SizedBox(height: v.s6),

        // ─── Name ──────────────────────────────────────────────
        Text(
          booking.clinical.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: v.s4),

        // ─── Location ──────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                size: h.s14, color: theme.hintColor),
            SizedBox(width: h.s4),
            Expanded(
              child: Text(
                booking.clinical.location,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}