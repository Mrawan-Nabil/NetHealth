import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/models/doctor_booking_model.dart';
import '../../../shared/widgets/doctor_avatar.dart';
import '../providers/appointments_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DoctorSelectionScreen
// Step 1 of 2 in the booking flow: choose a doctor.
// ─────────────────────────────────────────────────────────────────────────────

class DoctorSelectionScreen extends ConsumerStatefulWidget {
  const DoctorSelectionScreen({super.key});

  @override
  ConsumerState<DoctorSelectionScreen> createState() =>
      _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends ConsumerState<DoctorSelectionScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedSpecialty;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final asyncDocs = ref.watch(doctorsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Book a New Appointment',
          style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1 ─ Search bar ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
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
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
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

          // 2 ─ Body ──────────────────────────────────────────────────────────
          Expanded(
            child: asyncDocs.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load doctors.\nPlease try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => ref.invalidate(doctorsProvider),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (doctors) {
                // ── Specialty list ─────────────────────────────────────────
                final categories = <String>{
                  ...doctors.map((d) => d.specialty).where((s) => s.isNotEmpty),
                }.toList()
                  ..sort();

                // ── Filter ────────────────────────────────────────────────
                final filtered = doctors.where((d) {
                  final matchesSearch = _query.isEmpty ||
                      d.fullName.toLowerCase().contains(_query) ||
                      d.specialty.toLowerCase().contains(_query);
                  final matchesSpecialty = _selectedSpecialty == null ||
                      d.specialty == _selectedSpecialty;
                  return matchesSearch && matchesSpecialty;
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Specialty horizontal list ──────────────────────────
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length + 1,
                        itemBuilder: (context, i) {
                          final label = i == 0 ? 'All Specialties' : categories[i-1];
                          final isSelected = (_selectedSpecialty == null && i == 0) || (_selectedSpecialty == label);
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _SpecialtyChip(
                              label: label,
                              icon: _getSpecialtyIcon(label),
                              isSelected: isSelected,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  if (i == 0) {
                                    _selectedSpecialty = null;
                                  } else {
                                    _selectedSpecialty = label;
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    // ── Results count ───────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        '${filtered.length} doctor${filtered.length == 1 ? '' : 's'} found',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                        ),
                      ),
                    ),

                    // ── Doctor list ─────────────────────────────────────────
                    Expanded(
                      child: filtered.isEmpty
                          ? _EmptySearch(isDark: isDark)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filtered.length,
                              itemBuilder: (ctx, i) => _DoctorSearchCard(
                                doctor: filtered[i],
                                isDark: isDark,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSpecialtyIcon(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'all specialties': return Icons.apps_rounded;
      case 'cardiology':      return Icons.favorite_rounded;
      case 'neurology':       return Icons.psychology_rounded;
      case 'gastroenterology':return Icons.lunch_dining_rounded;
      case 'dermatology':     return Icons.face_retouching_natural_rounded;
      case 'dentistry':       return Icons.medical_services_rounded;
      case 'pulmonology':     return Icons.air_rounded;
      case 'orthopaedics':    return Icons.accessibility_new_rounded;
      default:               return Icons.medical_services_outlined;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor Search Card
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorSearchCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isDark;

  const _DoctorSearchCard({
    required this.doctor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteNames.doctorDetails,
          pathParameters: {'id': doctor.id.toString()},
          extra: doctor,
        );
      },
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
                // Avatar + online dot (Mock availability for visual parity)
                Stack(
                  children: [
                    DoctorAvatar(doctor: doctor, radius: 30),
                    // We can assume online if they have an ID % 2 == 0 for visual variety
                    if (doctor.id % 2 == 0)
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
                      // Name + rating (Mock rating for visual parity)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.fullName,
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
                            '4.8', // Mock
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            ' (120)', // Mock
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
                        '${doctor.specialty} • ${doctor.experience ?? '8 yrs exp'}',
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
                              doctor.clinic?.clinicName ?? 'Clinic not assigned',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (doctor.id % 2 == 0)
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
                      doctor.consultationFee != null ? 'EGP ${doctor.consultationFee}' : 'EGP 100',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.doctorDetails,
                        pathParameters: {'id': doctor.id.toString()},
                        extra: doctor,
                      );
                    },
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
// Specialty Chip
// ─────────────────────────────────────────────────────────────────────────────

class _SpecialtyChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SpecialtyChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(width: 6),
            Text(
              label,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty search
// ─────────────────────────────────────────────────────────────────────────────

class _EmptySearch extends StatelessWidget {
  final bool isDark;
  const _EmptySearch({required this.isDark});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: AppColors.primaryFaint, shape: BoxShape.circle),
              child: const Icon(Icons.search_off_rounded,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'No doctors found',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different name or specialty.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
}
