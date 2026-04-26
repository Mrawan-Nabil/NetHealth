import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/prescriptions_provider.dart';

class PrescriptionDetailsScreen extends ConsumerWidget {
  final String id;
  const PrescriptionDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state  = ref.watch(prescriptionDetailProvider(id));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('RX-$id Details', style: const TextStyle(fontFamily: 'Outfit')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.download_rounded), onPressed: () {})],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(e.toString(), textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Inter', fontSize: 13)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.invalidate(prescriptionDetailProvider(id)), child: const Text('Retry')),
          ],
        )),
        data: (rx) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Banner ───────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    CircleAvatar(radius: 20, backgroundColor: Colors.white.withValues(alpha: 0.2), child: const Icon(Icons.qr_code_2_rounded, color: Colors.white)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Valid until: ${rx.expires}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('Prescribed by ${rx.doctor?['name'] ?? 'Your Doctor'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Status + Date ─────────────────────────────────────────────
              Row(children: [
                StatusBadge(status: rx.prescriptionStatus.value),
                const SizedBox(width: 10),
                Icon(Icons.calendar_today_rounded, size: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                const SizedBox(width: 5),
                Text(rx.generatedDate, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
              ]),
              const SizedBox(height: 20),

              // ── Diagnosis ─────────────────────────────────────────────────
              if (rx.diagnosis != null) ...[
                Text('Diagnosis', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rx.diagnosis!['title']?.toString() ?? '', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                      if ((rx.diagnosis!['description']?.toString() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(rx.diagnosis!['description'].toString(), style: TextStyle(fontFamily: 'Inter', fontSize: 13, height: 1.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Medications ───────────────────────────────────────────────
              Text('Medications', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const SizedBox(height: 12),
              ...rx.medicines.map((med) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.medication_liquid_rounded, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(med.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                    ]),
                    if (med.type != null) ...[
                      const SizedBox(height: 4),
                      Text(med.type!, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primary)),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoCol(isDark, 'Dosage', med.dosage),
                        _infoCol(isDark, 'Freq', med.frequency),
                        _infoCol(isDark, 'Duration', med.duration),
                      ],
                    ),
                    if (med.instructions.isNotEmpty && med.instructions != 'Take as directed.') ...[
                      const SizedBox(height: 10),
                      Text(med.instructions, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight, fontStyle: FontStyle.italic)),
                    ],
                  ],
                ),
              )),

              // ── Notes ─────────────────────────────────────────────────────
              if (rx.notes.isNotEmpty && rx.notes.first != 'No additional notes provided.') ...[
                const SizedBox(height: 8),
                Text('Notes', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rx.notes.map((n) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('• $n', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5)))).toList()),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCol(bool isDark, String label, String val) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
      const SizedBox(height: 4),
      Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    ],
  );
}
