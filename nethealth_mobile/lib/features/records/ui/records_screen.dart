import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RecordsScreen — 4-tab Medical Records hub
//
// Tab 1: Prescriptions (rich cards with medicines list)
// Tab 2: Test Results  → inline list → TestResultDetailScreen
// Tab 3: Imaging       → inline list → ImageViewerScreen
// Tab 4: Visit History → inline list → AppointmentDetailScreen
// ─────────────────────────────────────────────────────────────────────────────

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Medical Records', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 13),
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(text: 'Prescriptions'),
              Tab(text: 'Test Results'),
              Tab(text: 'Imaging'),
              Tab(text: 'Visit History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PrescriptionsTab(isDark: isDark),
            _TestResultsTab(isDark: isDark),
            _ImagingTab(isDark: isDark),
            _VisitHistoryTab(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Prescriptions
// ─────────────────────────────────────────────────────────────────────────────

class _PrescriptionsTab extends StatelessWidget {
  final bool isDark;
  const _PrescriptionsTab({required this.isDark});

  static const _items = [
    _PrescriptionMock(
      id: 'RX-10294',
      doctor: 'Dr. Sara Ahmed',
      specialty: 'General Practitioner',
      clinic: 'City General Hospital',
      date: 'Oct 15, 2025',
      validUntil: 'Nov 15, 2025',
      diagnosis: 'Upper Respiratory Tract Infection (URTI)',
      medicines: ['Amoxicillin 500mg — 3×/day for 7 days', 'Paracetamol 500mg — When needed'],
      status: 'active',
    ),
    _PrescriptionMock(
      id: 'RX-89432',
      doctor: 'Dr. Ayman Fathy',
      specialty: 'Cardiologist',
      clinic: 'City Heart Institute',
      date: 'Sep 02, 2025',
      validUntil: 'Sep 30, 2025',
      diagnosis: 'Hypertension (Stage 1)',
      medicines: ['Lisinopril 10mg — Once daily', 'Amlodipine 5mg — Once daily'],
      status: 'expired',
    ),
    _PrescriptionMock(
      id: 'RX-77381',
      doctor: 'Dr. Nadia Karim',
      specialty: 'Dermatologist',
      clinic: 'Nile Skin Clinic',
      date: 'Aug 10, 2025',
      validUntil: 'Sep 10, 2025',
      diagnosis: 'Mild Eczema (Atopic Dermatitis)',
      medicines: ['Hydrocortisone 1% Cream — Apply twice daily', 'Cetirizine 10mg — Once daily at night'],
      status: 'expired',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _items.length,
      itemBuilder: (ctx, i) => _PrescriptionCard(item: _items[i], isDark: isDark),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final _PrescriptionMock item;
  final bool isDark;
  const _PrescriptionCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isActive = item.status == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.4)
              : (isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header strip ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06)
                  : (isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rx icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primaryFaint : (isDark ? AppColors.surfaceDark : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medication_rounded, size: 20, color: isActive ? AppColors.primary : (isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.id, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                      const SizedBox(height: 2),
                      Text(item.doctor, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      Text(item.specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                    ],
                  ),
                ),
                StatusBadge(status: item.status),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),

          // ── Body ─────────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date row
                Row(
                  children: [
                    _InfoPill(icon: Icons.calendar_today_rounded, text: item.date, isDark: isDark),
                    const SizedBox(width: 10),
                    _InfoPill(icon: Icons.event_busy_rounded, text: 'Valid until: ${item.validUntil}', isDark: isDark),
                  ],
                ),
                const SizedBox(height: 12),

                // Diagnosis
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Diagnosis', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                      const SizedBox(height: 4),
                      Text(item.diagnosis, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Medicines list
                Text('Medications', style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 8),
                ...item.medicines.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(med, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
                    ],
                  ),
                )),
                const SizedBox(height: 14),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded, size: 15),
                        label: const Text('Download'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushNamed(RouteNames.prescriptionDetails, pathParameters: {'id': item.id}),
                        icon: const Icon(Icons.remove_red_eye_rounded, size: 15),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
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
// Tab 2: Test Results (inline list)
// ─────────────────────────────────────────────────────────────────────────────

class _TestResultsTab extends StatelessWidget {
  final bool isDark;
  const _TestResultsTab({required this.isDark});

  static const _items = [
    _TestResultMock(id: '1', name: 'Full Blood Count (FBC)',         category: 'Haematology',   lab: 'City General Laboratory',    date: 'Oct 10, 2025', status: 'reviewed'),
    _TestResultMock(id: '2', name: 'Urine Analysis (UA)',            category: 'Urinalysis',    lab: 'Nile Lab Diagnostics',       date: 'Sep 22, 2025', status: 'reviewed'),
    _TestResultMock(id: '3', name: 'Lipid Panel',                    category: 'Biochemistry',  lab: 'City Heart Institute Lab',   date: 'Aug 14, 2025', status: 'pending'),
    _TestResultMock(id: '4', name: 'HbA1c (Glycated Haemoglobin)',  category: 'Endocrinology', lab: 'MedCore Diagnostics',        date: 'Jun 05, 2025', status: 'reviewed'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _items.length,
      itemBuilder: (ctx, i) {
        final item = _items[i];
        return GestureDetector(
          onTap: () => context.pushNamed(RouteNames.testResultDetail, pathParameters: {'id': item.id}),
          child: _SimpleAttachmentCard(
            isDark: isDark,
            icon: Icons.science_rounded,
            iconColor: AppColors.info,
            iconBg: AppColors.infoFaint,
            categoryLabel: item.category,
            title: item.name,
            subtitle: item.lab,
            date: item.date,
            status: item.status,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Imaging (inline list)
// ─────────────────────────────────────────────────────────────────────────────

class _ImagingTab extends StatelessWidget {
  final bool isDark;
  const _ImagingTab({required this.isDark});

  static const _items = [
    _ImagingMock(id: '1', title: 'Chest X-Ray',         modality: 'X-RAY',      iconColor: AppColors.warning,  iconBg: AppColors.warningFaint,  date: 'Oct 10, 2025', physician: 'Dr. Ayman Fathy',  status: 'reviewed'),
    _ImagingMock(id: '2', title: 'Brain MRI',            modality: 'MRI',        iconColor: AppColors.primary,  iconBg: AppColors.primaryFaint,  date: 'Aug 22, 2025', physician: 'Dr. Ali Hassan',   status: 'reviewed'),
    _ImagingMock(id: '3', title: 'Abdominal CT Scan',    modality: 'CT SCAN',    iconColor: AppColors.info,     iconBg: AppColors.infoFaint,     date: 'Jun 14, 2025', physician: 'Dr. Sara Ahmed',   status: 'pending'),
    _ImagingMock(id: '4', title: 'Echocardiogram',       modality: 'ECHO',       iconColor: AppColors.error,    iconBg: AppColors.errorFaint,    date: 'Mar 05, 2025', physician: 'Dr. Ayman Fathy',  status: 'reviewed'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _items.length,
      itemBuilder: (ctx, i) {
        final item = _items[i];
        return GestureDetector(
          onTap: () => context.pushNamed(RouteNames.imageViewer, pathParameters: {'id': item.id}),
          child: _SimpleAttachmentCard(
            isDark: isDark,
            icon: Icons.image_outlined,
            iconColor: item.iconColor,
            iconBg: item.iconBg,
            categoryLabel: item.modality,
            title: item.title,
            subtitle: item.physician,
            date: item.date,
            status: item.status,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 4: Visit History (inline list)
// ─────────────────────────────────────────────────────────────────────────────

class _VisitHistoryTab extends StatelessWidget {
  final bool isDark;
  const _VisitHistoryTab({required this.isDark});

  static const _visits = [
    _VisitMock(id: '1', date: 'Oct 15, 2025', doctor: 'Dr. Sara Ahmed',   specialty: 'General Practitioner', clinic: 'City General Hospital',  status: 'completed', type: 'physical'),
    _VisitMock(id: '2', date: 'Sep 28, 2025', doctor: 'Dr. Ayman Fathy',  specialty: 'Cardiologist',          clinic: 'City Heart Institute',   status: 'completed', type: 'physical'),
    _VisitMock(id: '3', date: 'Aug 10, 2025', doctor: 'Dr. Nadia Karim',  specialty: 'Dermatologist',         clinic: 'Nile Skin Clinic',       status: 'completed', type: 'remote'),
    _VisitMock(id: '4', date: 'Jun 22, 2025', doctor: 'Dr. Ayman Fathy',  specialty: 'Cardiologist',          clinic: 'City Heart Institute',   status: 'cancelled', type: 'physical'),
    _VisitMock(id: '5', date: 'Apr 05, 2025', doctor: 'Dr. Ali Hassan',   specialty: 'Neurologist',           clinic: 'NeuroMed Institute',     status: 'completed', type: 'physical'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _visits.length,
      itemBuilder: (ctx, i) {
        final v = _visits[i];
        return GestureDetector(
          onTap: () => context.pushNamed(RouteNames.appointmentDetail, pathParameters: {'id': v.id}),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
              boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(Icons.calendar_today_rounded, size: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                      const SizedBox(width: 5),
                      Text(v.date, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                    ]),
                    StatusBadge(status: v.status, compact: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(v.doctor, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                Text(v.specialty, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                const SizedBox(height: 8),
                Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.location_on_outlined, size: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                  const SizedBox(width: 5),
                  Expanded(child: Text(v.clinic, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                  const SizedBox(width: 8),
                  StatusBadge(status: v.type, compact: true),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared sub-widget: simple attachment/result card used by Test Results + Imaging
// ─────────────────────────────────────────────────────────────────────────────

class _SimpleAttachmentCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String categoryLabel;
  final String title;
  final String subtitle;
  final String date;
  final String status;

  const _SimpleAttachmentCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.categoryLabel,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withValues(alpha: 0.6)),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(categoryLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: iconColor)),
                    ),
                    const Spacer(),
                    StatusBadge(status: status, compact: true),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title, style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.calendar_today_rounded, size: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                  const SizedBox(width: 4),
                  Text(date, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.borderDark : AppColors.textHintLight),
        ],
      ),
    );
  }
}

// ── Shared small widget ───────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  const _InfoPill({required this.icon, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: AppColors.primary),
      const SizedBox(width: 5),
      Text(text, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data models
// ─────────────────────────────────────────────────────────────────────────────

class _PrescriptionMock {
  final String id, doctor, specialty, clinic, date, validUntil, diagnosis, status;
  final List<String> medicines;
  const _PrescriptionMock({required this.id, required this.doctor, required this.specialty, required this.clinic, required this.date, required this.validUntil, required this.diagnosis, required this.medicines, required this.status});
}

class _TestResultMock {
  final String id, name, category, lab, date, status;
  const _TestResultMock({required this.id, required this.name, required this.category, required this.lab, required this.date, required this.status});
}

class _ImagingMock {
  final String id, title, modality, date, physician, status;
  final Color iconColor, iconBg;
  const _ImagingMock({required this.id, required this.title, required this.modality, required this.iconColor, required this.iconBg, required this.date, required this.physician, required this.status});
}

class _VisitMock {
  final String id, date, doctor, specialty, clinic, status, type;
  const _VisitMock({required this.id, required this.date, required this.doctor, required this.specialty, required this.clinic, required this.status, required this.type});
}
