import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/models/appointment_model.dart';
import '../providers/appointments_provider.dart';
import '../../../shared/models/doctor_booking_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppointmentDetailScreen
//
// Shows the full detail of a single appointment. Receives an [id] from the
// router path parameter. Bottom action bar changes based on status.
// ─────────────────────────────────────────────────────────────────────────────

class AppointmentDetailScreen extends ConsumerWidget {
  final String id;
  const AppointmentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asyncAppt = ref.watch(appointmentDetailProvider(id));

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
      body: asyncAppt.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(
          child: Text('Error loading details:\n$err',
            textAlign: TextAlign.center,
            style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
        data: (appt) {
          DateTime? dt;
          try { dt = DateTime.parse(appt.appointmentTime).toLocal(); } catch (_) {}
          final dateStr = dt != null ? DateFormat('EEEE, MMM dd, yyyy').format(dt) : 'TBD';
          final timeStr = dt != null ? DateFormat('hh:mm a').format(dt) : 'TBD';

          final status      = appt.status.value.toString();
          final doctorName  = appt.doctor?.fullName ?? 'Unknown Doctor';
          final specialty   = appt.doctor?.specialty ?? 'Specialist';
          final clinicName  = appt.clinic?.clinicName ?? 'Main Clinic';
          final type        = appt.appointmentType.value.toString();
          final reason      = appt.visitReason ?? 'No reason provided.';

          return SingleChildScrollView(
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: appt.doctor?.avatarUrl != null ? NetworkImage(appt.doctor!.avatarUrl!) : null,
                        backgroundColor: AppColors.primaryFaint,
                        child: appt.doctor?.avatarUrl == null ? const Icon(Icons.person, color: AppColors.primary) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialty,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: status),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Appointment Details card ───────────────────────────────────────
                _SectionCard(
                  isDark: isDark,
                  title: 'Appointment Details',
                  children: [
                    _DetailRow(icon: Icons.calendar_today_rounded,  label: 'Date',    value: dateStr,    isDark: isDark),
                    _DetailRow(icon: Icons.access_time_rounded,     label: 'Time',    value: timeStr,    isDark: isDark),
                    _DetailRow(icon: Icons.location_on_outlined,    label: 'Clinic',  value: clinicName,  isDark: isDark),
                    _DetailRow(
                      icon: Icons.category_outlined,
                      label: 'Type',
                      isDark: isDark,
                      valueWidget: StatusBadge(status: type, compact: true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Visit Reason ──────────────────────────────────────────────────
                if (reason.isNotEmpty)
                  _SectionCard(
                    isDark: isDark,
                    title: 'Reason for Visit',
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          reason,
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
                if (status == 'completed') ...[
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
                      _DetailRow(icon: Icons.medical_information_outlined, label: 'Diagnosis', value: 'Check medical record for details', isDark: isDark),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 80), // space for bottom bar
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: asyncAppt.whenOrNull(
        data: (appt) => _buildBottomBar(context, ref, isDark, appt),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, bool isDark, AppointmentModel appt) {
    final status = appt.status.value.toString();
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
                    onPressed: () => _showCancelDialog(context, ref),
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
                onPressed: () => context.pushNamed(
                  RouteNames.medicalRecordDetail,
                  pathParameters: {'id': id},
                ),
                icon: const Icon(Icons.medical_information_outlined),
                label: const Text('View Medical Record'),
              ),
            ),
          'cancelled' => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (appt.doctor != null) {
                    final doc = appt.doctor!;
                    final doctorModel = DoctorModel(
                      id: doc.id,
                      fullName: doc.fullName,
                      specialty: doc.specialty,
                      professionalTitle: doc.professionalTitle,
                      avatarUrl: doc.avatarUrl,
                      consultationFee: doc.consultationFee,
                      experience: doc.experience,
                      qualifications: doc.qualifications,
                      clinic: doc.clinic ?? appt.clinic,
                    );
                    context.pushNamed(
                      RouteNames.doctorDetails,
                      pathParameters: {'id': doc.id.toString()},
                      extra: doctorModel,
                    );
                  }
                },
                child: const Text('Rebook Appointment'),
              ),
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No, Keep It')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final repo = ref.read(appointmentsRepositoryProvider);
                await repo.cancelAppointment(id);
                ref.invalidate(appointmentDetailProvider(id));
                ref.invalidate(appointmentsProvider);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not cancel: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
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
