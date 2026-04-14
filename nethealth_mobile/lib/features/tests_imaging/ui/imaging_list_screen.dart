import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ImagingListScreen
//
// Lists all imaging attachment records (X-Ray, MRI, CT, etc.) with a modality
// badge. Tapping a card opens ImageViewerScreen with the record id.
// ─────────────────────────────────────────────────────────────────────────────

class ImagingListScreen extends StatelessWidget {
  const ImagingListScreen({super.key});

  static const _items = [
    _ImagingItem(id: '1', title: 'Chest X-Ray',           modality: 'X-RAY',     date: 'Oct 10, 2025', physician: 'Dr. Ayman Fathy',  clinic: 'City Heart Institute',   status: 'reviewed'),
    _ImagingItem(id: '2', title: 'Brain MRI',              modality: 'MRI',       date: 'Aug 22, 2025', physician: 'Dr. Ali Hassan',   clinic: 'NeuroMed Institute',     status: 'reviewed'),
    _ImagingItem(id: '3', title: 'Abdominal CT Scan',      modality: 'CT SCAN',   date: 'Jun 14, 2025', physician: 'Dr. Sara Ahmed',   clinic: 'City General Hospital',  status: 'pending'),
    _ImagingItem(id: '4', title: 'Echocardiogram',         modality: 'ECHO',      date: 'Mar 05, 2025', physician: 'Dr. Ayman Fathy',  clinic: 'City Heart Institute',   status: 'reviewed'),
    _ImagingItem(id: '5', title: 'Left Knee Ultrasound',   modality: 'ULTRASOUND',date: 'Jan 18, 2025', physician: 'Dr. Nadia Karim',  clinic: 'Nile Orthopedic Center', status: 'reviewed'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Imaging', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) => _ImagingCard(item: _items[index], isDark: isDark),
      ),
    );
  }
}

// ── Card widget ───────────────────────────────────────────────────────────────

class _ImagingCard extends StatelessWidget {
  final _ImagingItem item;
  final bool isDark;

  const _ImagingCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final (iconData, iconColor, iconBg) = _modalityIcon(item.modality);

    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.imageViewer,
        pathParameters: {'id': item.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Modality icon ────────────────────────────────────────────────
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),

            // ── Info ─────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // modality pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.modality,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: iconColor,
                          ),
                        ),
                      ),
                      StatusBadge(status: item.status, compact: true),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dr. ${item.physician.replaceFirst('Dr. ', '')}  •  ${item.clinic}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                      const SizedBox(width: 4),
                      Text(
                        item.date,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.borderDark : AppColors.textHintLight),
          ],
        ),
      ),
    );
  }

  (IconData, Color, Color) _modalityIcon(String modality) => switch (modality) {
    'MRI'       => (Icons.blender_outlined,         AppColors.primary,    AppColors.primaryFaint),
    'CT SCAN'   => (Icons.crop_rotate_rounded,       AppColors.info,       AppColors.infoFaint),
    'X-RAY'     => (Icons.image_outlined,            AppColors.warning,    AppColors.warningFaint),
    'ECHO'      => (Icons.favorite_border_rounded,   AppColors.error,      AppColors.errorFaint),
    'ULTRASOUND'=> (Icons.waves_rounded,             AppColors.statusPending, AppColors.warningFaint),
    _           => (Icons.medical_services_outlined, AppColors.primary,    AppColors.primaryFaint),
  };
}

// ── Mock data model ───────────────────────────────────────────────────────────
class _ImagingItem {
  final String id;
  final String title;
  final String modality;
  final String date;
  final String physician;
  final String clinic;
  final String status;

  const _ImagingItem({
    required this.id,
    required this.title,
    required this.modality,
    required this.date,
    required this.physician,
    required this.clinic,
    required this.status,
  });
}
