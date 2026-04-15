import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TestResultsScreen  (OVERHAULED — Phase 2)
//
// Correct paradigm: a list of file attachment cards (PDFs/images), NOT a
// numeric lab-value table. Each card shows the test name, issuing lab, date
// ordered, and file-availability status. Tapping opens TestResultDetailScreen.
// ─────────────────────────────────────────────────────────────────────────────

class TestResultsScreen extends StatelessWidget {
  const TestResultsScreen({super.key});

  static const _results = [
    _TestResultItem(
      id: '1',
      name: 'Full Blood Count (FBC)',
      category: 'Haematology',
      lab: 'City General Laboratory',
      date: 'Oct 10, 2025',
      status: 'reviewed',
      format: 'PDF',
    ),
    _TestResultItem(
      id: '2',
      name: 'Urine Analysis (UA)',
      category: 'Urinalysis',
      lab: 'Nile Lab Diagnostics',
      date: 'Sep 22, 2025',
      status: 'reviewed',
      format: 'PDF',
    ),
    _TestResultItem(
      id: '3',
      name: 'Lipid Panel',
      category: 'Biochemistry',
      lab: 'City Heart Institute Lab',
      date: 'Aug 14, 2025',
      status: 'pending',
      format: 'PDF',
    ),
    _TestResultItem(
      id: '4',
      name: 'HbA1c (Glycated Haemoglobin)',
      category: 'Endocrinology',
      lab: 'MedCore Diagnostics',
      date: 'Jun 05, 2025',
      status: 'reviewed',
      format: 'PDF',
    ),
    _TestResultItem(
      id: '5',
      name: 'Thyroid Function Test (TFT)',
      category: 'Endocrinology',
      lab: 'City General Laboratory',
      date: 'Mar 20, 2025',
      status: 'reviewed',
      format: 'PDF',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Lab Results', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _results.isEmpty
          ? _EmptyState(isDark: isDark)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              itemBuilder: (context, index) =>
                  _TestResultCard(item: _results[index], isDark: isDark),
            ),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _TestResultCard extends StatelessWidget {
  final _TestResultItem item;
  final bool isDark;

  const _TestResultCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteNames.testResultDetail,
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
            // ── File icon ──────────────────────────────────────────────────
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryFaint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.science_rounded, color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 14),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFaint,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Test name
                  Text(
                    item.name,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Lab name
                  Text(
                    item.lab,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Date + format + status row
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                      const SizedBox(width: 4),
                      Text(
                        item.date,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.format,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                      const Spacer(),
                      StatusBadge(status: item.status, compact: true),
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
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.primaryFaint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.science_rounded, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'No Lab Results Yet',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your lab results will appear here once\nyour doctor orders tests.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mock data model ───────────────────────────────────────────────────────────

class _TestResultItem {
  final String id;
  final String name;
  final String category;
  final String lab;
  final String date;
  final String status;
  final String format;

  const _TestResultItem({
    required this.id,
    required this.name,
    required this.category,
    required this.lab,
    required this.date,
    required this.status,
    required this.format,
  });
}
