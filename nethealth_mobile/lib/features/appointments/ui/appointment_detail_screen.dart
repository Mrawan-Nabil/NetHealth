import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppointmentDetailScreen
//
// Shows the full detail of a single appointment. Receives an [id] from the
// router path parameter. Bottom action bar changes based on mock status.
// ─────────────────────────────────────────────────────────────────────────────

class AppointmentDetailScreen extends StatelessWidget {
  final String id;
  const AppointmentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Mock data (will be replaced by API model in Phase 2) ──────────────────
    const mockStatus      = 'scheduled';
    const mockDoctor      = 'Dr. Ayman Fathy';
    const mockSpecialty   = 'Cardiology Specialist';
    const mockClinic      = 'City Heart Institute, Floor 3';
    const mockDate        = 'Wednesday, Feb 27, 2025';
    const mockTime        = '11:00 AM';
    const mockType        = 'physical';
    const mockReason      = 'Chest pain and occasional shortness of breath during moderate physical activity.';

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Appointment #$id',
          style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status banner ─────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                    backgroundColor: AppColors.primaryFaint,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mockDoctor,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          mockSpecialty,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: mockStatus),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Appointment Details card ───────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              title: 'Appointment Details',
              children: [
                _DetailRow(icon: Icons.calendar_today_rounded,  label: 'Date',    value: mockDate,    isDark: isDark),
                _DetailRow(icon: Icons.access_time_rounded,     label: 'Time',    value: mockTime,    isDark: isDark),
                _DetailRow(icon: Icons.location_on_outlined,    label: 'Clinic',  value: mockClinic,  isDark: isDark),
                _DetailRow(
                  icon: Icons.category_outlined,
                  label: 'Type',
                  isDark: isDark,
                  valueWidget: const StatusBadge(status: mockType, compact: true),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Visit Reason ──────────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              title: 'Reason for Visit',
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    mockReason,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Linked Medical Record (only for completed) ─────────────────────
            if (mockStatus == 'completed') ...[
              _SectionCard(
                isDark: isDark,
                title: 'Medical Record',
                trailing: TextButton(
                  onPressed: () => context.pushNamed(
                    RouteNames.medicalRecordDetail,
                    pathParameters: {'id': id},
                  ),
                  child: const Text('View Record'),
                ),
                children: [
                  _DetailRow(icon: Icons.medical_information_outlined, label: 'Diagnosis', value: 'Upper Respiratory Tract Infection', isDark: isDark),
                  _DetailRow(icon: Icons.medication_outlined, label: 'Prescriptions', value: '2 medications issued', isDark: isDark),
                ],
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 80), // space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, isDark, mockStatus),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDark, String status) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: switch (status) {
          'scheduled' => Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Reschedule'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showCancelDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          'completed' => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.medical_information_outlined),
                label: const Text('View Medical Record'),
              ),
            ),
          'cancelled' => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Rebook Appointment'),
              ),
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No, Keep It')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const _SectionCard({
    required this.isDark,
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool isDark;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.isDark,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
              ),
            ),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value ?? '—',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
