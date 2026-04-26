import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/doctor_booking_model.dart';
import '../providers/appointments_provider.dart';
import '../../../core/utils/file_picker_util.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DoctorDetailsScreen — Step 1: Doctor Profile + Schedule Selection
// ─────────────────────────────────────────────────────────────────────────────

class DoctorDetailsScreen extends ConsumerStatefulWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  ConsumerState<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends ConsumerState<DoctorDetailsScreen> {
  // ── Scheduling state ────────────────────────────────────────────────────────
  int    _selectedDayIndex  = 4; // Default Friday (matches web reference)
  String _selectedTime      = '10:00 AM';
  int    _selectedTypeIndex = 2; // Default Emergency Visit (matches web reference)

  late final List<_DaySlot> _days;

  static const _times = [
    '09:00 AM', '09:30 AM', '10:00 AM', '11:30 AM',
    '02:00 PM', '03:00 PM',
  ];

  static const _unavailableTimes = {'09:30 AM', '11:30 AM'};

  // Matches web UI: Clinic Visit / Online Medical Consultation / Emergency Visit
  static const _appointmentTypes = [
    _ApptType(
      icon: Icons.local_hospital_rounded,
      title: 'Clinic Visit',
      subtitle: 'In-person consultation',
      badge: 'physical',
    ),
    _ApptType(
      icon: Icons.videocam_rounded,
      title: 'Online Medical Consultation',
      subtitle: 'Online Lab & Imaging Consultation',
      badge: 'remote',
    ),
    _ApptType(
      icon: Icons.warning_rounded,
      title: 'Emergency Visit',
      subtitle: 'Urgent immediate care',
      badge: 'emergency',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _days = _computeUpcomingDays();
  }

  /// Computes actual upcoming Mon–Sat dates from the next Monday.
  List<_DaySlot> _computeUpcomingDays() {
    final now = DateTime.now();
    int offset = (DateTime.monday - now.weekday + 7) % 7;
    if (offset == 0) offset = 7; // always move to next Monday
    final monday = now.add(Duration(days: offset));
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return List.generate(6, (i) {
      final d = monday.add(Duration(days: i));
      return _DaySlot(day: names[i], dateLabel: d.day.toString(), date: d);
    });
  }

  _DaySlot  get _day  => _days[_selectedDayIndex];
  _ApptType get _type => _appointmentTypes[_selectedTypeIndex];

  // ── Opens the Patient Info Modal (Step 2) ───────────────────────────────────
  void _showPatientInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PatientInfoModal(
        doctor: widget.doctor,
        selectedDay: _day,
        selectedTimeLabel: _selectedTime,
        appointmentTypeName: _type.title,
        appointmentTypeValue: _type.badge,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doc    = widget.doctor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DoctorSliverAppBar(doctor: doc, isDark: isDark),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats row ─────────────────────────────────────────────
                  _StatsRow(doctor: doc, isDark: isDark),
                  const SizedBox(height: 24),

                  // ── About ─────────────────────────────────────────────────
                  _sectionTitle('About', isDark),
                  const SizedBox(height: 10),
                  _ExpandableAbout(
                    bio: (doc.experience != null && doc.experience!.length > 20)
                        ? doc.experience!
                        : 'Compassionate physician experienced in treating patients with complex medical conditions. Emphasizes preventive care and clear communication with patients.',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // ── Qualifications ────────────────────────────────────────
                  if (doc.qualifications != null && doc.qualifications!.isNotEmpty) ...[
                    _sectionTitle('Qualifications', isDark),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              doc.qualifications!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Available Days ────────────────────────────────────────
                  _sectionTitle('Available Days', isDark),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      itemBuilder: (_, i) {
                        final d          = _days[i];
                        final isSelected = _selectedDayIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedDayIndex = i;
                            if (_unavailableTimes.contains(_selectedTime)) {
                              _selectedTime = '10:00 AM';
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            width: 58,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  d.day,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  d.dateLabel,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Time Slots ────────────────────────────────────────────
                  _sectionTitle('Available Time Slots', isDark),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _times.map((t) {
                      final isSelected    = _selectedTime == t;
                      final isUnavailable = _unavailableTimes.contains(t);
                      return GestureDetector(
                        onTap: isUnavailable ? null : () => setState(() => _selectedTime = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: isUnavailable
                                ? (isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9))
                                : isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isUnavailable
                                  ? (isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.4))
                                  : isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isUnavailable
                                  ? (isDark ? AppColors.textHintDark : AppColors.textHintLight).withValues(alpha: 0.4)
                                  : isSelected
                                      ? Colors.white
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              decoration: isUnavailable ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Visit Type (matches web UI label) ─────────────────────
                  _sectionTitle('Visit Type', isDark),
                  const SizedBox(height: 12),
                  ..._appointmentTypes.asMap().entries.map((e) {
                    final i          = e.key;
                    final t          = e.value;
                    final isSelected = _selectedTypeIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTypeIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06)
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.primaryFaint,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(t.icon, color: isSelected ? Colors.white : AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.title,
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isSelected ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.subtitle,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Sticky bottom bar ───────────────────────────────────────────────────
      bottomNavigationBar: _BottomBar(
        doctor: doc,
        day: _day,
        time: _selectedTime,
        typeName: _type.title,
        typeBadge: _type.badge,
        clinic: doc.clinic?.clinicName ?? 'NetHealth Medical Center',
        isDark: isDark,
        onConfirm: () => _showPatientInfoModal(context),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Patient Info Modal — Step 2: Confirm Appointment
// ─────────────────────────────────────────────────────────────────────────────

class _PatientInfoModal extends ConsumerStatefulWidget {
  final DoctorModel doctor;
  final _DaySlot    selectedDay;
  final String      selectedTimeLabel;
  final String      appointmentTypeName;
  final String      appointmentTypeValue;

  const _PatientInfoModal({
    required this.doctor,
    required this.selectedDay,
    required this.selectedTimeLabel,
    required this.appointmentTypeName,
    required this.appointmentTypeValue,
  });

  @override
  ConsumerState<_PatientInfoModal> createState() => _PatientInfoModalState();
}

class _PatientInfoModalState extends ConsumerState<_PatientInfoModal> {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _notesCtrl   = TextEditingController();
  bool  _isLoading   = false;
  File? _selectedFile;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  /// Parses "10:00 AM" / "02:30 PM" → TimeOfDay safely.
  TimeOfDay _parseTime(String s) {
    final parts = s.trim().split(' ');
    final tp    = parts[0].split(':');
    int hour    = int.tryParse(tp[0]) ?? 10;
    final min   = int.tryParse(tp[1]) ?? 0;
    final isPM  = parts.length > 1 && parts[1].toUpperCase() == 'PM';
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: min);
  }

  /// Builds the SQL-formatted appointment datetime string.
  String _buildDateTimeStr() {
    final tod = _parseTime(widget.selectedTimeLabel);
    final d   = widget.selectedDay.date;
    return DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(d.year, d.month, d.day, tod.hour, tod.minute));
  }

  Future<void> _pickFile() async {
    final file = await FilePickerUtil.pickDocument();
    if (file != null) {
      setState(() => _selectedFile = file);
    }
  }

  Future<void> _submit(BuildContext ctx) async {
    final String? clinicId = widget.doctor.clinic?.id.toString();
    final messenger = ScaffoldMessenger.of(ctx);

    // Guard: doctor must be assigned to a clinic
    if (clinicId == null || clinicId.isEmpty || clinicId == '0') {
      print('DEBUG: clinicId is $clinicId. widget.doctor.clinic is ${widget.doctor.clinic}');
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: This doctor is not assigned to a clinic. (Debug: id=$clinicId)'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop execution
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(appointmentsRepositoryProvider).bookAppointment(
        doctorId:        widget.doctor.id.toString(),
        clinicId:        clinicId,
        appointmentType: widget.appointmentTypeValue,
        appointmentTime: _buildDateTimeStr(),
        patientName:     _nameCtrl.text.isNotEmpty  ? _nameCtrl.text  : null,
        patientPhone:    _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : null,
        patientEmail:    _emailCtrl.text.isNotEmpty ? _emailCtrl.text : null,
        visitReason:     _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
        attachment:      _selectedFile,
      );

      ref.invalidate(appointmentsProvider);

      if (ctx.mounted) {
        ctx.pop(); // close modal
        ctx.pop(); // back to appointments tab
        messenger.showSnackBar(SnackBar(
          content: const Text('Appointment booked successfully! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } catch (e) {
      if (ctx.mounted) {
        ctx.pop(); // close modal on error
        messenger.showSnackBar(SnackBar(
          content: Text('Booking failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doc    = widget.doctor;

    final bgColor      = isDark ? const Color(0xFF0F1623) : Colors.white;
    final surfaceColor = isDark ? const Color(0xFF1A2332) : const Color(0xFFF8FAFC);
    final bodyColor    = isDark ? const Color(0xFF1E2D3D) : const Color(0xFFF8FAFC);

    InputDecoration inputDeco(String hint, {bool multiline = false}) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
      ),
      filled: true,
      fillColor: bodyColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: multiline ? 14 : 12,
      ),
    );

    TextStyle fieldStyle() => TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: isDark ? Colors.white : Colors.black87,
    );

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.96,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Appointment',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Review your booking details before proceeding.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Scrollable body ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Doctor mini-card (matches Image 9 layout) ─────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar + badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  doc.initials,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -3,
                                right: -3,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: bgColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),

                          // Doctor name + specialty
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DOCTOR',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.4,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doc.displayName,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                Text(
                                  doc.specialty,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Schedule summary
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'SCHEDULE',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.4,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.selectedDay.day,
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                '${widget.selectedTimeLabel} • ${widget.appointmentTypeName}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Patient Information heading ────────────────────────
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Patient Information',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Full Name + Phone Number (side by side)
                    Row(
                      children: [
                        Expanded(
                          child: _ModalField(
                            label: 'Full Name',
                            child: TextFormField(
                              controller: _nameCtrl,
                              decoration: inputDeco('e.g. John Doe'),
                              style: fieldStyle(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ModalField(
                            label: 'Phone Number',
                            child: TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: inputDeco('e.g. 01009330240'),
                              style: fieldStyle(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Email Address (full width)
                    _ModalField(
                      label: 'Email Address',
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDeco('e.g. name@example.com'),
                        style: fieldStyle(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Optional Notes
                    _ModalField(
                      label: 'Optional Notes',
                      child: TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration: inputDeco('Add any notes or special instructions...', multiline: true),
                        style: fieldStyle(),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Medical Records heading ────────────────────────────
                    Row(
                      children: [
                        const Icon(Icons.description_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Medical Records',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Upload zone
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          color: AppColors.primary.withValues(alpha: 0.03),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Click to upload or drag and drop',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Upload medical test results, X-rays, or reports',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              'PDF, JPG, or PNG (max 10MB)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedFile != null) ...[
                      const SizedBox(height: 12),
                      _FileChip(
                        name: _selectedFile!.path.split('/').last,
                        isDark: isDark,
                        onRemove: () => setState(() => _selectedFile = null),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ── Action buttons (fixed) ───────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              20, 14, 20,
              MediaQuery.of(context).padding.bottom + 14,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm Booking
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _submit(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        else
                          const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets — Section title, Sliver App Bar, Stats, About, Bottom Bar
// ─────────────────────────────────────────────────────────────────────────────

Widget _sectionTitle(String title, bool isDark) => Text(
  title,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
  ),
);

class _DoctorSliverAppBar extends StatelessWidget {
  final DoctorModel doctor;
  final bool isDark;
  const _DoctorSliverAppBar({required this.doctor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D9488), AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                doctor.avatarUrl!,
                                fit: BoxFit.cover,
                                width: 96,
                                height: 96,
                                errorBuilder: (_, __, ___) => Text(
                                  doctor.initials,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              doctor.initials,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.displayName,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.specialty,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 13, color: Colors.white70),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'NetHealth Medical Center',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                              SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                ' (127 reviews)',
                                style: TextStyle(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final DoctorModel doctor;
  final bool isDark;
  const _StatsRow({required this.doctor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatTile(icon: Icons.event_available_rounded, color: AppColors.primary,  bg: AppColors.primaryFaint, label: 'Next Available',   value: 'In 2 Days',                                                         isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.payments_outlined,        color: AppColors.success,  bg: AppColors.successFaint, label: 'Consultation Fee', value: doctor.consultationFee != null ? '\$${doctor.consultationFee}' : '\$100', isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.workspace_premium_rounded, color: AppColors.warning,  bg: AppColors.warningFaint, label: 'Experience',        value: doctor.experience ?? '10 Years',                                     isDark: isDark)),
        const SizedBox(width: 10),
        Expanded(child: _StatTile(icon: Icons.star_rounded,              color: AppColors.error,    bg: AppColors.errorFaint,   label: 'Rating',            value: '4.9★',                                                              isDark: isDark)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final Color    bg;
  final String   label;
  final String   value;
  final bool     isDark;

  const _StatTile({
    required this.icon, required this.color, required this.bg,
    required this.label, required this.value, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ExpandableAbout extends StatefulWidget {
  final String bio;
  final bool   isDark;
  const _ExpandableAbout({required this.bio, required this.isDark});

  @override
  State<_ExpandableAbout> createState() => _ExpandableAboutState();
}

class _ExpandableAboutState extends State<_ExpandableAbout> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bio,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.6,
              color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _expanded ? 'Show less ↑' : 'Read more ↓',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final DoctorModel    doctor;
  final _DaySlot       day;
  final String         time;
  final String         typeName;
  final String         typeBadge;
  final String         clinic;
  final bool           isDark;
  final VoidCallback   onConfirm;

  const _BottomBar({
    required this.doctor,
    required this.day,
    required this.time,
    required this.typeName,
    required this.typeBadge,
    required this.clinic,
    required this.isDark,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${day.day} ${day.dateLabel}  •  $time  •  $typeName',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Confirm Booking →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modal Helper Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Labelled form field wrapper used inside the Patient Info Modal.
class _ModalField extends StatelessWidget {
  final String label;
  final Widget child;
  const _ModalField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Static file entry shown in the Medical Records upload list.
class _FileChip extends StatelessWidget {
  final String name;
  final bool   isDark;
  final VoidCallback? onRemove;
  const _FileChip({required this.name, required this.isDark, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, size: 17, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
              ),
            )
          else
            Icon(
              Icons.close_rounded,
              size: 16,
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data classes
// ─────────────────────────────────────────────────────────────────────────────

class _DaySlot {
  final String   day;       // e.g. "Fri"
  final String   dateLabel; // e.g. "24"  (display only)
  final DateTime date;      // actual date for datetime computation
  _DaySlot({required this.day, required this.dateLabel, required this.date});
}

class _ApptType {
  final IconData icon;
  final String   title;
  final String   subtitle;
  final String   badge;     // sent to backend as appointment_type value
  const _ApptType({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}
