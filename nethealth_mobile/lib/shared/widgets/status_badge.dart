import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StatusBadge
//
// A single pill widget that maps a raw string status value to the correct
// brand colors from AppColors. Pass any status string from the API enum
// (case-insensitive) and it will render the right badge.
//
// Usage:
//   StatusBadge(status: 'completed')
//   StatusBadge(status: 'scheduled', compact: true)
// ─────────────────────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String status;

  /// [compact] reduces horizontal padding and font size — good for tight cards.
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _resolve(status.toLowerCase().trim());

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical:   compact ? 3  : 5,
      ),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize:     compact ? 10 : 11,
          fontWeight:   FontWeight.w700,
          color:        fg,
          letterSpacing: 0.5,
          height:       1.2,
        ),
      ),
    );
  }

  // ── Colour resolution ──────────────────────────────────────────────────────
  /// Returns (background, foreground, displayLabel) for the given status key.
  static (Color, Color, String) _resolve(String s) => switch (s) {
    // ── Appointment Status ──────────────────────────────────────────────────
    'completed'   => (AppColors.successFaint,                   AppColors.statusCompleted,  'COMPLETED'),
    'scheduled'   => (AppColors.infoFaint,                      AppColors.statusScheduled,  'SCHEDULED'),
    'cancelled'   => (AppColors.errorFaint,                     AppColors.statusCancelled,  'CANCELLED'),

    // ── Prescription Status ─────────────────────────────────────────────────
    'active'      => (AppColors.successFaint,                   AppColors.statusCompleted,  'ACTIVE'),
    'expired'     => (const Color(0xFFF1F5F9),                  const Color(0xFF94A3B8),    'EXPIRED'),
    'issued'      => (const Color(0xFFCCFBF1),                  AppColors.statusIssued,     'ISSUED'),
    'dispensed'   => (const Color(0xFFEDE9FE),                  AppColors.statusDispensed,  'DISPENSED'),

    // ── Test Result Status ──────────────────────────────────────────────────
    'pending'     => (AppColors.warningFaint,                   AppColors.statusPending,    'PENDING'),
    'reviewed'    => (AppColors.successFaint,                   AppColors.statusCompleted,  'REVIEWED'),

    // ── Appointment Type ────────────────────────────────────────────────────
    'physical'    => (AppColors.primaryFaint,                   AppColors.primary,          'PHYSICAL'),
    'remote'      => (AppColors.infoFaint,                      AppColors.statusScheduled,  'REMOTE'),
    'emergency'   => (AppColors.errorFaint,                     AppColors.statusCancelled,  'EMERGENCY'),

    // ── Fallback — render the raw string uppercased in a neutral pill ───────
    _             => (const Color(0xFFF1F5F9), const Color(0xFF64748B), s.toUpperCase()),
  };
}
