import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';
import 'edit_profile_screen.dart';

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
                    // Use avatar_url if available, otherwise show initials.
                    // This pattern will work with the real API avatar_url later.
                    backgroundImage: user?.avatar != null
                        ? NetworkImage(user!.avatar!)
                        : null,
                    child: user?.avatar == null
                        ? Text(
                            user?.initials ?? 'U',
                            style: const TextStyle(
                              fontSize: 40,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
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
              _buildTile(isDark, Icons.person_outline, 'Edit Profile',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
              _buildTile(isDark, Icons.health_and_safety_outlined, 'Health Information',
                  onTap: () => _showHealthInfoSheet(context, isDark)),
              if (user?.role.name == 'doctor')
                _buildTile(isDark, Icons.calendar_month_outlined, 'My Schedule'),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, isDark, 'Preferences', [
              _buildTile(isDark, Icons.notifications_outlined, 'Notifications'),
              ListTile(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/notifications/ui/notifications_screen.dart');
                },
                leading: Icon(
                  Icons.dark_mode_outlined,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                trailing: Switch(
                  // Read from provider, not from Theme brightness, so it reflects
                  // the user's explicit choice (not the OS system theme).
                  value: ref.watch(themeModeProvider) == ThemeMode.dark,
                  onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
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
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }

  Widget _buildTile(bool isDark, IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      title: Text(title, style: TextStyle(fontFamily: 'Inter', color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
      trailing: Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
      onTap: onTap ?? () {},
    );
  }

  void _showHealthInfoSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HealthInfoSheet(isDark: isDark),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Health Information Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _HealthInfoSheet extends StatelessWidget {
  final bool isDark;
  const _HealthInfoSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.surfaceDark : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Health Information', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          Text('Your medical overview on file', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const SizedBox(height: 24),

          // Info grid
          Row(
            children: [
              Expanded(child: _HealthTile(icon: Icons.water_drop_rounded, color: AppColors.error, bg: AppColors.errorFaint, label: 'Blood Type', value: 'O+', isDark: isDark)),
              const SizedBox(width: 12),
              Expanded(child: _HealthTile(icon: Icons.height_rounded, color: AppColors.info, bg: AppColors.infoFaint, label: 'Height', value: '175 cm', isDark: isDark)),
              const SizedBox(width: 12),
              Expanded(child: _HealthTile(icon: Icons.monitor_weight_outlined, color: AppColors.warning, bg: AppColors.warningFaint, label: 'Weight', value: '78 kg', isDark: isDark)),
            ],
          ),
          const SizedBox(height: 16),

          _SectionLabel('Known Allergies', isDark),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ['Penicillin', 'Peanuts'].map((a) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.errorFaint, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withValues(alpha: 0.3))),
              child: Text(a, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error)),
            )).toList(),
          ),
          const SizedBox(height: 16),

          _SectionLabel('Chronic Conditions', isDark),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ['Hypertension', 'Type 2 Diabetes'].map((c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.warningFaint, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.warning.withValues(alpha: 0.3))),
              child: Text(c, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning)),
            )).toList(),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Close', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthTile extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  final String label, value;
  final bool isDark;
  const _HealthTile({required this.icon, required this.color, required this.bg, required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: bg.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.2))),
    child: Column(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
      Text(label, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
    ]),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel(this.text, this.isDark);

  @override
  Widget build(BuildContext context) => Text(text, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight));
}
