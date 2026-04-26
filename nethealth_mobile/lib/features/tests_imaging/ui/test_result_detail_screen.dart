import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/tests_imaging_provider.dart';

class TestResultDetailScreen extends ConsumerWidget {
  final String id;
  const TestResultDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state  = ref.watch(testResultDetailProvider(id));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Test Result', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.download_rounded), tooltip: 'Download', onPressed: () {})],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(e.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.invalidate(testResultDetailProvider(id)), child: const Text('Retry')),
          ],
        )),
        data: (result) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header card ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primaryLight, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.science_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(result.name, style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(result.category, style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Inter')),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    StatusBadge(status: result.testResultStatus.value),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Metadata ─────────────────────────────────────────────────
              _MetaCard(isDark: isDark, rows: [
                _MetaRow(icon: Icons.calendar_today_rounded, label: 'Date',       value: result.date),
                _MetaRow(icon: Icons.biotech_outlined,       label: 'Laboratory', value: result.lab),
                _MetaRow(icon: Icons.insert_drive_file_outlined, label: 'Format', value: '${result.format}  •  ${result.fileSize}'),
              ]),
              const SizedBox(height: 20),

              // ── Notes ────────────────────────────────────────────────────
              if ((result.notes ?? '').isNotEmpty) ...[
                Text('Notes', style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6))),
                  child: Text(result.notes!, style: TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.6, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                ),
                const SizedBox(height: 28),
              ],

              // ── Actions ───────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: result.fileUrl != null ? () {} : null,
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('View / Download Report'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Share with Doctor'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _MetaCard extends StatelessWidget {
  final bool isDark;
  final List<_MetaRow> rows;
  const _MetaCard({required this.isDark, required this.rows});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6))),
    child: Column(children: rows.map((row) {
      final isLast = row == rows.last;
      return Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Icon(row.icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 12),
            SizedBox(width: 84, child: Text(row.label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight))),
            Expanded(child: Text(row.value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
          ]),
        ),
        if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.4)),
      ]);
    }).toList()),
  );
}

class _MetaRow {
  final IconData icon;
  final String label;
  final String value;
  const _MetaRow({required this.icon, required this.label, required this.value});
}
