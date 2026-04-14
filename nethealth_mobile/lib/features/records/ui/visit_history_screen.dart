import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  static const _visits = [
    _Visit(id: '1', date: 'Oct 15, 2025', doctor: 'Dr. Sara Ahmed',   specialty: 'General Practitioner', clinic: 'City General Hospital',     status: 'completed', type: 'physical'),
    _Visit(id: '2', date: 'Sep 28, 2025', doctor: 'Dr. Ayman Fathy',  specialty: 'Cardiologist',          clinic: 'City Heart Institute',       status: 'completed', type: 'physical'),
    _Visit(id: '3', date: 'Aug 10, 2025', doctor: 'Dr. Nadia Karim',  specialty: 'Dermatologist',         clinic: 'Nile Skin Clinic',           status: 'completed', type: 'remote'),
    _Visit(id: '4', date: 'Jun 22, 2025', doctor: 'Dr. Ayman Fathy',  specialty: 'Cardiologist',          clinic: 'City Heart Institute',       status: 'cancelled', type: 'physical'),
    _Visit(id: '5', date: 'Apr 05, 2025', doctor: 'Dr. Ali Hassan',   specialty: 'Neurologist',           clinic: 'NeuroMed Institute',         status: 'completed', type: 'emergency'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Visit History', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _visits.length,
        itemBuilder: (context, index) {
          final visit = _visits[index];
          return _VisitCard(visit: visit, isDark: isDark);
        },
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final _Visit visit;
  final bool isDark;

  const _VisitCard({required this.visit, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.appointmentDetail,
        pathParameters: {'id': visit.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date row ────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                    const SizedBox(width: 6),
                    Text(
                      visit.date,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: visit.status, compact: true),
              ],
            ),
            const SizedBox(height: 10),

            // ── Doctor ───────────────────────────────────────────────────────
            Text(
              visit.doctor,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              visit.specialty,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 10),

            Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            const SizedBox(height: 8),

            // ── Clinic + Type ─────────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    visit.clinic,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: visit.type, compact: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mock data model ───────────────────────────────────────────────────────────
class _Visit {
  final String id;
  final String date;
  final String doctor;
  final String specialty;
  final String clinic;
  final String status;
  final String type;

  const _Visit({
    required this.id,
    required this.date,
    required this.doctor,
    required this.specialty,
    required this.clinic,
    required this.status,
    required this.type,
  });
}
