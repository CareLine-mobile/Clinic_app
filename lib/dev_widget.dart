// lib/core/widgets/dev_tools_overlay.dart
//
// Wrap your MaterialApp's `home` or any top-level widget with this overlay
// during development. It renders two draggable FABs:
//   🌙 / ☀️  → toggles dark / light theme via SettingsCubit
//   AR / EN  → toggles Arabic / English via SettingsCubit + EasyLocalization
//
// Usage – see bottom of this file or the main.dart snippet.
// Remove (or set kDebugOnly = true) before production release.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// your existing AppTheme
import '../../features/settings/presentation/cubit/settings_cubit.dart';

/// Set to `false` to hide the overlay even in debug builds.
const bool _kShowDevTools = true;

class DevToolsOverlay extends StatefulWidget {
  final Widget child;

  const DevToolsOverlay({Key? key, required this.child}) : super(key: key);

  @override
  State<DevToolsOverlay> createState() => _DevToolsOverlayState();
}

class _DevToolsOverlayState extends State<DevToolsOverlay> {
  // Starting position (bottom-left area)
  Offset _position = const Offset(16, 120);

  @override
  Widget build(BuildContext context) {
    // In release builds or when disabled, just return the child as-is.
    if (!_kShowDevTools) return widget.child;

    return Stack(
      children: [
        widget.child,

        // ── Draggable panel ──────────────────────────────────────────────
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _position = Offset(
                  (_position.dx + details.delta.dx)
                      .clamp(0, MediaQuery.of(context).size.width - 80),
                  (_position.dy + details.delta.dy)
                      .clamp(0, MediaQuery.of(context).size.height - 120),
                );
              });
            },
            child: _DevPanel(),
          ),
        ),
      ],
    );
  }
}

// ── The actual panel widget ───────────────────────────────────────────────
class _DevPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        final isAr = state.locale.languageCode == 'ar';

        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey[850]!.withOpacity(0.92)
                  : Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── drag handle ──────────────────────────────────────
                Icon(
                  Icons.drag_indicator,
                  size: 18,
                  color: isDark ? Colors.white38 : Colors.black26,
                ),
                const SizedBox(width: 4),

                // ── Theme toggle ─────────────────────────────────────
                _PillButton(
                  icon:
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  label: isDark ? 'Light' : 'Dark',
                  color: isDark ? Colors.amber : Colors.indigo,
                  onTap: () {
                    context.read<SettingsCubit>().toggleTheme();
                  },
                ),

                const SizedBox(width: 6),

                // ── Language toggle ──────────────────────────────────
                _PillButton(
                  icon: Icons.translate_rounded,
                  label: isAr ? 'EN' : 'AR',
                  color: Colors.teal,
                  onTap: () {
                    // Correct signature: changeLanguage(BuildContext, String)
                    final nextCode = isAr ? 'en' : 'ar';
                    context
                        .read<SettingsCubit>()
                        .changeLanguage(context, nextCode);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Small reusable pill button ────────────────────────────────────────────
class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// HOW TO WIRE IT IN main.dart
// ─────────────────────────────────────────────────────────────────────────
//
// Inside your MaterialApp builder, wrap the navigator's first route OR
// set `builder:` on MaterialApp like this:
//
//   MaterialApp(
//     ...
//     builder: (context, child) => DevToolsOverlay(child: child!),
//   )
//
// That single line puts the overlay on EVERY screen automatically.
// ─────────────────────────────────────────────────────────────────────────
