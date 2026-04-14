import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final notifications = [
      {'title': 'Appointment Confirmed', 'msg': 'Your appointment with Dr. Ayman is set for tomorrow at 10 AM.', 'time': '2m ago', 'icon': Icons.calendar_today_rounded, 'color': AppColors.statusScheduled, 'unread': true},
      {'title': 'New Test Results', 'msg': 'Your blood work results from Nile Lab are ready to view.', 'time': '1h ago', 'icon': Icons.science_rounded, 'color': AppColors.statusCompleted, 'unread': true},
      {'title': 'Prescription Refill', 'msg': 'Time to refill Amoxicillin 500mg. Tap to request from pharmacy.', 'time': 'Yesterday', 'icon': Icons.medication_rounded, 'color': AppColors.warning, 'unread': false},
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final unread = notif['unread'] as bool;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: unread ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight) : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: unread ? (AppColors.primary.withOpacity(0.5)) : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              boxShadow: [
                if (unread && !isDark)
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (notif['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notif['icon'] as IconData, color: notif['color'] as Color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'] as String,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                                fontSize: 16,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                          if (unread)
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['msg'] as String,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
