import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> items = [
      {
        'id': 'RX-10294',
        'date': 'Oct 15, 2025',
        'doctor': 'Dr. Sara Ahmed',
        'status': 'Active',
      },
      {
        'id': 'RX-89432',
        'date': 'Aug 10, 2025',
        'doctor': 'Dr. Ayman Fathy',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Prescriptions',
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isActive = item['status'] == 'Active';

          return GestureDetector(
            onTap: () {
              context.pushNamed(RouteNames.prescriptionDetails);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5)),
                  width: isActive ? 1.5 : 1.0,
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.medication_rounded, color: isActive ? AppColors.primary : AppColors.textHintLight),
                          const SizedBox(width: 8),
                          Text(
                            item['id'],
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.successFaint : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isActive ? AppColors.success : (isDark ? AppColors.textHintDark : AppColors.textHintLight),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Doctor', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                          const SizedBox(height: 4),
                          Text(item['doctor'], style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                          const SizedBox(height: 4),
                          Text(item['date'], style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const Icon(Icons.chevron_right_rounded)
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
