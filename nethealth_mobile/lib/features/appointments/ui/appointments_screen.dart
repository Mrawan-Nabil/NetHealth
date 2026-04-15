import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import 'booking_modals.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppointmentsScreen
// ─────────────────────────────────────────────────────────────────────────────

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Mock data ───────────────────────────────────────────────────────────────
  static const _scheduled = [
    _Appointment(id: '1', doctor: 'Dr. Ayman Fathy',   specialty: 'Cardiologist',      clinic: 'City Heart Institute',   date: 'Feb 27, 2025', time: '11:00 AM', avatar: 'https://i.pravatar.cc/150?img=8',  status: 'scheduled', type: 'physical'),
    _Appointment(id: '2', doctor: 'Dr. Nadia Karim',   specialty: 'Dermatologist',     clinic: 'Nile Skin Clinic',       date: 'Mar 05, 2025', time: '02:30 PM', avatar: 'https://i.pravatar.cc/150?img=25', status: 'scheduled', type: 'remote'),
  ];

  static const _completed = [
    _Appointment(id: '3', doctor: 'Dr. Sara Ahmed',    specialty: 'General Practitioner', clinic: 'City General Hospital', date: 'Oct 15, 2025', time: '09:00 AM', avatar: 'https://i.pravatar.cc/150?img=5',  status: 'completed', type: 'physical'),
    _Appointment(id: '4', doctor: 'Dr. Ayman Fathy',  specialty: 'Cardiologist',          clinic: 'City Heart Institute',  date: 'Sep 02, 2025', time: '11:00 AM', avatar: 'https://i.pravatar.cc/150?img=8',  status: 'completed', type: 'physical'),
    _Appointment(id: '5', doctor: 'Dr. Ali Hassan',   specialty: 'Neurologist',           clinic: 'NeuroMed Institute',    date: 'Jun 28, 2025', time: '03:00 PM', avatar: 'https://i.pravatar.cc/150?img=12', status: 'completed', type: 'remote'),
  ];

  static const _cancelled = [
    _Appointment(id: '6', doctor: 'Dr. Ali Hassan',   specialty: 'Neurologist',      clinic: 'NeuroMed Institute',   date: 'Jan 10, 2025', time: '10:00 AM', avatar: 'https://i.pravatar.cc/150?img=12', status: 'cancelled', type: 'physical', cancelledBy: 'Doctor',  cancelReason: 'Doctor Unavailable'),
    _Appointment(id: '7', doctor: 'Dr. Sara Ahmed',   specialty: 'General Practitioner', clinic: 'City General Hospital', date: 'Nov 20, 2024', time: '09:30 AM', avatar: 'https://i.pravatar.cc/150?img=5',  status: 'cancelled', type: 'physical', cancelledBy: 'Patient', cancelReason: 'No Longer Needed'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Appointments', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        bottom: _NhTabBar(controller: _tab, isDark: isDark),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.findSpecialist),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Appointment', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _AppointmentList(appointments: _completed, isDark: isDark),
          _AppointmentList(appointments: _scheduled, isDark: isDark),
          _AppointmentList(appointments: _cancelled, isDark: isDark),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Tab Bar
// ─────────────────────────────────────────────────────────────────────────────

class _NhTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final bool isDark;
  const _NhTabBar({required this.controller, required this.isDark});

  @override
  Size get preferredSize => const Size.fromHeight(46);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: TabBar(
        controller: controller,
        labelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 14),
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        splashFactory: NoSplash.splashFactory,
        tabs: const [
          Tab(text: 'Completed'),
          Tab(text: 'Scheduled'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appointment List
// ─────────────────────────────────────────────────────────────────────────────

class _AppointmentList extends StatelessWidget {
  final List<_Appointment> appointments;
  final bool isDark;
  const _AppointmentList({required this.appointments, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return _EmptyState(isDark: isDark);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: appointments.length,
      itemBuilder: (context, i) => _AppointmentCard(appt: appointments[i], isDark: isDark),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appointment Card
// ─────────────────────────────────────────────────────────────────────────────

class _AppointmentCard extends StatelessWidget {
  final _Appointment appt;
  final bool isDark;
  const _AppointmentCard({required this.appt, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _borderColor(),
          width: appt.status == 'scheduled' ? 1.5 : 1,
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
          // ── Doctor header ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(appt.avatar),
                  backgroundColor: AppColors.primaryFaint,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.doctor,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appt.specialty,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: appt.status),
              ],
            ),
          ),

          // ── Info row ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _InfoChip(icon: Icons.calendar_today_rounded, text: appt.date, isDark: isDark),
                    const SizedBox(width: 14),
                    _InfoChip(icon: Icons.access_time_rounded,   text: appt.time, isDark: isDark),
                    const SizedBox(width: 14),
                    StatusBadge(status: appt.type, compact: true),
                  ],
                ),
                const SizedBox(height: 6),
                _InfoChip(icon: Icons.location_on_outlined, text: appt.clinic, isDark: isDark),
              ],
            ),
          ),

          const SizedBox(height: 14),
          Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),

          // ── Status-specific content ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: switch (appt.status) {
              'scheduled' => _ScheduledContent(appt: appt, isDark: isDark),
              'completed' => _CompletedContent(appt: appt, isDark: isDark),
              'cancelled' => _CancelledContent(appt: appt, isDark: isDark),
              _           => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Color _borderColor() {
    return switch (appt.status) {
      'scheduled' => AppColors.primary.withValues(alpha: 0.4),
      'completed' => AppColors.statusCompleted.withValues(alpha: 0.3),
      'cancelled' => AppColors.borderDark.withValues(alpha: 0.5),
      _           => AppColors.borderLight.withValues(alpha: 0.5),
    };
  }
}

