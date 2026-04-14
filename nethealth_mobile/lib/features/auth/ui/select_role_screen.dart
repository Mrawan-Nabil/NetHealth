import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.goNamed(RouteNames.onboarding),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select your account type to get started. You can change this later if needed.',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Inter',
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildRoleCard(
                      context, 
                      isDark,
                      title: 'Patient',
                      desc: 'Book appointments, view records & results',
                      icon: Icons.person_rounded,
                      color: AppColors.info,
                      colorFaint: AppColors.infoFaint,
                      roleSlug: 'patient',
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context, 
                      isDark,
                      title: 'Doctor',
                      desc: 'Manage appointments, patients & prescriptions',
                      icon: Icons.medical_services_rounded,
                      color: AppColors.primary,
                      colorFaint: AppColors.primaryFaint,
                      roleSlug: 'doctor',
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context, 
                      isDark,
                      title: 'Clinic',
                      desc: 'Manage doctors, staff & facility operations',
                      icon: Icons.domain_rounded,
                      color: AppColors.warning,
                      colorFaint: AppColors.warningFaint,
                      roleSlug: 'clinic',
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context, 
                      isDark,
                      title: 'Pharmacy',
                      desc: 'Process prescriptions & manage inventory',
                      icon: Icons.local_pharmacy_rounded,
                      color: AppColors.success,
                      colorFaint: AppColors.successFaint,
                      roleSlug: 'pharmacy',
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, 
    bool isDark, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required Color colorFaint,
    required String roleSlug,
  }) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteNames.register, pathParameters: {'role': roleSlug});
      },
      child: Container(
        padding: const EdgeInsets.all(20),
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
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorFaint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Inter',
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.borderDark : AppColors.textHintLight,
            ),
          ],
        ),
      ),
    );
  }
}
