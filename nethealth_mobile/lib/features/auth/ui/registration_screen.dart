import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_names.dart';

class RegistrationScreen extends StatefulWidget {
  final String role;
  const RegistrationScreen({super.key, required this.role});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageCtrl = PageController();
  int _currentStep = 0;

  late List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _getStepsForRole(widget.role);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getStepsForRole(String role) {
    if (role == 'patient') {
      return [
        {'title': 'Account Setup', 'fields': ['NameRow', 'Email Address', 'Password', 'Confirm Password']},
        {'title': 'Personal Details', 'fields': ['Phone Number', 'Date of Birth', 'Gender', 'Governorate', 'National ID']},
        {'title': 'Medical Profile', 'fields': ['Blood Type', 'Allergies', 'Chronic Conditions', 'Emergency Contact Name', 'Emergency Contact Phone']},
      ];
    } else if (role == 'doctor') {
      return [
        {'title': 'Account Setup', 'fields': ['NameRow', 'Email Address', 'Password', 'Confirm Password']},
        {'title': 'Personal Details', 'fields': ['Phone Number', 'Date of Birth', 'Gender', 'Governorate']},
        {'title': 'Professional Profile', 'fields': ['Medical License Number', 'Specialty', 'Experience', 'Qualification', 'Verification Documents']},
      ];
    } else if (role == 'clinic') {
      return [
        {'title': 'Admin Account', 'fields': ['NameRow', 'Email Address', 'Password', 'Confirm Password']},
        {'title': 'Admin Details', 'fields': ['Phone Number', 'Date of Birth', 'Gender', 'Governorate', 'National ID']},
        {'title': 'Clinic Profile', 'fields': ['Clinic Name', 'Clinic Type', 'Clinic Landline/Phone', 'Clinic Governorate', 'Full Clinic Address', 'MoH License Number', 'CommercialTaxRow', 'Verification Documents']},
      ];
    } else {
      return [
        {'title': 'Admin Account', 'fields': ['NameRow', 'Email Address', 'Password', 'Confirm Password']},
        {'title': 'Admin Details', 'fields': ['Phone Number', 'Date of Birth', 'Gender', 'Governorate', 'National ID']},
        {'title': 'Pharmacy Profile', 'fields': ['Pharmacy Name', 'Pharmacy Landline/Phone', 'Pharmacy Governorate', 'Full Pharmacy Address', 'MoH License Number', 'CommercialTaxRow', 'Verification Documents']},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String mainTitle = 'Create Account';
    String subTitle = '${widget.role[0].toUpperCase()}${widget.role.substring(1)} Registration';

    if (widget.role == 'clinic') {
      mainTitle = 'Register Clinic';
      subTitle = 'Create your admin account and register your facility';
    } else if (widget.role == 'pharmacy') {
      mainTitle = 'Register Pharmacy';
      subTitle = 'Create your admin account and register your business';
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Premium Custom Header with Back Button
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 24, top: 16, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    onPressed: () => context.pop(), // Returns to SelectRoleScreen
                    tooltip: 'Back to Role Selection',
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mainTitle,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStepper(isDark),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_currentStep),
                  child: _buildFormStep(context, isDark, _steps[_currentStep]),
                ),
              ),
            ),
            _buildBottomControls(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length * 2 - 1, (index) {
              if (index % 2 == 1) {
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }
              final stepIndex = index ~/ 2;
              final isActive = stepIndex <= _currentStep;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isActive ? AppColors.primary : (isDark ? AppColors.borderDark : Colors.grey.shade300),
                    width: 1.5,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : (isDark ? AppColors.textHintDark : Colors.grey.shade500),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_steps.length, (index) {
              final isActive = index == _currentStep;
              return Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.primary : (isDark ? AppColors.textHintDark : Colors.grey.shade500),
                  ),
                  textAlign: TextAlign.center,
                  child: Text(_steps[index]['title']),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFormStep(BuildContext context, bool isDark, Map<String, dynamic> stepData) {
    final List<String> fields = stepData['fields'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields.map((field) {
          if (field == 'NameRow') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(child: _buildInput(isDark, 'First Name', prefixIcon: Icons.person_outline)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInput(isDark, 'Second Name', prefixIcon: Icons.person_outline)),
                ],
              ),
            );
          }
          if (field == 'CommercialTaxRow') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(child: _buildInput(isDark, 'Commercial Registration No')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInput(isDark, 'Tax ID')),
                ],
              ),
            );
          }
          if (field == 'Verification Documents') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildDropzone(isDark),
            );
          }
          final isPassword = field.contains('Password');
          final isDropdown = ['Gender', 'Governorate', 'Blood Type', 'Clinic Type', 'Clinic Governorate', 'Pharmacy Governorate'].contains(field);
          final label = field == 'Date of Birth' ? field : field; // Can customize
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildInput(
              isDark, 
              label, 
              isPassword: isPassword,
              isDropdown: isDropdown,
              isDate: field == 'Date of Birth',
              prefixIcon: field == 'Email Address' ? Icons.email_outlined : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropzone(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Documents (Moh License, Admin ID)',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark.withOpacity(0.5) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.5),
              width: 1.5,
              style: BorderStyle.solid, // Flutter doesn't have dashed border built-in, but we can simulate or use solid for now
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.file_upload_outlined, color: AppColors.primary, size: 28),
              const SizedBox(height: 12),
              Text(
                'Drop files here or click to upload',
                style: TextStyle(color: isDark ? AppColors.textPrimaryDark : Colors.black87, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'PDF, JPG, PNG',
                style: TextStyle(color: isDark ? AppColors.textHintDark : Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInput(bool isDark, String label, {bool isPassword = false, bool isDropdown = false, bool isDate = false, IconData? prefixIcon}) {
    IconData? endIcon;
    if (isPassword) endIcon = Icons.visibility_outlined;
    if (isDropdown) endIcon = Icons.keyboard_arrow_down_rounded;
    if (isDate) endIcon = Icons.calendar_today_outlined;

    Widget? prefix;
    if (label.contains('Phone')) {
      prefix = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8),
            child: Text('🇪🇬 +20', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : Colors.black87)),
          ),
          Container(width: 1, height: 24, color: isDark ? AppColors.borderDark : Colors.grey.shade300, margin: const EdgeInsets.only(right: 12)),
        ],
      );
    } else if (prefixIcon != null) {
      prefix = Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Icon(prefixIcon, color: AppColors.primary, size: 20),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}',
            hintStyle: TextStyle(
              fontSize: 15,
              color: isDark ? AppColors.textHintDark : Colors.grey.shade400,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            suffixIcon: endIcon != null ? Icon(endIcon, color: isDark ? AppColors.textHintDark : Colors.grey.shade500, size: 22) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 10)
        ],
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade300, width: 1.5),
                      foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    onPressed: () {
                      setState(() => _currentStep--);
                    },
                    child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_currentStep < _steps.length - 1) {
                      setState(() => _currentStep++);
                    } else {
                      context.goNamed(RouteNames.registerSuccess);
                    }
                  },
                  child: Text(_currentStep == _steps.length - 1 ? 'Finish Registration' : 'Next Step', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? ', style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              GestureDetector(
                onTap: () => context.goNamed(RouteNames.login),
                child: const Text(
                  'Login',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
