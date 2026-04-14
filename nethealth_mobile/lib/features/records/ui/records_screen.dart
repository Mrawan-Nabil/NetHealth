import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> records = [
      {
        'title': 'General Checkup',
        'date': 'Oct 15, 2025',
        'doctor': 'Dr. Sara Ahmed',
        'hospital': 'City General Hospital',
        'type': 'Visit',
      },
      {
        'title': 'Blood Test & Vitals',
        'date': 'Sep 28, 2025',
        'doctor': 'Dr. Ali Hassan',
        'hospital': 'Nile Lab Diagnostics',
        'type': 'Test',
      },
      {
        'title': 'Cardiology Follow-up',
        'date': 'Aug 10, 2025',
        'doctor': 'Dr. Ayman Fathy',
        'hospital': 'City Heart Institute',
        'type': 'Visit',
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Medical Records',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          final isTest = record['type'] == 'Test';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
              ],
            ),
            child: ExpansionTile(
              shape: const Border(), // remove lines on expand
              iconColor: AppColors.primary,
              collapsedIconColor: isDark ? AppColors.textHintDark : AppColors.textHintLight,
              tilePadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isTest ? AppColors.warningFaint : AppColors.primaryFaint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isTest ? Icons.science_rounded : Icons.local_hospital_rounded,
                  color: isTest ? AppColors.warning : AppColors.primary,
                ),
              ),
              title: Text(
                record['title'],
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              subtitle: Text(
                record['date'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              children: [
                Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 18, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                          const SizedBox(width: 8),
                          Text(record['doctor'], style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                          const SizedBox(width: 8),
                          Text(record['hospital'], style: TextStyle(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('View Report'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
