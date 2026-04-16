import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/models/doctor_booking_model.dart';
import '../../../shared/widgets/doctor_avatar.dart';
import '../providers/appointments_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BookingFormScreen
// Step 2 of 2: pick date/time + enter visit reason, then POST to the API.
// ─────────────────────────────────────────────────────────────────────────────

class BookingFormScreen extends ConsumerStatefulWidget {
  final DoctorModel doctor;

  const BookingFormScreen({super.key, required this.doctor});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _submitting = false;
  String? _errorMsg;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  // ── Pick date ─────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now   = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── Pick time ─────────────────────────────────────────────────────────────

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // ── Submit booking ────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDate == null || _selectedTime == null) {
      setState(() => _errorMsg = 'Please select both a date and a time.');
      return;
    }

    // Build ISO 8601 datetime string from the pickers
    final dt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    setState(() {
      _submitting = true;
      _errorMsg   = null;
    });

    try {
      final repo = ref.read(appointmentsRepositoryProvider);
      await repo.bookAppointment({
        'doctor_id':        widget.doctor.id,
        'appointment_time': dt.toIso8601String(),
        'visit_reason':     _reasonCtrl.text.trim(),
        'appointment_type': 'in_person',
      });

      // Invalidate the list so AppointmentsScreen auto-refreshes
      ref.invalidate(appointmentsProvider);

      if (!mounted) return;

      // Show success dialog then navigate to appointments tab
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMsg   = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.successFaint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.statusCompleted, size: 48),
              ),
              const SizedBox(height: 20),
              const Text(
                'Appointment Booked\nSuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your appointment has been confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 20),
              // Doctor card inside dialog
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryFaint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    DoctorAvatar(doctor: widget.doctor, radius: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.displayName,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          widget.doctor.specialty.isNotEmpty
                              ? widget.doctor.specialty
                              : 'Specialist',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.primaryDark.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Pop back to root of navigation then go to appointments tab
                    context.goNamed(RouteNames.appointments);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'View My Appointments',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final doctor   = widget.doctor;

    final dateLabel = _selectedDate != null
        ? DateFormat('EEE, MMM d y').format(_selectedDate!)
        : 'Select Date';
    final timeLabel = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'Select Time';

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        leading: const BackButton(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Doctor summary ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryFaint,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    DoctorAvatar(doctor: doctor, radius: 30),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.displayName,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doctor.specialty.isNotEmpty
                                ? doctor.specialty
                                : 'General Practitioner',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.primaryDark.withValues(alpha: 0.7),
                            ),
                          ),
                          if (doctor.consultationFee != null &&
                              doctor.consultationFee!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Consultation: EGP ${doctor.consultationFee}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Date & Time pickers ────────────────────────────────────
              _SectionTitle('Appointment Date & Time', isDark),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _PickerTile(
                      icon: Icons.calendar_today_rounded,
                      label: 'Date',
                      value: dateLabel,
                      onTap: _pickDate,
                      isDark: isDark,
                      hasValue: _selectedDate != null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PickerTile(
                      icon: Icons.access_time_rounded,
                      label: 'Time',
                      value: timeLabel,
                      onTap: _pickTime,
                      isDark: isDark,
                      hasValue: _selectedTime != null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Visit reason ───────────────────────────────────────────
              _SectionTitle('Visit Reason', isDark),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reasonCtrl,
                maxLines: 4,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Describe your symptoms or reason for the visit…',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    color: isDark
                        ? AppColors.textHintDark
                        : AppColors.textHintLight,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter a visit reason.';
                  }
                  if (v.trim().length < 5) {
                    return 'Please provide more detail.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Error ─────────────────────────────────────────────────
              if (_errorMsg != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.errorFaint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMsg!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // ── Submit ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.5),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionTitle(this.text, this.isDark);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      );
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isDark;
  final bool hasValue;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.isDark,
    required this.hasValue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasValue
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 16,
                    color: hasValue
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.textHintDark
                            : AppColors.textHintLight)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textHintDark
                        : AppColors.textHintLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: hasValue
                    ? (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight)
                    : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
