import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/profile_provider.dart';
import '../../../shared/widgets/nh_avatar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EditProfileScreen
// ─────────────────────────────────────────────────────────────────────────────

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;
  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).valueOrNull;
    _nameCtrl = TextEditingController(text: profile?.fullName ?? '');
    _emailCtrl = TextEditingController(text: profile?.email ?? '');
    _phoneCtrl = TextEditingController(text: profile?.phone ?? '');
    _dobCtrl = TextEditingController(text: profile?.birthDate ?? '');
    _selectedGender = profile?.gender.name.toLowerCase() ?? 'male';
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _dobCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileState = ref.watch(profileProvider);
    final profile = profileState.valueOrNull;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (profileState.isLoading)
            const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
          else
            TextButton(
              onPressed: _save,
              child: const Text('Save', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar editor
              Center(
                child: Stack(
                  children: [
                    NhAvatar(
                      imageUrl: profile?.avatarUrl,
                      fallbackName: profile?.fullName ?? 'U',
                      radius: 52,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Tap to change photo', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primary)),
              ),
              const SizedBox(height: 28),

              _sectionTitle('Personal Information', isDark),
              const SizedBox(height: 14),

              _Field(controller: _nameCtrl,  label: 'Full Name',    icon: Icons.person_outline_rounded,  isDark: isDark, validator: _required),
              const SizedBox(height: 14),
              _Field(controller: _emailCtrl, label: 'Email Address', icon: Icons.mail_outline_rounded,   isDark: isDark, keyboardType: TextInputType.emailAddress, validator: _required),
              const SizedBox(height: 14),
              _Field(controller: _phoneCtrl, label: 'Phone Number', icon: Icons.phone_outlined,          isDark: isDark, keyboardType: TextInputType.phone, validator: _required),
              const SizedBox(height: 14),
              _Field(controller: _dobCtrl,   label: 'Date of Birth', icon: Icons.cake_outlined,          isDark: isDark),
              const SizedBox(height: 14),

              // Gender selector
              Text('Gender', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
              const SizedBox(height: 8),
              Row(
                children: ['male', 'female'].map((g) {
                  final isSelected = _selectedGender == g;
                  final displayLabel = g == 'male' ? 'Male' : 'Female';
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGender = g),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight)),
                        ),
                        child: Text(displayLabel, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 12, color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? v) => (v == null || v.isEmpty) ? 'This field is required' : null;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      try {
        await ref.read(profileProvider.notifier).updateAvatar(File(xFile.path));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avatar updated!'), backgroundColor: AppColors.primary));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload avatar: $e'), backgroundColor: AppColors.error));
        }
      }
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final data = {
          'full_name': _nameCtrl.text,
          'phone': _phoneCtrl.text,
          'birth_date': _dobCtrl.text.isNotEmpty ? _dobCtrl.text : null,
          'gender': _selectedGender,
        };
        await ref.read(profileProvider.notifier).updateProfile(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully!', style: TextStyle(fontFamily: 'Inter')),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
        }
      }
    }
  }
}

Widget _sectionTitle(String title, bool isDark) => Text(
  title,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
  ),
);

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18),
        ),
      );
}
