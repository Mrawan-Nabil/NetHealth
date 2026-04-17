import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../../appointments/providers/appointments_provider.dart';
import '../../../shared/models/dashboard_model.dart';
import '../../../shared/models/doctor_booking_model.dart';
import '../../../shared/widgets/doctor_avatar.dart';
import '../../../shared/models/enums.dart';
import '../../appointments/ui/doctor_selection_screen.dart';

String _formatDateTime(String isoDate) {
  try {
    final date = DateTime.parse(isoDate).toLocal();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year;
    
    int hour = date.hour;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '$month $day, $year - $hour:$minute $amPm';
  } catch (e) {
    return isoDate;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DashboardScreen
// ─────────────────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user   = ref.watch(authProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstName = (user?.fullName ?? 'Ahmed').split(' ').first;
    
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, stack) => Center(
            child: Text('Failed to load dashboard: $error', style: const TextStyle(color: AppColors.error)),
          ),
          data: (dashboardData) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App Bar ───────────────────────────────────────────────────────
                SliverToBoxAdapter(child: _TopBar(firstName: firstName, isDark: isDark, user: user)),

                // ── Hero Banner ───────────────────────────────────────────────────
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _HeroBanner(isDark: isDark),
                )),

                // ── Stats Row ─────────────────────────────────────────────────────
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _StatsRow(isDark: isDark, stats: dashboardData!.stats),
                )),

                // ── Responsive body ───────────────────────────────────────────────
                SliverToBoxAdapter(child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Wide layout ≥ 720 dp — 2-column side by side
                    if (constraints.maxWidth >= 720) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _LeftColumn(isDark: isDark, data: dashboardData)),
                            const SizedBox(width: 16),
                            Expanded(child: _RightColumn(isDark: isDark, data: dashboardData)),
                          ],
                        ),
                      );
                    }
                    // Mobile layout — single column
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _LeftColumn(isDark: isDark, data: dashboardData),
                          const SizedBox(height: 20),
                          _RightColumn(isDark: isDark, data: dashboardData),
                          const SizedBox(height: 32),
                        ],
                      ),
                    );
                  },
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String firstName;
  final bool isDark;
  final dynamic user;

  const _TopBar({required this.firstName, required this.isDark, required this.user});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _greetingEmoji() {
    final h = DateTime.now().hour;
    if (h < 12) return '☀️';
    if (h < 17) return '👋';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => context.goNamed(RouteNames.profile),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryFaint,
              backgroundImage: user?.avatar != null ? NetworkImage(user!.avatar!) : null,
              child: user?.avatar == null
                  ? Text(
                      user?.initials ?? 'A',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_greeting()}, $firstName ${_greetingEmoji()}',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          // Notifications bell
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 26,
                ),
                onPressed: () => context.pushNamed(RouteNames.notifications),
              ),
              // Unread dot
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Banner — "Book a New Appointment"
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final bool isDark;
  const _HeroBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background wave decoration
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 110,
            top: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Book a New\nAppointment',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DoctorSelectionScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Book Now →',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Medical cross icon on right
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                Icons.local_hospital_rounded,
                size: 72,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final bool isDark;
  final DashboardStats stats;
  const _StatsRow({required this.isDark, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            isDark: isDark,
            count: stats.upcomingAppointments.toString(),
            label: 'Upcoming\nAppointments',
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryFaint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            isDark: isDark,
            count: stats.activePrescriptions.toString(),
            label: 'Active\nPrescriptions',
            icon: Icons.medication_rounded,
            iconColor: AppColors.warning,
            iconBg: AppColors.warningFaint,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            isDark: isDark,
            count: stats.pendingTests.toString(),
            label: 'Pending\nTest Results',
            icon: Icons.science_rounded,
            iconColor: AppColors.info,
            iconBg: AppColors.infoFaint,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final String count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.isDark,
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.7),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              height: 1.3,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Left Column — Next Appointment + Recent Records
// ─────────────────────────────────────────────────────────────────────────────

class _LeftColumn extends StatelessWidget {
  final bool isDark;
  final DashboardModel data;
  const _LeftColumn({required this.isDark, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NextAppointmentCard(isDark: isDark),
        const SizedBox(height: 20),
        _RecentRecordsSection(isDark: isDark, records: data.recentRecords),
      ],
    );
  }
}

