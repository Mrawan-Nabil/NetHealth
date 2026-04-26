import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/models/prescription_model.dart';
import '../../prescriptions/providers/prescriptions_provider.dart';
import '../../tests_imaging/providers/tests_imaging_provider.dart';
import '../providers/visit_history_provider.dart';

class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Medical Records', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 13),
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(text: 'Prescriptions'),
              Tab(text: 'Test Results'),
              Tab(text: 'Imaging'),
              Tab(text: 'Visit History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PrescriptionsTab(isDark: isDark, ref: ref),
            _TestResultsTab(isDark: isDark, ref: ref),
            _ImagingTab(isDark: isDark, ref: ref),
            _VisitHistoryTab(isDark: isDark, ref: ref),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Prescriptions
// ─────────────────────────────────────────────────────────────────────────────

class _PrescriptionsTab extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _PrescriptionsTab({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prescriptionsProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => _ErrorState(message: e.toString(), isDark: isDark, onRetry: () => ref.invalidate(prescriptionsProvider)),
      data: (items) {
        if (items.isEmpty) return _EmptyState(isDark: isDark, icon: Icons.medication_rounded, label: 'No Prescriptions Yet', sub: 'Your prescriptions will appear here after a doctor visit.');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: items.length,
          itemBuilder: (ctx, i) => _PrescriptionCard(item: items[i], isDark: isDark),
        );
      },
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final PrescriptionListModel item;
  final bool isDark;
  const _PrescriptionCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isActive = item.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.primary.withValues(alpha: 0.4) : (isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06) : (isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primaryFaint : (isDark ? AppColors.surfaceDark : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medication_rounded, size: 20, color: isActive ? AppColors.primary : (isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RX-${item.id}', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                      const SizedBox(height: 2),
                      Text(item.doctor, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      Text(item.specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                    ],
                  ),
                ),
                StatusBadge(status: item.prescriptionStatus.value),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _InfoPill(icon: Icons.calendar_today_rounded, text: item.date, isDark: isDark),
                    const SizedBox(width: 10),
                    _InfoPill(icon: Icons.event_busy_rounded, text: 'Valid until: ${item.expires}', isDark: isDark),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Diagnosis', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                      const SizedBox(height: 4),
                      Text(item.diagnosis, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('Medications', style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 8),
                ...item.medicines.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(margin: const EdgeInsets.only(top: 6), width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(med, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
                    ],
                  ),
                )),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded, size: 15),
                        label: const Text('Download'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10), textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushNamed(RouteNames.prescriptionDetails, pathParameters: {'id': item.id.toString()}),
                        icon: const Icon(Icons.remove_red_eye_rounded, size: 15),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10), textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: Test Results
// ─────────────────────────────────────────────────────────────────────────────

class _TestResultsTab extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _TestResultsTab({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(testResultsProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => _ErrorState(message: e.toString(), isDark: isDark, onRetry: () => ref.invalidate(testResultsProvider)),
      data: (items) {
        if (items.isEmpty) return _EmptyState(isDark: isDark, icon: Icons.science_rounded, label: 'No Lab Results Yet', sub: 'Your lab results will appear here once your doctor orders tests.');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final item = items[i];
            return GestureDetector(
              onTap: () => context.pushNamed(RouteNames.testResultDetail, pathParameters: {'id': item.id.toString()}),
              child: _SimpleAttachmentCard(
                isDark: isDark,
                icon: Icons.science_rounded,
                iconColor: AppColors.info,
                iconBg: AppColors.infoFaint,
                categoryLabel: item.category,
                title: item.name,
                subtitle: item.lab,
                date: item.date,
                status: item.testResultStatus.value,
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Imaging
// ─────────────────────────────────────────────────────────────────────────────

class _ImagingTab extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _ImagingTab({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imagingProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => _ErrorState(message: e.toString(), isDark: isDark, onRetry: () => ref.invalidate(imagingProvider)),
      data: (items) {
        if (items.isEmpty) return _EmptyState(isDark: isDark, icon: Icons.image_outlined, label: 'No Imaging Records Yet', sub: 'Scans and imaging results ordered by your doctor will appear here.');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final item = items[i];
            final (iconColor, iconBg) = _modalityColors(item.type);
            return GestureDetector(
              onTap: () => context.pushNamed(RouteNames.imageViewer, pathParameters: {'id': item.id.toString()}),
              child: _SimpleAttachmentCard(
                isDark: isDark,
                icon: Icons.image_outlined,
                iconColor: iconColor,
                iconBg: iconBg,
                categoryLabel: item.type.toUpperCase(),
                title: item.title,
                subtitle: item.physician,
                date: item.scanDate,
                status: item.testResultStatus.value,
              ),
            );
          },
        );
      },
    );
  }

  (Color, Color) _modalityColors(String type) => switch (type.toUpperCase()) {
        'MRI'       => (AppColors.primary, AppColors.primaryFaint),
        'CT SCAN'   => (AppColors.info, AppColors.infoFaint),
        'X-RAY'     => (AppColors.warning, AppColors.warningFaint),
        'ECHO' || 'ULTRASOUND' => (AppColors.error, AppColors.errorFaint),
        _           => (AppColors.primary, AppColors.primaryFaint),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 4: Visit History
// ─────────────────────────────────────────────────────────────────────────────

class _VisitHistoryTab extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _VisitHistoryTab({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visitHistoryProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => _ErrorState(message: e.toString(), isDark: isDark, onRetry: () => ref.invalidate(visitHistoryProvider)),
      data: (visits) {
        if (visits.isEmpty) return _EmptyState(isDark: isDark, icon: Icons.history_rounded, label: 'No Visits Yet', sub: 'Your appointment history will appear here.');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: visits.length,
          itemBuilder: (ctx, i) {
            final v = visits[i];
            return GestureDetector(
              onTap: () => context.pushNamed(RouteNames.appointmentDetail, pathParameters: {'id': v.id.toString()}),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
                  boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.calendar_today_rounded, size: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                          const SizedBox(width: 5),
                          Text(v.date, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                        ]),
                        StatusBadge(status: v.appointmentStatus.value, compact: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(v.doctorName, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                    Text(v.specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                    const SizedBox(height: 8),
                    Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                      const SizedBox(width: 5),
                      Expanded(child: Text(v.clinic, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                      const SizedBox(width: 8),
                      StatusBadge(status: v.appointmentType.value, compact: true),
                    ]),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SimpleAttachmentCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String categoryLabel;
  final String title;
  final String subtitle;
  final String date;
  final String status;

  const _SimpleAttachmentCard({required this.isDark, required this.icon, required this.iconColor, required this.iconBg, required this.categoryLabel, required this.title, required this.subtitle, required this.date, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(categoryLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: iconColor)),
                    ),
                    const Spacer(),
                    StatusBadge(status: status, compact: true),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.calendar_today_rounded, size: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                  const SizedBox(width: 4),
                  Text(date, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.borderDark : AppColors.textHintLight),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  const _InfoPill({required this.icon, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: AppColors.primary),
      const SizedBox(width: 5),
      Text(text, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
    ],
  );
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String sub;
  const _EmptyState({required this.isDark, required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle), child: Icon(icon, size: 48, color: AppColors.primary)),
        const SizedBox(height: 20),
        Text(label, style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(sub, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        ),
      ],
    ),
  );
}

class _ErrorState extends StatelessWidget {
  final String message;
  final bool isDark;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.isDark, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
        const SizedBox(height: 16),
        Text('Something went wrong', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry')),
      ],
    ),
  );
}