// ── Scheduled content ─────────────────────────────────────────────────────────

class _ScheduledContent extends StatelessWidget {
  final _Appointment appt;
  final bool isDark;
  const _ScheduledContent({required this.appt, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload buttons
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.science_rounded,
                label: 'Upload Test Results',
                primary: true,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.image_outlined,
                label: 'Upload Imaging',
                primary: false,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed(
                  RouteNames.doctorDetails,
                  pathParameters: {'id': '1'},
                ),
                icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                label: const Text('Reschedule'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(context),
                icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                label: const Text('Cancel', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Appointment')),
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

// ── Completed content ─────────────────────────────────────────────────────────

class _CompletedContent extends StatelessWidget {
  final _Appointment appt;
  final bool isDark;
  const _CompletedContent({required this.appt, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attached files zone (dashed)
        Text('Reports & X-rays', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        const SizedBox(height: 8),
        CustomPaint(
          painter: _DashedBorder(isDark: isDark),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: const Column(
              children: [
                _AttachedFile(name: 'ECG_REPORT_2025.PDF',  size: '1.2 MB'),
                SizedBox(height: 6),
                _AttachedFile(name: 'BLOOD_WORK_OCT.PDF',   size: '0.8 MB'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.pushNamed(RouteNames.prescriptionDetails, pathParameters: {'id': appt.id}),
                icon: const Icon(Icons.medication_rounded, size: 16),
                label: const Text('Prescription'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed(RouteNames.medicalRecordDetail, pathParameters: {'id': appt.id}),
                icon: const Icon(Icons.medical_information_outlined, size: 16),
                label: const Text('View Record'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Cancelled content ─────────────────────────────────────────────────────────

class _CancelledContent extends StatelessWidget {
  final _Appointment appt;
  final bool isDark;
  const _CancelledContent({required this.appt, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cancelled by / reason
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.errorFaint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 18),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancelled by ${appt.cancelledBy ?? 'Patient'}',
                    style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.error),
                  ),
                  if (appt.cancelReason != null)
                    Text(
                      appt.cancelReason!,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.error.withValues(alpha: 0.8)),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.pushNamed(RouteNames.findSpecialist),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Rebook Appointment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  const _InfoChip({required this.icon, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: AppColors.primary),
      const SizedBox(width: 5),
      Text(text, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
    ],
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 15),
    label: Text(label, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 11)),
    style: ElevatedButton.styleFrom(
      backgroundColor: primary ? AppColors.primary : AppColors.primaryFaint,
      foregroundColor: primary ? Colors.white : AppColors.primaryDark,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

class _AttachedFile extends StatelessWidget {
  final String name;
  final String size;
  const _AttachedFile({required this.name, required this.size});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(name, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500))),
      Text(size, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHintLight)),
    ],
  );
}

class _DashedBorder extends CustomPainter {
  final bool isDark;
  _DashedBorder({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dash = 6.0;
    const gap  = 4.0;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12)));
    final metric = path.computeMetrics().first;
    double dist = 0;
    while (dist < metric.length) {
      canvas.drawPath(metric.extractPath(dist, dist + dash), paint);
      dist += dash + gap;
    }
  }

  @override bool shouldRepaint(covariant CustomPainter old) => false;
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle),
          child: const Icon(Icons.calendar_month_rounded, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text('No appointments here', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        const SizedBox(height: 8),
        Text('Book a new appointment to get started.', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data model
// ─────────────────────────────────────────────────────────────────────────────

class _Appointment {
  final String id;
  final String doctor;
  final String specialty;
  final String clinic;
  final String date;
  final String time;
  final String avatar;
  final String status;
  final String type;
  final String? cancelledBy;
  final String? cancelReason;

  const _Appointment({
    required this.id,
    required this.doctor,
    required this.specialty,
    required this.clinic,
    required this.date,
    required this.time,
    required this.avatar,
    required this.status,
    required this.type,
    this.cancelledBy,
    this.cancelReason,
  });
}
