import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/doctor_booking_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DoctorAvatar
//
// Displays a doctor's photo when available, falling back to a coloured circle
// with initials.  Initials are derived from [DoctorModel.initials] which
// strips common honorifics and is guaranteed never to crash.
// ─────────────────────────────────────────────────────────────────────────────

/// Deterministically picks a background colour from a small palette
/// based on the doctor's id, so each doctor consistently gets the same colour.
Color _avatarBg(int doctorId) {
  const palette = [
    Color(0xFF4A6CF7), // indigo
    Color(0xFF10B981), // emerald
    Color(0xFFF59E0B), // amber
    Color(0xFFEF4444), // red
    Color(0xFF8B5CF6), // violet
    Color(0xFF06B6D4), // cyan
    Color(0xFFF97316), // orange
    Color(0xFF84CC16), // lime
  ];
  return palette[doctorId.abs() % palette.length];
}

class DoctorAvatar extends StatelessWidget {
  final DoctorModel doctor;
  final double radius;

  const DoctorAvatar({
    super.key,
    required this.doctor,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final bg       = _avatarBg(doctor.id);
    final initials = doctor.initials;

    if (doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: doctor.avatarUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (_, __) => _InitialsCircle(initials: initials, bg: bg, radius: radius),
            errorWidget: (_, __, ___) => _InitialsCircle(initials: initials, bg: bg, radius: radius),
          ),
        ),
      );
    }

    return _InitialsCircle(initials: initials, bg: bg, radius: radius);
  }
}

class _InitialsCircle extends StatelessWidget {
  final String initials;
  final Color bg;
  final double radius;

  const _InitialsCircle({
    required this.initials,
    required this.bg,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.55,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Outfit',
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
