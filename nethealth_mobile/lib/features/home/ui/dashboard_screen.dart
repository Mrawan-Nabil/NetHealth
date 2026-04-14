import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/providers/auth_provider.dart';

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

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
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
              child: _StatsRow(isDark: isDark),
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
                        Expanded(child: _LeftColumn(isDark: isDark)),
                        const SizedBox(width: 16),
                        Expanded(child: _RightColumn(isDark: isDark)),
                      ],
                    ),
                  );
                }
                // Mobile layout — single column
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _LeftColumn(isDark: isDark),
                      const SizedBox(height: 20),
                      _RightColumn(isDark: isDark),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            )),
          ],
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
                  onTap: () => context.pushNamed(RouteNames.findSpecialist),
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
  const _StatsRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            isDark: isDark,
            count: '3',
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
            count: '1',
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
            count: '2',
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
  const _LeftColumn({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NextAppointmentCard(isDark: isDark),
        const SizedBox(height: 20),
        _RecentRecordsSection(isDark: isDark),
      ],
    );
  }
}

class _NextAppointmentCard extends StatelessWidget {
  final bool isDark;
  const _NextAppointmentCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
        Container(
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
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                    backgroundColor: AppColors.primaryFaint,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Sarah Johnson',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cardiologist',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StatusBadge(status: 'scheduled'),
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
                    label: 'Feb 27, 2025',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _AppointInfoChip(
                    icon: Icons.access_time_rounded,
                    label: '11:00 AM',
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _AppointInfoChip(
                icon: Icons.location_on_outlined,
                label: 'City Heart Institute, Floor 3',
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pushNamed(
                        RouteNames.doctorDetails,
                        pathParameters: {'id': '1'},
                      ),
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
                        pathParameters: {'id': '1'},
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
        ),
      ],
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
  const _RecentRecordsSection({required this.isDark});

  static const _items = [
    _RecordItem(
      icon: Icons.medication_rounded,
      iconColor: AppColors.warning,
      iconBg: AppColors.warningFaint,
      title: 'Latest Prescription',
      doctor: 'Dr. Sara Ahmed',
      date: 'Oct 15, 2025',
      status: 'active',
    ),
    _RecordItem(
      icon: Icons.science_rounded,
      iconColor: AppColors.info,
      iconBg: AppColors.infoFaint,
      title: 'Blood Test Results',
      doctor: 'Nile Lab Diagnostics',
      date: 'Oct 10, 2025',
      status: 'reviewed',
    ),
    _RecordItem(
      icon: Icons.local_hospital_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primaryFaint,
      title: 'General Checkup Visit',
      doctor: 'Dr. Sara Ahmed',
      date: 'Sep 28, 2025',
      status: 'completed',
    ),
  ];

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
            children: _items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _RecordTile(item: item, isDark: isDark),
                  if (i < _items.length - 1)
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
  const _RightColumn({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HealthOverviewCard(isDark: isDark),
        const SizedBox(height: 20),
        _RecentActivitySection(isDark: isDark),
      ],
    );
  }
}

class _HealthOverviewCard extends StatelessWidget {
  final bool isDark;
  const _HealthOverviewCard({required this.isDark});

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
                      value: 'O+',
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
                      value: '2 Known',
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
                value: 'Hypertension, Type 2 Diabetes',
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
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                    backgroundColor: AppColors.primaryFaint,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Sara Ahmed',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          'General Practitioner',
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
