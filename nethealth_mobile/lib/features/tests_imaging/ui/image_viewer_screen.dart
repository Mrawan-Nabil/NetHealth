import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ImageViewerScreen
//
// Receives [id] from the router (via imaging list). Displays a pinch-to-zoom
// image viewer with a metadata panel and download action.
// The hardcoded image URL and title will be replaced by API data in Phase 2.
// ─────────────────────────────────────────────────────────────────────────────

class ImageViewerScreen extends StatelessWidget {
  final String id;
  const ImageViewerScreen({super.key, required this.id});

  // Mock data — keyed by id for demonstration
  static const _mockData = {
    '1': _ImagingMock(title: 'Chest X-Ray', modality: 'X-RAY', date: 'Oct 10, 2025', physician: 'Dr. Ayman Fathy', interpretation: 'Lung fields are clear. Cardiac silhouette is within normal limits. No pleural effusions or pneumothorax identified.', status: 'reviewed'),
    '2': _ImagingMock(title: 'Brain MRI',   modality: 'MRI',   date: 'Aug 22, 2025', physician: 'Dr. Ali Hassan',  interpretation: 'No intracranial haemorrhage or acute infarction. Ventricles are normal in size. Brain parenchyma appears normal.', status: 'reviewed'),
  };

  static const _fallback = _ImagingMock(title: 'Medical Scan', modality: 'SCAN', date: '—', physician: '—', interpretation: 'Physician interpretation pending.', status: 'pending');

  @override
  Widget build(BuildContext context) {
    final mock = _mockData[id] ?? _fallback;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          mock.title,
          style: const TextStyle(color: Colors.white, fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            tooltip: 'Download',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            tooltip: 'Share',
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Viewer ────────────────────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 6.0,
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Chest_X-ray_in_influenza_and_Haemophilus_influenzae.jpg/640px-Chest_X-ray_in_influenza_and_Haemophilus_influenzae.jpg',
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (ctx, child, chunk) {
                  if (chunk == null) return child;
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                },
                errorBuilder: (ctx, error, st) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported_rounded, color: Colors.white54, size: 48),
                      SizedBox(height: 12),
                      Text('Image unavailable', style: TextStyle(color: Colors.white54, fontFamily: 'Inter')),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Metadata panel ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      mock.title,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    StatusBadge(status: mock.status),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFaint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    mock.modality,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _MetaRow(icon: Icons.calendar_today_rounded,  text: mock.date),
                const SizedBox(height: 4),
                _MetaRow(icon: Icons.person_outline_rounded,  text: mock.physician),
                const SizedBox(height: 14),
                const Text(
                  "Physician's Interpretation",
                  style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  mock.interpretation,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white60, height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white54),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white60)),
      ],
    );
  }
}

// ── Mock data model ────────────────────────────────────────────────────────────

class _ImagingMock {
  final String title;
  final String modality;
  final String date;
  final String physician;
  final String interpretation;
  final String status;

  const _ImagingMock({
    required this.title,
    required this.modality,
    required this.date,
    required this.physician,
    required this.interpretation,
    required this.status,
  });
}
