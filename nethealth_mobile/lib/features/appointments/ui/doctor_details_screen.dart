import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/doctor_booking_model.dart';
import 'booking_modals.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DoctorDetailsScreen
//
// Full scheduling flow: profile header → stats → day picker → time slots →
// appointment type → sticky confirm bar → booking modal.
// ─────────────────────────────────────────────────────────────────────────────

class DoctorDetailsScreen extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  // ── Scheduling state ────────────────────────────────────────────────────────
  int    _selectedDayIndex  = 2;
  String _selectedTime      = '10:00 AM';
  int    _selectedTypeIndex = 0;

  static const _days = [
    _DaySlot(day: 'Mon', date: '24'),
    _DaySlot(day: 'Tue', date: '25'),
    _DaySlot(day: 'Wed', date: '26'),
    _DaySlot(day: 'Thu', date: '27'),
    _DaySlot(day: 'Fri', date: '28'),
    _DaySlot(day: 'Sat', date: '29'),
  ];

  static const _times = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM', '04:00 PM',
  ];

  static const _unavailableTimes = {'09:30 AM', '11:30 AM', '03:00 PM'};

  static const _appointmentTypes = [
    _ApptType(icon: Icons.local_hospital_rounded,   title: 'Clinic Visit',                  subtitle: 'In-person consultation at the clinic', badge: 'physical'),
    _ApptType(icon: Icons.videocam_rounded,          title: 'Online Consultation',            subtitle: 'Video call with your doctor',           badge: 'remote'),
    _ApptType(icon: Icons.refresh_rounded,           title: 'Follow-up Visit',               subtitle: 'Review of your ongoing treatment',      badge: 'physical'),
  ];

  _DaySlot       get _day    => _days[_selectedDayIndex];
  _ApptType      get _type   => _appointmentTypes[_selectedTypeIndex];

  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doc    = widget.doctor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sliver App Bar with doctor avatar (Step 2) ───────────────────
          _DoctorSliverAppBar(doctor: doc, isDark: isDark),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats row (Step 3) ────────────────────────────────────
                  _StatsRow(doctor: doc, isDark: isDark),
                  const SizedBox(height: 24),

                  // ── About (Bio from model if available, else static) ──────
                  _sectionTitle('About', isDark),
                  const SizedBox(height: 10),
                  _ExpandableAbout(
                    bio: (doc.experience != null && doc.experience!.length > 20) 
                        ? doc.experience! 
                        : 'Compassionate physician experienced in treating patients with complex medical conditions. Emphasizes preventive care and clear communication with patients.', 
                    isDark: isDark
                  ),
                  const SizedBox(height: 24),

                  // ── Qualifications (Dynamic Field) ────────────────────────
                  if (doc.qualifications != null && doc.qualifications!.isNotEmpty) ...[
                    _sectionTitle('Qualifications', isDark),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              doc.qualifications!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Day selector (Static as requested in Step 4) ──────────
                  _sectionTitle('Available Days', isDark),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      itemBuilder: (_, i) {
                        final d          = _days[i];
                        final isSelected = _selectedDayIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedDayIndex = i;
                            if (_unavailableTimes.contains(_selectedTime)) {
                              _selectedTime = '10:00 AM';
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            width: 58,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  d.day,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  d.date,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Time slots (Static as requested in Step 4) ───────────
                  _sectionTitle('Available Time Slots', isDark),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _times.map((t) {
                      final isSelected    = _selectedTime == t;
                      final isUnavailable = _unavailableTimes.contains(t);
                      return GestureDetector(
                        onTap: isUnavailable ? null : () => setState(() => _selectedTime = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: isUnavailable
                                ? (isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9))
                                : isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isUnavailable
                                  ? (isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.4))
                                  : isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isUnavailable
                                  ? (isDark ? AppColors.textHintDark : AppColors.textHintLight).withValues(alpha: 0.4)
                                  : isSelected
                                      ? Colors.white
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              decoration: isUnavailable ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Appointment type (Static as requested in Step 4) ────────
                  _sectionTitle('Appointment Type', isDark),
                  const SizedBox(height: 12),
                  ..._appointmentTypes.asMap().entries.map((e) {
                    final i          = e.key;
                    final t          = e.value;
                    final isSelected = _selectedTypeIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTypeIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06)
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.primaryFaint,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(t.icon, color: isSelected ? Colors.white : AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.title,
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isSelected ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.subtitle,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Sticky bottom bar ───────────────────────────────────────────────
      bottomNavigationBar: _BottomBar(
        doctor: doc,
        day: _day,
        time: _selectedTime,
        typeName: _type.title,
        typeBadge: _type.badge,
        clinic: 'NetHealth Medical Center', 
        isDark: isDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

Widget _sectionTitle(String title, bool isDark) => Text(
  title,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
  ),
);

class _DoctorSliverAppBar extends StatelessWidget {
  final DoctorModel doctor;
  final bool isDark;
  const _DoctorSliverAppBar({required this.doctor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient bg
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D9488), AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Doctor info overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    // Step 2: Initials Avatar Logic
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              doctor.avatarUrl!,
                              fit: BoxFit.cover,
                              width: 96,
                              height: 96,
                              errorBuilder: (_, __, ___) => Text(
                                doctor.initials,
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          )
                        : Text(
                            doctor.initials,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.displayName,
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(doctor.specialty, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white70)),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 13, color: Colors.white70),
                              SizedBox(width: 4),
                              Expanded(child: Text('NetHealth Medical Center', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white70), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                              SizedBox(width: 4),
                              Text('4.9', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(' (127 reviews)', style: TextStyle(color: Colors.white60, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final DoctorModel doctor;
  final bool isDark;
  const _StatsRow({required this.doctor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatTile(icon: Icons.event_available_rounded, color: AppColors.primary,    bg: AppColors.primaryFaint,  label: 'Next Available',    value: 'In 2 Days', isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.payments_outlined,        color: AppColors.success,    bg: AppColors.successFaint,  label: 'Consultation Fee',  value: doctor.consultationFee != null ? '\$${doctor.consultationFee}' : '\$100', isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.workspace_premium_rounded, color: AppColors.warning,   bg: AppColors.warningFaint,  label: 'Experience',        value: doctor.experience ?? '10 Years', isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.star_rounded,              color: AppColors.error,     bg: AppColors.errorFaint,    label: 'Rating',            value: '4.9★',  isDark: isDark)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final String label;
  final String value;
  final bool isDark;

  const _StatTile({
    required this.icon, required this.color, required this.bg,
    required this.label, required this.value, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 9, color: isDark ? AppColors.textHintDark : AppColors.textHintLight, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ExpandableAbout extends StatefulWidget {
  final String bio;
  final bool isDark;
  const _ExpandableAbout({required this.bio, required this.isDark});

  @override
  State<_ExpandableAbout> createState() => _ExpandableAboutState();
}

class _ExpandableAboutState extends State<_ExpandableAbout> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bio,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.6,
              color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _expanded ? 'Show less ↑' : 'Read more ↓',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final DoctorModel doctor;
  final _DaySlot day;
  final String time;
  final String typeName;
  final String typeBadge;
  final String clinic;
  final bool isDark;

  const _BottomBar({
    required this.doctor,
    required this.day,
    required this.time,
    required this.typeName,
    required this.typeBadge,
    required this.clinic,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary row
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  '${day.day} ${day.date}  •  $time  •  $typeName',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showConfirmAppointmentSheet(
                  context,
                  doctorName: doctor.fullName,
                  specialty:  doctor.specialty,
                  day:        day.day,
                  date:       day.date,
                  time:       time,
                  type:       typeName,
                  clinic:     clinic,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16),
                ),
                child: const Text('Confirm Appointment →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _DaySlot {
  final String day;
  final String date;
  const _DaySlot({required this.day, required this.date});
}

class _ApptType {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  const _ApptType({required this.icon, required this.title, required this.subtitle, required this.badge});
}
