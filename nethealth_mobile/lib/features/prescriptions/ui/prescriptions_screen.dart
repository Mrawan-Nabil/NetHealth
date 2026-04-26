import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../providers/prescriptions_provider.dart';

class PrescriptionsScreen extends ConsumerWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state  = ref.watch(prescriptionsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Prescriptions', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(e.toString(), textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.invalidate(prescriptionsProvider), child: const Text('Retry')),
          ],
        )),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle), child: const Icon(Icons.medication_rounded, size: 48, color: AppColors.primary)),
                const SizedBox(height: 20),
                Text('No Prescriptions Yet', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item    = items[index];
              final isActive = item.isActive;

              return GestureDetector(
                onTap: () => context.pushNamed(RouteNames.prescriptionDetails, pathParameters: {'id': item.id.toString()}),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isActive ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)), width: isActive ? 1.5 : 1.0),
                    boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.medication_rounded, color: isActive ? AppColors.primary : AppColors.textHintLight),
                            const SizedBox(width: 8),
                            Text('RX-${item.id}', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                          ]),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: isActive ? AppColors.successFaint : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight), borderRadius: BorderRadius.circular(20)),
                            child: Text(isActive ? 'Active' : item.prescriptionStatus.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? AppColors.success : (isDark ? AppColors.textHintDark : AppColors.textHintLight))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Doctor', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                            const SizedBox(height: 4),
                            Text(item.doctor, style: const TextStyle(fontSize: 14)),
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Date', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                            const SizedBox(height: 4),
                            Text(item.date, style: const TextStyle(fontSize: 14)),
                          ]),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
