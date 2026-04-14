import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryFaint,
                    backgroundImage: user?.role.name == 'doctor' 
                        ? const NetworkImage('https://i.pravatar.cc/150?img=11') 
                        : null,
                    child: user?.role.name != 'doctor' 
                        ? Text(
                            user?.initials ?? 'U',
                            style: const TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? 'User Name',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'user@example.com',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(context, isDark, 'Personal', [
              _buildTile(isDark, Icons.person_outline, 'Edit Profile'),
              _buildTile(isDark, Icons.health_and_safety_outlined, 'Health Information'),
              if (user?.role.name == 'doctor')
                _buildTile(isDark, Icons.calendar_month_outlined, 'My Schedule'),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, isDark, 'Preferences', [
              _buildTile(isDark, Icons.notifications_outlined, 'Notifications'),
              ListTile(
                leading: Icon(Icons.dark_mode_outlined, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                title: Text('Dark Mode', style: TextStyle(fontFamily: 'Inter', color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) {
                    // Update theme mode handled by external provider usually
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, isDark, 'Other', [
              _buildTile(isDark, Icons.help_outline, 'Help & Support'),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Log Out', style: TextStyle(fontFamily: 'Inter', color: AppColors.error, fontWeight: FontWeight.bold)),
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                },
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, bool isDark, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5)),
          ),
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }

  Widget _buildTile(bool isDark, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      title: Text(title, style: TextStyle(fontFamily: 'Inter', color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
      trailing: Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
      onTap: () {},
    );
  }
}
