import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/doctor_booking_model.dart';
import '../../../shared/widgets/doctor_avatar.dart';
import '../providers/appointments_provider.dart';
import 'booking_form_screen.dart';

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
          'Select a Doctor',
          style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          Container(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              style: TextStyle(
                fontFamily: 'Inter',
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name or specialty…',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
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
                // ── Specialty chips ────────────────────────────────────────
                final specialties = <String>{
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
                  children: [
                    // ── Specialty chip row ─────────────────────────────────
                    if (specialties.isNotEmpty)
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: specialties.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            if (i == 0) {
                              final active = _selectedSpecialty == null;
                              return _SpecialtyChip(
                                label: 'All',
                                active: active,
                                onTap: () => setState(() => _selectedSpecialty = null),
                                isDark: isDark,
                              );
                            }
                            final spec  = specialties[i - 1];
                            final active = _selectedSpecialty == spec;
                            return _SpecialtyChip(
                              label: spec,
                              active: active,
                              onTap: () => setState(() =>
                                _selectedSpecialty = active ? null : spec),
                              isDark: isDark,
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 8),

                    // ── Doctor count ───────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filtered.length} doctor${filtered.length == 1 ? '' : 's'} found',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Doctor list ─────────────────────────────────────────
                    Expanded(
                      child: filtered.isEmpty
                          ? _EmptySearch(isDark: isDark)
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (ctx, i) => _DoctorCard(
                                doctor: filtered[i],
                                isDark: isDark,
                                onTap: () {
                                  Navigator.push(
                                    ctx,
                                    MaterialPageRoute(
                                      builder: (_) => BookingFormScreen(
                                        doctor: filtered[i],
                                      ),
                                    ),
                                  );
                                },
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
}

// ─────────────────────────────────────────────────────────────────────────────
// _DoctorCard
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isDark;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.doctor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? AppColors.borderDark
                : AppColors.borderLight.withValues(alpha: 0.6),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          children: [
            DoctorAvatar(doctor: doctor, radius: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.displayName,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor.specialty.isNotEmpty
                        ? doctor.specialty
                        : 'General Practitioner',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (doctor.consultationFee != null &&
                      doctor.consultationFee!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined,
                            size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'EGP ${doctor.consultationFee}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryFaint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SpecialtyChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool isDark;

  const _SpecialtyChip({
    required this.label,
    required this.active,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active
                ? Colors.white
                : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}

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
              child: const Icon(Icons.person_search_rounded,
                  size: 44, color: AppColors.primary),
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
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
}