class _NextAppointmentCard extends ConsumerWidget {
  final bool isDark;
  const _NextAppointmentCard({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Next Appointment',
          actionLabel: 'See All',
          isDark: isDark,
          onAction: () => context.goNamed(RouteNames.appointments),
        ),
        const SizedBox(height: 12),
        appointmentsAsync.when(
          loading: () => _LoadingPlaceholder(isDark: isDark),
          error: (err, stack) => _ErrorPlaceholder(isDark: isDark, message: err.toString()),
          data: (appointments) {
            final now = DateTime.now();
            final upcoming = appointments.where((a) {
              try {
                final dt = DateTime.parse(a.appointmentTime);
                return dt.isAfter(now) && a.status == AppointmentStatus.scheduled;
              } catch (_) {
                return false;
              }
            }).toList();

            if (upcoming.isEmpty) {
              return _EmptyNextPlaceholder(isDark: isDark);
            }

            // Sort ascending to get the closest one
            upcoming.sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));
            final appointment = upcoming.first;

            // Map DoctorSummaryModel to DoctorModel for the avatar
            final doctorModel = DoctorModel(
              id: appointment.doctor?.id ?? 0,
              fullName: appointment.doctor?.fullName ?? 'Unknown Doctor',
              specialty: appointment.doctor?.specialty ?? 'General',
              professionalTitle: appointment.doctor?.professionalTitle ?? ProfessionalTitle.specialist,
              avatarUrl: appointment.doctor?.avatarUrl,
            );

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.25),
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                children: [
                  // Doctor row
                  Row(
                    children: [
                      DoctorAvatar(doctor: doctorModel, radius: 26),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorModel.fullName,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doctorModel.specialty,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: appointment.status.value.toString()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  const SizedBox(height: 14),

                  // Details row
                  Row(
                    children: [
                      _AppointInfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: _formatDateTime(appointment.appointmentTime),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _AppointInfoChip(
                    icon: Icons.location_on_outlined,
                    label: appointment.clinic?.clinicName ?? 'Main Clinic',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (appointment.doctor != null) {
                              context.pushNamed(
                                RouteNames.doctorDetails,
                                pathParameters: {'id': doctorModel.id.toString()},
                                extra: doctorModel,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Doctor details not available.')),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          child: const Text('Reschedule'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.pushNamed(
                            RouteNames.appointmentDetail,
                            pathParameters: {'id': appointment.id.toString()},
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          child: const Text('View Details'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyNextPlaceholder extends StatelessWidget {
  final bool isDark;
  const _EmptyNextPlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.7),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.event_available_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            'No upcoming appointments',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You\'re all caught up with your schedule!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final bool isDark;
  const _LoadingPlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final bool isDark;
  final String message;
  const _ErrorPlaceholder({required this.isDark, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorFaint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 32),
          const SizedBox(height: 12),
          Text(
            'Failed to load appointment',
            style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.error),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? Colors.white70 : AppColors.error.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AppointInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _AppointInfoChip({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _RecentRecordsSection extends StatelessWidget {
  final bool isDark;
  final List<dynamic> records;
  const _RecentRecordsSection({required this.isDark, required this.records});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Recent Medical Records',
          actionLabel: 'View Full Records',
          isDark: isDark,
          onAction: () => context.goNamed(RouteNames.records),
        ),
        const SizedBox(height: 12),
        if (records.isEmpty) 
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.7),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(Icons.folder_open_rounded, size: 48, color: AppColors.info.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                Text(
                  'No recent records',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your recent health records will appear here.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.7),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              children: records.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _RecordTile(
                      item: _RecordItem(
                        icon: Icons.local_hospital_rounded,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.primaryFaint,
                        title: 'Medical Record #${item.appointmentId}',
                        doctor: item.doctorFullName,
                        date: _formatDateTime(item.appointmentTime),
                        status: item.status,
                      ),
                      isDark: isDark
                    ),
                    if (i < records.length - 1)
                      Divider(
                        height: 1,
                        indent: 64,
                        color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  final _RecordItem item;
  final bool isDark;

  const _RecordTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: item.iconBg, shape: BoxShape.circle),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.doctor}  •  ${item.date}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusBadge(status: item.status, compact: true),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Right Column — Health Overview + Recent Activity
// ─────────────────────────────────────────────────────────────────────────────

class _RightColumn extends StatelessWidget {
  final bool isDark;
  final DashboardModel data;
  const _RightColumn({required this.isDark, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HealthOverviewCard(isDark: isDark, healthOverview: data.healthOverview),
        const SizedBox(height: 20),
        _RecentActivitySection(isDark: isDark),
      ],
    );
  }
}

class _HealthOverviewCard extends StatelessWidget {
  final bool isDark;
  final HealthOverview healthOverview;
  const _HealthOverviewCard({required this.isDark, required this.healthOverview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Health Overview',
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.7),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health pills grid
              Row(
                children: [
                  Expanded(
                    child: _HealthPill(
                      label: 'Blood Type',
                      value: healthOverview.bloodType?.label ?? 'Unknown',
                      icon: Icons.water_drop_rounded,
                      color: AppColors.error,
                      bg: AppColors.errorFaint,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HealthPill(
                      label: 'Allergies',
                      value: '${healthOverview.allergies.length} Known',
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      bg: AppColors.warningFaint,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _HealthPill(
                label: 'Chronic Conditions',
                value: healthOverview.chronicConditions ?? 'None',
                icon: Icons.favorite_border_rounded,
                color: AppColors.info,
                bg: AppColors.infoFaint,
                isDark: isDark,
                fullWidth: true,
              ),
              const SizedBox(height: 16),

              Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
              const SizedBox(height: 14),

              // Primary Doctor
              Text(
                'Primary Doctor',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              if (healthOverview.primaryDoctor == null)
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryFaint,
                      child: Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No Primary Doctor',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const Text(
                            'Tap to assign one',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: healthOverview.primaryDoctor?.avatarUrl != null 
                          ? NetworkImage(healthOverview.primaryDoctor!.avatarUrl!)
                          : const NetworkImage('https://i.pravatar.cc/150?img=5'),
                      backgroundColor: AppColors.primaryFaint,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            healthOverview.primaryDoctor!.fullName,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            healthOverview.primaryDoctor!.specialty,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFaint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HealthPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;
  final bool isDark;
  final bool fullWidth;

  const _HealthPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
    required this.isDark,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : bg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  final bool isDark;
  const _RecentActivitySection({required this.isDark});

  static const _activities = [
    _ActivityItem(
      dot: AppColors.primary,
      title: 'Appointment Confirmed',
      subtitle: 'Dr. Sarah Johnson — Feb 27',
      time: '2 min ago',
    ),
    _ActivityItem(
      dot: AppColors.warning,
      title: 'Test Result Uploaded',
      subtitle: 'Full Blood Count (FBC)',
      time: '1 hour ago',
    ),
    _ActivityItem(
      dot: AppColors.statusDispensed,
      title: 'Prescription Issued',
      subtitle: 'Amoxicillin 500mg  ×  7 days',
      time: 'Yesterday',
    ),
    _ActivityItem(
      dot: AppColors.info,
      title: 'Imaging Report Ready',
      subtitle: 'Chest X-Ray — City Heart Institute',
      time: '3 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Recent Activity', isDark: isDark),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.7),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: _activities.asMap().entries.map((entry) {
              final i    = entry.key;
              final item = entry.value;
              return _ActivityTile(
                item: item,
                isDark: isDark,
                isLast: i == _activities.length - 1,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;
  final bool isDark;
  final bool isLast;

  const _ActivityTile({required this.item, required this.isDark, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: item.dot, shape: BoxShape.circle),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.time,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final bool isDark;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data models (private, immutable)
// ─────────────────────────────────────────────────────────────────────────────

class _RecordItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String doctor;
  final String date;
  final String status;

  const _RecordItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.doctor,
    required this.date,
    required this.status,
  });
}

class _ActivityItem {
  final Color dot;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.dot,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
