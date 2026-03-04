// lib/features/home/presentation/widgets/last_booking_card.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../booking/domain/entities/booking_entity.dart';


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
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(hSize.s12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(hSize.s16),
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
            SizedBox(width: hSize.s12),
            Expanded(child: _ClinicInfo(booking: booking)),
            _QueueBadge(turnNumber: booking.turnNumber ?? 0),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Clinic thumbnail
// ─────────────────────────────────────────────

class _ClinicImage extends StatelessWidget {
  final String imageUrl;

  const _ClinicImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);
    final size = hSize.s50 + hSize.s10;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(hSize.s12),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(hSize.s12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.local_hospital,
            color: theme.primaryColor,
            size: hSize.s32,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Clinic name + location + badge
// ─────────────────────────────────────────────

class _ClinicInfo extends StatelessWidget {
  final BookingEntity booking;

  const _ClinicInfo({required this.booking});

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _LastBookingBadge(),
        SizedBox(height: vSize.s6),
        Text(
          booking.clinical.name,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: vSize.s4),
        _LocationRow(location: booking.clinical.location),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// "آخر حجز" badge
// ─────────────────────────────────────────────

class _LastBookingBadge extends StatelessWidget {
  const _LastBookingBadge();

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final vSize = AppSizeVertical.instance;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: hSize.s8,
            vertical: vSize.s4,
          ),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(hSize.s6),
          ),
          child: Text(
            'home.last_booking.badge'.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        SizedBox(width: hSize.s6),
        Icon(
          Icons.check_circle,
          color: ColorsManager.successFill,
          size: hSize.s14,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Location row
// ─────────────────────────────────────────────

class _LocationRow extends StatelessWidget {
  final String location;

  const _LocationRow({required this.location});

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: hSize.s14,
          color: theme.hintColor,
        ),
        SizedBox(width: hSize.s4),
        Expanded(
          child: Text(
            location,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Turn number badge — always shown
// ─────────────────────────────────────────────

class _QueueBadge extends StatelessWidget {
  final int turnNumber;

  const _QueueBadge({required this.turnNumber});

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final vSize = AppSizeVertical.instance;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hSize.s12,
        vertical: vSize.s8,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(hSize.s12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$turnNumber',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          Text(
            'home.last_booking.queue_position'.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}