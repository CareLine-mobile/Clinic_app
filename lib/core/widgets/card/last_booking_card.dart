// lib/features/home/presentation/widgets/last_booking_card.dart

import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return _TooltipCard(
      booking: booking,
      child: GestureDetector(
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
              _StatusBadge(booking: booking),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tooltip wrapper — long press shows contextual tip ───────────────────────

class _TooltipCard extends StatefulWidget {
  final BookingEntity booking;
  final Widget child;

  const _TooltipCard({required this.booking, required this.child});

  @override
  State<_TooltipCard> createState() => _TooltipCardState();
}

class _TooltipCardState extends State<_TooltipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  ({String title, String body, IconData icon, Color color}) _getTip() {
    return switch (widget.booking.status) {
      'pending' => (
      title: 'home.last_booking.tip.pending_title'.tr(),
      body: 'home.last_booking.tip.pending_body'.tr(),
      icon: Icons.hourglass_empty_rounded,
      color: const Color(0xFFE65100),
      ),
      'confirmed' when (widget.booking.waitTurns ?? 99) == 0 => (
      title: 'home.last_booking.tip.your_turn_title'.tr(),
      body: 'home.last_booking.tip.your_turn_body'.tr(),
      icon: Icons.notifications_active_rounded,
      color: ColorsManager.successFill,
      ),
      'confirmed' when (widget.booking.waitTurns ?? 99) <= 3 => (
      title: 'home.last_booking.tip.almost_title'.tr(),
      body: 'home.last_booking.tip.almost_body'.tr(
        namedArgs: {'count': '${widget.booking.waitTurns ?? 0}'},
      ),
      icon: Icons.timer_rounded,
      color: ColorsManager.warningFill,
      ),
      'confirmed' => (
      title: 'home.last_booking.tip.confirmed_title'.tr(),
      body: 'home.last_booking.tip.confirmed_body'.tr(
        namedArgs: {'count': '${widget.booking.waitTurns ?? 0}'},
      ),
      icon: Icons.check_circle_outline_rounded,
      color: ColorsManager.infoFill,
      ),
      'cancelled' => (
      title: 'home.last_booking.tip.cancelled_title'.tr(),
      body: 'home.last_booking.tip.cancelled_body'.tr(),
      icon: Icons.cancel_outlined,
      color: ColorsManager.errorFill,
      ),
      'in-doctor' => (
      title: 'home.last_booking.tip.in_doctor_title'.tr(),
      body: 'home.last_booking.tip.in_doctor_body'.tr(),
      icon: Icons.medical_services_rounded,
      color: ColorsManager.infoFill,
      ),
      'completed' => (
      title: 'home.last_booking.tip.completed_title'.tr(),
      body: 'home.last_booking.tip.completed_body'.tr(),
      icon: Icons.star_outline_rounded,
      color: ColorsManager.successFill,
      ),
      _ => (
      title: 'home.last_booking.tip.pending_title'.tr(),
      body: 'home.last_booking.tip.pending_body'.tr(),
      icon: Icons.info_outline_rounded,
      color: ColorsManager.infoFill,
      ),
    };
  }

  void _showTooltip() {
    HapticFeedback.mediumImpact();

    final tip = _getTip();
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.15)),
            ),
            Positioned(
              top: offset.dy + size.height + 8,
              left: 16,
              right: 16,
              child: ScaleTransition(
                scale: _scaleAnim,
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tip.color.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: tip.color.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tip.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(tip.icon, color: tip.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: tip.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tip.body,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: Theme.of(context).hintColor,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'home.last_booking.tip.dismiss'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
    Future.delayed(const Duration(seconds: 4), _removeOverlay);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _controller.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _showTooltip,
      child: widget.child,
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final BookingEntity booking;
  const _StatusBadge({required this.booking});

  @override
  Widget build(BuildContext context) {
    if (booking.isConfirmed) {
      return _QueueBadge(
        turnNumber: booking.turnNumber,
        waitTurns: booking.waitTurns,
      );
    }
    if (booking.isPending) return _PendingBadge();
    return _SimpleBadge(status: booking.status);
  }
}

// ─── Queue Badge ──────────────────────────────────────────────────────────────

class _QueueBadge extends StatelessWidget {
  final int? turnNumber;
  final int? waitTurns;
  const _QueueBadge({required this.turnNumber, this.waitTurns});

  (Color, Color) _resolveColors() => switch (waitTurns) {
    0 => (ColorsManager.successSurface, ColorsManager.successFill),
    null => (ColorsManager.infoSurface, ColorsManager.infoFill),
    <= 3 => (ColorsManager.warningSurface, ColorsManager.warningFill),
    _ => (ColorsManager.infoSurface, ColorsManager.infoFill),
  };

  @override
  Widget build(BuildContext context) {
    final h = AppSizeHorizontal.instance;
    final v = AppSizeVertical.instance;
    final theme = Theme.of(context);
    final (bg, accent) = _resolveColors();

    // ✅ It's your turn — no one ahead, no turn number needed
    final isYourTurn = waitTurns == 0;

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
          // ✅ Only show turn number when it's NOT your turn yet
          if (!isYourTurn && turnNumber != null) ...[
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
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: accent.withOpacity(0.7)),
            ),
            SizedBox(height: v.s4),
          ],
          if (waitTurns != null)
            Text(
              isYourTurn
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
          Icon(Icons.hourglass_empty_rounded,
              color: const Color(0xFFE65100), size: h.s20),
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

// ─── Simple Badge ─────────────────────────────────────────────────────────────

class _SimpleBadge extends StatelessWidget {
  final String status;
  const _SimpleBadge({required this.status});

  (Color, Color, IconData) _config() => switch (status) {
    'cancelled' => (
    ColorsManager.errorSurface,
    ColorsManager.errorFill,
    Icons.cancel_outlined,
    ),
    'in-doctor' => (
    ColorsManager.infoSurface,
    ColorsManager.infoFill,
    Icons.medical_services_rounded,
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
            color: theme.primaryColor.withOpacity(0.3), width: 2),
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
        Text(
          booking.clinical.name,
          style:
          theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: v.s4),
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