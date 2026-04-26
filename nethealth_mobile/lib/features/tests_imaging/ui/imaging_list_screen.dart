import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/tests_imaging_provider.dart';

class ImagingListScreen extends ConsumerWidget {
  const ImagingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state  = ref.watch(imagingProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Imaging', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
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
            Text(e.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.invalidate(imagingProvider), child: const Text('Retry')),
          ],
        )),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle), child: const Icon(Icons.image_outlined, size: 48, color: AppColors.primary)),
              const SizedBox(height: 20),
              Text('No Imaging Records Yet', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ]));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final (iconData, iconColor, iconBg) = _modalityIcon(item.type);

              return GestureDetector(
                onTap: () => context.pushNamed(RouteNames.imageViewer, pathParameters: {'id': item.id.toString()}),
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
                      Container(width: 52, height: 52, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)), child: Icon(iconData, color: iconColor, size: 26)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                                  child: Text(item.type.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: iconColor)),
                                ),
                                StatusBadge(status: item.testResultStatus.value, compact: true),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(item.title, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                            const SizedBox(height: 4),
                            Text('${item.physician}  •  ${item.hospital}', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                              const SizedBox(width: 4),
                              Text(item.scanDate, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
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

  (IconData, Color, Color) _modalityIcon(String type) => switch (type.toUpperCase()) {
    'MRI'        => (Icons.blender_outlined,         AppColors.primary,       AppColors.primaryFaint),
    'CT SCAN'    => (Icons.crop_rotate_rounded,       AppColors.info,          AppColors.infoFaint),
    'X-RAY'      => (Icons.image_outlined,            AppColors.warning,       AppColors.warningFaint),
    'ECHO' || 'ULTRASOUND' => (Icons.favorite_border_rounded, AppColors.error, AppColors.errorFaint),
    _            => (Icons.medical_services_outlined, AppColors.primary,       AppColors.primaryFaint),
  };
}
