import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/tests_imaging_provider.dart';

class ImageViewerScreen extends ConsumerWidget {
  final String id;
  const ImageViewerScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imagingDetailProvider(id));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: state.when(
          data: (d) => Text(d.title, style: const TextStyle(color: Colors.white, fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
          loading: () => const Text('Loading…', style: TextStyle(color: Colors.white70, fontFamily: 'Outfit')),
          error: (_, __) => const Text('Imaging Detail', style: TextStyle(color: Colors.white, fontFamily: 'Outfit')),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.download_rounded, color: Colors.white), tooltip: 'Download', onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_rounded, color: Colors.white), tooltip: 'Share', onPressed: () {}),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            Text(e.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontFamily: 'Inter')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.invalidate(imagingDetailProvider(id)), child: const Text('Retry')),
          ],
        )),
        data: (detail) {
          final imageUrl = detail.primaryImageUrl;
          return Column(
            children: [
              // ── Viewer ──────────────────────────────────────────────────
              Expanded(
                flex: 3,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.5,
                        maxScale: 6.0,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          loadingBuilder: (ctx, child, chunk) {
                            if (chunk == null) return child;
                            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                          },
                          errorBuilder: (ctx, err, st) => const Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported_rounded, color: Colors.white54, size: 48),
                              SizedBox(height: 12),
                              Text('Image unavailable', style: TextStyle(color: Colors.white54, fontFamily: 'Inter')),
                            ],
                          )),
                        ),
                      )
                    : const Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_rounded, color: Colors.white54, size: 48),
                          SizedBox(height: 12),
                          Text('No image available', style: TextStyle(color: Colors.white54, fontFamily: 'Inter')),
                        ],
                      )),
              ),

              // ── Metadata panel ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0xFF1E293B), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(detail.title, style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                      const Spacer(),
                      StatusBadge(status: detail.testResultStatus.value),
                    ]),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primaryFaint.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.primary.withValues(alpha: 0.4))),
                      child: Text(detail.type.toUpperCase(), style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primaryLight)),
                    ),
                    const SizedBox(height: 12),
                    if (detail.fileInfo != null) ...[
                      _MetaRow(icon: Icons.calendar_today_rounded, text: detail.fileInfo!.scanDate),
                      const SizedBox(height: 4),
                      _MetaRow(icon: Icons.person_outline_rounded, text: detail.fileInfo!.physician),
                      const SizedBox(height: 4),
                      _MetaRow(icon: Icons.location_on_outlined, text: detail.fileInfo!.radiologyCenter),
                      const SizedBox(height: 4),
                      _MetaRow(icon: Icons.insert_drive_file_outlined, text: '${detail.fileInfo!.format}  •  ${detail.fileInfo!.size}'),
                    ],
                    if (detail.notes != null && detail.notes!.physicianInterpretation.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      const Text("Physician's Interpretation", style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text(detail.notes!.physicianInterpretation, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white60, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 14, color: Colors.white54),
    const SizedBox(width: 8),
    Expanded(child: Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white60), overflow: TextOverflow.ellipsis)),
  ]);
}
