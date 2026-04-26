import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../core/utils/file_picker_util.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Booking Modals
//
// Two composable modal flows:
//   1. showConfirmAppointmentSheet  — patient info + file upload zone
//   2. showBookingSuccessDialog     — green checkmark success state
// ─────────────────────────────────────────────────────────────────────────────

// ── 1. Confirmation Bottom Sheet ─────────────────────────────────────────────

void showConfirmAppointmentSheet(
  BuildContext context, {
  required String doctorName,
  required String specialty,
  required String day,
  required String date,
  required String time,
  required String type,
  required String clinic,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ConfirmSheetBody(
      doctorName: doctorName,
      specialty: specialty,
      day: day,
      date: date,
      time: time,
      type: type,
      clinic: clinic,
    ),
  );
}

class _ConfirmSheetBody extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String day;
  final String date;
  final String time;
  final String type;
  final String clinic;

  const _ConfirmSheetBody({
    required this.doctorName,
    required this.specialty,
    required this.day,
    required this.date,
    required this.time,
    required this.type,
    required this.clinic,
  });

  @override
  State<_ConfirmSheetBody> createState() => _ConfirmSheetBodyState();
}

class _ConfirmSheetBodyState extends State<_ConfirmSheetBody> {
  final _nameCtrl  = TextEditingController(text: 'Ahmed Mohamed');
  final _phoneCtrl = TextEditingController(text: '+20 100 234 5678');
  final _emailCtrl = TextEditingController(text: 'ahmed.m@email.com');
  final _noteCtrl  = TextEditingController();
  File? _selectedFile;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _phoneCtrl, _emailCtrl, _noteCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await FilePickerUtil.pickDocument();
    if (file != null) {
      setState(() => _selectedFile = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.surfaceDark : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.98,
      minChildSize: 0.5,
      builder: (ctx, scrollController) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Drag handle
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

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Confirm Appointment',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Review your details before booking',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Appointment summary card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFaint,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                                backgroundColor: AppColors.primaryFaint,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.doctorName, style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryDark)),
                                    Text(widget.specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primaryDark.withValues(alpha: 0.7))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _SummaryChip(icon: Icons.calendar_today_rounded, text: '${widget.day}, ${widget.date}'),
                              const SizedBox(width: 8),
                              _SummaryChip(icon: Icons.access_time_rounded, text: widget.time),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _SummaryChip(icon: Icons.location_on_outlined, text: widget.clinic),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Patient info
                    _FormSectionTitle('Patient Information', isDark),
                    const SizedBox(height: 12),
                    _FormField(controller: _nameCtrl,  label: 'Full Name',     icon: Icons.person_outline_rounded,  isDark: isDark),
                    const SizedBox(height: 12),
                    _FormField(controller: _phoneCtrl, label: 'Phone Number',  icon: Icons.phone_outlined,           isDark: isDark),
                    const SizedBox(height: 12),
                    _FormField(controller: _emailCtrl, label: 'Email Address', icon: Icons.mail_outline_rounded,     isDark: isDark),
                    const SizedBox(height: 12),
                    _FormField(controller: _noteCtrl,  label: 'Notes (optional)', icon: Icons.notes_rounded,        isDark: isDark, maxLines: 3),
                    const SizedBox(height: 24),

                    // Medical records upload zone (dashed)
                    _FormSectionTitle('Medical Records', isDark),
                    const SizedBox(height: 8),
                    DashedUploadZone(isDark: isDark, onTap: _pickFile),
                    if (_selectedFile != null) ...[
                      const SizedBox(height: 12),
                      _UploadedFileTile(
                        name: _selectedFile!.path.split('/').last,
                        size: '${(_selectedFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB',
                        isDark: isDark,
                        onRemove: () => setState(() => _selectedFile = null),
                      ),
                    ],
                    const SizedBox(height: 28),

                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final fileName = _selectedFile?.path.split('/').last;
                          Navigator.pop(context);
                          showBookingSuccessDialog(
                            context,
                            doctorName: widget.doctorName,
                            specialty: widget.specialty,
                            uploadedFileName: fileName,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Confirm Booking →', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
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

// ── 2. Booking Success Dialog ─────────────────────────────────────────────────

void showBookingSuccessDialog(
  BuildContext context, {
  required String doctorName,
  required String specialty,
  String? uploadedFileName,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _SuccessDialog(
      doctorName: doctorName,
      specialty: specialty,
      uploadedFileName: uploadedFileName,
    ),
  );
}

class _SuccessDialog extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String? uploadedFileName;

  const _SuccessDialog({
    required this.doctorName,
    required this.specialty,
    this.uploadedFileName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: AppColors.successFaint, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.statusCompleted, size: 48),
            ),
            const SizedBox(height: 20),

            const Text(
              'Appointment Booked\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 22, height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(
              'You will receive a confirmation notification shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter', fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),

            // Doctor summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryFaint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                    backgroundColor: AppColors.primaryFaint,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctorName, style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryDark)),
                      Text(specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primaryDark.withValues(alpha: 0.7))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Uploaded file — only shown when a file was actually attached
            if (uploadedFileName != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Uploaded File', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              ),
              const SizedBox(height: 8),
              _UploadedFileTile(name: uploadedFileName!, size: '', isDark: isDark),
              const SizedBox(height: 24),
            ] else
              const SizedBox(height: 24),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.goNamed(RouteNames.appointments);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('View My Appointments', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class DashedUploadZone extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const DashedUploadZone({super.key, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(isDark: isDark),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: AppColors.primaryFaint, shape: BoxShape.circle),
                child: const Icon(Icons.upload_file_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 12),
              const Text('Drag & drop files here', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primary)),
              const SizedBox(height: 4),
              Text(
                'Supports PDF, JPG, PNG — max 10MB',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryFaint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Browse Files', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final bool isDark;
  _DashedBorderPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap  = 4.0;
    const r    = Radius.circular(16);
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), r));
    final metric = path.computeMetrics().first;
    double dist = 0;
    while (dist < metric.length) {
      canvas.drawPath(metric.extractPath(dist, dist + dash), paint);
      dist += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SummaryChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.primaryDark),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primaryDark)),
      ],
    );
  }
}

class _FormSectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _FormSectionTitle(this.title, this.isDark);

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
  );
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final int maxLines;

  const _FormField({required this.controller, required this.label, required this.icon, required this.isDark, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: maxLines,
    style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
    ),
  );
}

class _UploadedFileTile extends StatelessWidget {
  final String name;
  final String size;
  final bool isDark;
  final VoidCallback? onRemove;

  const _UploadedFileTile({required this.name, required this.size, required this.isDark, this.onRemove});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
    ),
    child: Row(
      children: [
        const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        ),
        Text(size, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
        const SizedBox(width: 8),
        if (onRemove != null)
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, color: AppColors.error, size: 18),
          )
        else
          const Icon(Icons.check_circle_rounded, color: AppColors.statusCompleted, size: 16),
      ],
    ),
  );
}
