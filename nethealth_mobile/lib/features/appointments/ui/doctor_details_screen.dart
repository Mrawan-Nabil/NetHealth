import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'booking_modals.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DoctorDetailsScreen
//
// Full scheduling flow: profile header → stats → day picker → time slots →
// appointment type → sticky confirm bar → booking modal.
// ─────────────────────────────────────────────────────────────────────────────

class DoctorDetailsScreen extends StatefulWidget {
  final String id;
  const DoctorDetailsScreen({super.key, required this.id});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  // ── Scheduling state ────────────────────────────────────────────────────────
  int    _selectedDayIndex  = 2;
  String _selectedTime      = '10:00 AM';
  int    _selectedTypeIndex = 0;

  // ── Mock doctor data (keyed by ID) ──────────────────────────────────────────
  static const _doctors = {
    '1': _DoctorProfile(name: 'Dr. Ayman Fathy',   specialty: 'Cardiologist',         clinic: 'City Heart Institute',   rating: 4.9, reviews: 127, experience: '12 Years', bio: 'Dr. Fathy is a board-certified cardiologist with 12 years of experience treating complex cardiovascular conditions. He has performed over 2,000 cardiac procedures and conducted research published in leading international medical journals.', avatar: 'https://i.pravatar.cc/150?img=8',  fee: '\$100', nextAvailable: 'In 2 Days'),
    '2': _DoctorProfile(name: 'Dr. Sara Ahmed',     specialty: 'General Practitioner', clinic: 'City General Hospital',  rating: 4.7, reviews: 89,  experience: '8 Years',  bio: 'Dr. Ahmed provides comprehensive primary care with a patient-centered approach. She specialises in preventative medicine and chronic condition management, ensuring every patient receives personalised attention.', avatar: 'https://i.pravatar.cc/150?img=5',  fee: '\$80',  nextAvailable: 'Tomorrow'),
    '3': _DoctorProfile(name: 'Dr. Nadia Karim',   specialty: 'Dermatologist',        clinic: 'Nile Skin Clinic',       rating: 4.8, reviews: 54,  experience: '6 Years',  bio: 'Dr. Karim combines the latest evidence-based dermatological treatments with an empathetic care philosophy. She is a specialist in skin conditions, laser treatments, and aesthetic dermatology.', avatar: 'https://i.pravatar.cc/150?img=25', fee: '\$90',  nextAvailable: 'In 4 Days'),
  };

  static const _fallbackDoctor = _DoctorProfile(name: 'Dr. Unknown', specialty: 'Specialist', clinic: 'NetHealth Clinic', rating: 4.5, reviews: 0, experience: '—', bio: 'Doctor profile not found.', avatar: 'https://i.pravatar.cc/150?img=1', fee: '—', nextAvailable: '—');

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

  _DoctorProfile get _doctor => _doctors[widget.id] ?? _fallbackDoctor;
  _DaySlot       get _day    => _days[_selectedDayIndex];
  _ApptType      get _type   => _appointmentTypes[_selectedTypeIndex];

  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doc    = _doctor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sliver App Bar with doctor avatar ─────────────────────────────
          _DoctorSliverAppBar(doctor: doc, isDark: isDark),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats row ─────────────────────────────────────────────
                  _StatsRow(doctor: doc, isDark: isDark),
                  const SizedBox(height: 24),

                  // ── About ─────────────────────────────────────────────────
                  _SectionTitle('About', isDark),
                  const SizedBox(height: 10),
                  _ExpandableAbout(bio: doc.bio, isDark: isDark),
                  const SizedBox(height: 24),

                  // ── Day selector ─────────────────────────────────────────
                  _SectionTitle('Available Days', isDark),
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
                            // Reset time if currently unavailable slot
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

                  // ── Time slots ────────────────────────────────────────────
                  _SectionTitle('Available Time Slots', isDark),
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

                  // ── Appointment type ──────────────────────────────────────
                  _SectionTitle('Appointment Type', isDark),
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

      // ── Sticky bottom bar ────────────────────────────────────────────────────
      bottomNavigationBar: _BottomBar(
        doctor: _doctor,
        day: _day,
        time: _selectedTime,
        typeName: _type.title,
        typeBadge: _type.badge,
        clinic: _doctor.clinic,
        isDark: isDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorSliverAppBar extends StatelessWidget {
  final _DoctorProfile doctor;
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
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(doctor.avatar),
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(doctor.specialty, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white70)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: Colors.white70),
                              const SizedBox(width: 4),
                              Expanded(child: Text(doctor.clinic, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white70), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                              const SizedBox(width: 4),
                              Text('${doctor.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(' (${doctor.reviews} reviews)', style: const TextStyle(color: Colors.white60, fontSize: 12)),
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
  final _DoctorProfile doctor;
  final bool isDark;
  const _StatsRow({required this.doctor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatTile(icon: Icons.event_available_rounded, color: AppColors.primary,    bg: AppColors.primaryFaint,  label: 'Next Available',    value: doctor.nextAvailable, isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.payments_outlined,        color: AppColors.success,    bg: AppColors.successFaint,  label: 'Consultation Fee',  value: doctor.fee,           isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.workspace_premium_rounded, color: AppColors.warning,   bg: AppColors.warningFaint,  label: 'Experience',        value: doctor.experience,    isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.star_rounded,              color: AppColors.error,     bg: AppColors.errorFaint,    label: 'Rating',            value: '${doctor.rating}★',  isDark: isDark)),
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
  final _DoctorProfile doctor;
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
                  doctorName: doctor.name,
                  specialty:  doctor.specialty,
                  day:        day.day,
                  date:       day.date,
                  time:       time,
                  type:       typeName,
                  clinic:     doctor.clinic,
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

Widget _SectionTitle(String title, bool isDark) => Text(
  title,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
  ),
);

// ─────────────────────────────────────────────────────────────────────────────
// Mock data models
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorProfile {
  final String name;
  final String specialty;
  final String clinic;
  final double rating;
  final int reviews;
  final String experience;
  final String bio;
  final String avatar;
  final String fee;
  final String nextAvailable;

  const _DoctorProfile({
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.bio,
    required this.avatar,
    required this.fee,
    required this.nextAvailable,
  });
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
