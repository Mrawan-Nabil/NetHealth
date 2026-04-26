import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/visit_history_provider.dart';

class VisitHistoryScreen extends ConsumerWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state  = ref.watch(visitHistoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Visit History', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
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
            ElevatedButton(onPressed: () => ref.invalidate(visitHistoryProvider), child: const Text('Retry')),
          ],
        )),
        data: (visits) {
          if (visits.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle), child: const Icon(Icons.history_rounded, size: 48, color: AppColors.primary)),
              const SizedBox(height: 20),
              Text('No Visits Yet', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const SizedBox(height: 8),
              Text('Your appointment history will appear here.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            ]));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];
              return GestureDetector(
                onTap: () => context.pushNamed(RouteNames.appointmentDetail, pathParameters: {'id': visit.id.toString()}),
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
                            Icon(Icons.calendar_today_rounded, size: 14, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                            const SizedBox(width: 6),
                            Text(visit.date, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                          ]),
                          StatusBadge(status: visit.appointmentStatus.value, compact: true),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(visit.doctorName, style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                      const SizedBox(height: 2),
                      Text(visit.specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      const SizedBox(height: 10),
                      Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      const SizedBox(height: 8),
                      Row(children: [
                        Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                        const SizedBox(width: 6),
                        Expanded(child: Text(visit.clinic, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                        const SizedBox(width: 8),
                        StatusBadge(status: visit.appointmentType.value, compact: true),
                      ]),
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
