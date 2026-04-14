import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/nh_app_bar.dart';
import '../../../shared/widgets/nh_button.dart';
import '../../../core/theme/app_text_styles.dart';

/// Placeholder — full implementation in Phase 2
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const NhAppBar(title: 'Edit Profile'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Edit Profile', style: AppTextStyles.headlineMedium(context)),
              const SizedBox(height: 8),
              Text(
                'Full implementation coming in Phase 2',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              NhButton(
                label: 'Go Back',
                onPressed: () => Navigator.of(context).pop(),
                variant: NhButtonVariant.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
