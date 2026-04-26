import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/tests_imaging_provider.dart';

class TestResultsScreen extends ConsumerWidget {
  const TestResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state  = ref.watch(testResultsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Lab Results', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
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
            ElevatedButton(onPressed: () => ref.invalidate(testResultsProvider), child: const Text('Retry')),
          ],
        )),
        data: (results) {
          if (results.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle), child: const Icon(Icons.science_rounded, size: 48, color: AppColors.primary)),
              const SizedBox(height: 20),
              Text('No Lab Results Yet', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text('Your lab results will appear here once\nyour doctor orders tests.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ),
            ]));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return GestureDetector(
                onTap: () => context.pushNamed(RouteNames.testResultDetail, pathParameters: {'id': item.id.toString()}),
                child: Container(
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
                      Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.primaryFaint, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.science_rounded, color: AppColors.primary, size: 26)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.primaryFaint, borderRadius: BorderRadius.circular(6)),
                              child: Text(item.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.4, color: AppColors.primary)),
                            ),
                            const SizedBox(height: 6),
                            Text(item.name, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                            const SizedBox(height: 4),
                            Text(item.lab, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Row(children: [
                              Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                              const SizedBox(width: 4),
                              Text(item.date, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                                child: Text(item.format, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                              ),
                              const Spacer(),
                              StatusBadge(status: item.testResultStatus.value, compact: true),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.borderDark : AppColors.textHintLight),
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
