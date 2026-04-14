import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mock data — defined at file level so they are always populated
// ─────────────────────────────────────────────────────────────────────────────

const _mockDoctors = [
  _DoctorMock(id: '1', name: 'Dr. Ayman Fathy',   specialty: 'Cardiology',  clinic: 'City Heart Institute',   rating: 4.9, reviews: 127, experience: '12 yrs', availableToday: true,  fee: '\$100', avatar: 'https://i.pravatar.cc/150?img=8'),
  _DoctorMock(id: '2', name: 'Dr. Sara Ahmed',     specialty: 'Neurology',   clinic: 'City General Hospital',  rating: 4.7, reviews: 89,  experience: '8 yrs',  availableToday: true,  fee: '\$80',  avatar: 'https://i.pravatar.cc/150?img=5'),
  _DoctorMock(id: '3', name: 'Dr. Nadia Karim',   specialty: 'Dermatology', clinic: 'Nile Skin Clinic',       rating: 4.8, reviews: 54,  experience: '6 yrs',  availableToday: false, fee: '\$90',  avatar: 'https://i.pravatar.cc/150?img=25'),
  _DoctorMock(id: '4', name: 'Dr. Ali Hassan',    specialty: 'Neurology',   clinic: 'NeuroMed Institute',     rating: 4.6, reviews: 201, experience: '15 yrs', availableToday: true,  fee: '\$120', avatar: 'https://i.pravatar.cc/150?img=12'),
  _DoctorMock(id: '5', name: 'Dr. Khaled Samir',  specialty: 'Cardiology',  clinic: 'Heart Care Center',      rating: 4.5, reviews: 73,  experience: '9 yrs',  availableToday: false, fee: '\$95',  avatar: 'https://i.pravatar.cc/150?img=15'),
  _DoctorMock(id: '6', name: 'Dr. Layla Ibrahim', specialty: 'Pulmonology', clinic: 'Lung & Chest Institute', rating: 4.9, reviews: 38,  experience: '11 yrs', availableToday: true,  fee: '\$110', avatar: 'https://i.pravatar.cc/150?img=47'),
];

const _specialties = [
  _Specialty(label: 'All Specialties',  icon: Icons.apps_rounded),
  _Specialty(label: 'Cardiology',        icon: Icons.favorite_rounded),
  _Specialty(label: 'Neurology',         icon: Icons.psychology_rounded),
  _Specialty(label: 'Gastroenterology',  icon: Icons.lunch_dining_rounded),
  _Specialty(label: 'Dermatology',       icon: Icons.face_retouching_natural_rounded),
  _Specialty(label: 'Dentistry',         icon: Icons.medical_services_rounded),
  _Specialty(label: 'Pulmonology',       icon: Icons.air_rounded),
  _Specialty(label: 'Orthopaedics',      icon: Icons.accessibility_new_rounded),
];

// ─────────────────────────────────────────────────────────────────────────────
// FindSpecialistScreen
// ─────────────────────────────────────────────────────────────────────────────

class FindSpecialistScreen extends StatefulWidget {
  const FindSpecialistScreen({super.key});

  @override
  State<FindSpecialistScreen> createState() => _FindSpecialistScreenState();
}

class _FindSpecialistScreenState extends State<FindSpecialistScreen> {
  final _searchCtrl     = TextEditingController();
  int    _selectedIndex = 0;   // 0 = "All Specialties"
  String _query         = '';

  // Filtered list: runs synchronously every rebuild — no async needed.
  List<_DoctorMock> get _filtered {
    final List<_DoctorMock> list = _selectedIndex == 0
        ? List<_DoctorMock>.from(_mockDoctors)
        : _mockDoctors
            .where((d) => d.specialty == _specialties[_selectedIndex].label)
            .toList();

    if (_query.isEmpty) return list;
    final q = _query.toLowerCase();
    return list
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.specialty.toLowerCase().contains(q) ||
            d.clinic.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final doctors  = _filtered;   // evaluated once per build

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Book a New Appointment',
          style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // ── BODY: strict Column → Expanded → ListView hierarchy ─────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 1 ─ Search bar ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name, hospital, specialty...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => setState(() {
                          _query = '';
                          _searchCtrl.clear();
                        }),
                      )
                    : Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                      ),
              ),
            ),
          ),

          // 2 ─ Specialty filter chips ─────────────────────────────────────────
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _specialties.length,
              itemBuilder: (_, i) {
                final sp         = _specialties[i];
                final isSelected = _selectedIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            sp.icon,
                            size: 14,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sp.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 3 ─ Results count ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              '${doctors.length} doctor${doctors.length == 1 ? '' : 's'} found',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
              ),
            ),
          ),

          // 4 ─ Expanded + 5 ─ ListView.builder ──────────────────────────────
          Expanded(
            child: doctors.isEmpty
                ? _EmptyState(isDark: isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: doctors.length,
                    shrinkWrap: false,
                    itemBuilder: (_, i) =>
                        _DoctorSearchCard(doctor: doctors[i], isDark: isDark),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor Search Card
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorSearchCard extends StatelessWidget {
  final _DoctorMock doctor;
  final bool isDark;
  const _DoctorSearchCard({super.key, required this.doctor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.doctorDetails,
        pathParameters: {'id': doctor.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6),
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
          children: [
            // ── Header row ──────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + online dot
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(doctor.avatar),
                      backgroundColor: AppColors.primaryFaint,
                    ),
                    if (doctor.availableToday)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.statusCompleted,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                          const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            '${doctor.rating}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            ' (${doctor.reviews})',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${doctor.specialty} • ${doctor.experience}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.clinic,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (doctor.availableToday)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.successFaint,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Available Today',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.statusCompleted,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
            const SizedBox(height: 14),

            // ── Footer: fee + book button ────────────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consultation Fee',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                      ),
                    ),
                    Text(
                      doctor.fee,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => context.pushNamed(
                    RouteNames.doctorDetails,
                    pathParameters: {'id': doctor.id},
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle),
          child: const Icon(Icons.search_off_rounded, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'No doctors found',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Try a different name or specialty.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

class _Specialty {
  final String label;
  final IconData icon;
  const _Specialty({required this.label, required this.icon});
}

class _DoctorMock {
  final String id, name, specialty, clinic, experience, fee, avatar;
  final double rating;
  final int    reviews;
  final bool   availableToday;

  const _DoctorMock({
    required this.id,
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.availableToday,
    required this.fee,
    required this.avatar,
  });
}
