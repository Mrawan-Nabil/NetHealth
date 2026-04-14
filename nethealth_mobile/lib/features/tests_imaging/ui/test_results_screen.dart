import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TestResultsScreen extends StatelessWidget {
  const TestResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> tests = [
      {'name': 'Hemoglobin', 'value': '13.5 g/dL', 'range': '12.0 - 15.5', 'status': 'Normal', 'color': AppColors.success},
      {'name': 'Cholesterol', 'value': '240 mg/dL', 'range': '< 200', 'status': 'High', 'color': AppColors.error},
      {'name': 'Vitamin D', 'value': '15 ng/mL', 'range': '20 - 50', 'status': 'Low', 'color': AppColors.warning},
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Blood Work Results', style: TextStyle(fontFamily: 'Outfit')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Oct 10, 2025', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Laboratory:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Nile Lab Diagnostics', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('Test Name', style: TextStyle(color: isDark ? AppColors.textHintDark : AppColors.textHintLight, fontSize: 12))),
                Expanded(child: Text('Result', style: TextStyle(color: isDark ? AppColors.textHintDark : AppColors.textHintLight, fontSize: 12))),
                Expanded(child: Text('Ref Range', style: TextStyle(color: isDark ? AppColors.textHintDark : AppColors.textHintLight, fontSize: 12))),
                SizedBox(width: 60, child: Text('Status', style: TextStyle(color: isDark ? AppColors.textHintDark : AppColors.textHintLight, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 12),
            ...tests.map((test) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(test['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text(test['value'], style: TextStyle(color: test['color'], fontWeight: FontWeight.bold))),
                  Expanded(child: Text(test['range'], style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                  SizedBox(
                    width: 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (test['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        test['status'].toUpperCase(),
                        style: TextStyle(fontSize: 10, color: test['color'], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download PDF Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryFaint,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
