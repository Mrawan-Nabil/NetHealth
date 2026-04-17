import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../shared/models/enums.dart';

// ── Auth Screens ──────────────────────────────────────────────────────────────
import '../../features/auth/ui/splash_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/onboarding_screen.dart';
import '../../features/auth/ui/select_role_screen.dart';
import '../../features/auth/ui/registration_screen.dart';
import '../../features/auth/ui/success_screen.dart';
import '../../features/auth/ui/pending_approval_screen.dart';
import '../../features/auth/ui/account_suspended_screen.dart';

// ── Shell ─────────────────────────────────────────────────────────────────────
import '../../features/home/ui/home_shell.dart';
import '../../features/home/ui/dashboard_screen.dart';

// ── Profile ───────────────────────────────────────────────────────────────────
import '../../features/profile/ui/profile_screen.dart';
import '../../features/profile/ui/edit_profile_screen.dart';

// ── Appointments ──────────────────────────────────────────────────────────────
import '../../features/appointments/ui/appointments_screen.dart';
import '../../features/appointments/ui/appointment_detail_screen.dart';
import '../../features/appointments/ui/find_specialist_screen.dart';
import '../../features/appointments/ui/doctor_details_screen.dart';
import '../../shared/models/doctor_booking_model.dart';
// ── Records ───────────────────────────────────────────────────────────────────
import '../../features/records/ui/records_screen.dart';
import '../../features/records/ui/medical_record_detail_screen.dart';
import '../../features/records/ui/visit_history_screen.dart';

// ── Prescriptions ─────────────────────────────────────────────────────────────
import '../../features/prescriptions/ui/prescription_details_screen.dart';

// ── Tests & Imaging ───────────────────────────────────────────────────────────
import '../../features/tests_imaging/ui/test_results_screen.dart';
import '../../features/tests_imaging/ui/test_result_detail_screen.dart';
import '../../features/tests_imaging/ui/imaging_list_screen.dart';
import '../../features/tests_imaging/ui/image_viewer_screen.dart';

// ── Misc ──────────────────────────────────────────────────────────────────────
import '../../features/notifications/ui/notifications_screen.dart';
import '../constants/route_names.dart';

// ─────────────────────────────────────────────────────────────────────────────
// routerProvider
// ─────────────────────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: AppConstants.useMock,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // Don't redirect during the loading state
      if (authState.isLoading) return null;

      final user           = authState.valueOrNull;
      final isAuthenticated = user != null;
      final loc             = state.uri.path;

      // Routes that are always accessible regardless of auth state
      final isPublicRoute = loc == RoutePaths.login        ||
          loc == RoutePaths.splash                          ||
          loc == RoutePaths.onboarding                     ||
          loc == RoutePaths.selectRole                     ||
          loc.startsWith('/register')                      ||
          loc == RoutePaths.pendingApproval                ||
          loc == RoutePaths.accountSuspended;

      if (!isAuthenticated && !isPublicRoute) return RoutePaths.onboarding;
      
      if (isAuthenticated) {
        if (user.accountStatus == AccountStatus.pending) {
          if (loc != RoutePaths.pendingApproval) return RoutePaths.pendingApproval;
        } else if (user.accountStatus == AccountStatus.suspended) {
          if (loc != RoutePaths.accountSuspended) return RoutePaths.accountSuspended;
        } else {
          // If active and on a public auth route, redirect to dashboard
          if (loc == RoutePaths.login || loc == RoutePaths.onboarding || loc == RoutePaths.splash || loc == RoutePaths.pendingApproval || loc == RoutePaths.accountSuspended || loc == RoutePaths.selectRole || loc.startsWith('/register')) {
            return RoutePaths.dashboard;
          }
        }
      }

      return null;
    },
    refreshListenable: _AuthStateListenable(ref),
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.splash,
        name:    RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),

      // ── Notifications — now a shell branch tab (index 3) ────────────────────
      // Standalone route kept as alias for push-based navigation from bell icon
      // (handled by the branch below; this alias can be removed post-launch)

      // ── Pending approval ───────────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.pendingApproval,
        name:    RouteNames.pendingApproval,
        builder: (_, __) => const PendingApprovalScreen(),
      ),

      // ── Account suspended ──────────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.accountSuspended,
        name:    RouteNames.accountSuspended,
        builder: (_, __) => const AccountSuspendedScreen(),
      ),

      // ── Onboarding ─────────────────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.onboarding,
        name:    RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),

      // ── Select Role ────────────────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.selectRole,
        name:    RouteNames.selectRole,
        builder: (_, __) => const SelectRoleScreen(),
      ),

      // ── Registration ───────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (_, state) {
          final role = state.pathParameters['role'] ?? 'patient';
          return RegistrationScreen(role: role);
        },
      ),

      // ── Registration Success ───────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.registerSuccess,
        name:    RouteNames.registerSuccess,
        builder: (_, __) => const SuccessScreen(),
      ),

      // ── Login ──────────────────────────────────────────────────────────────
      GoRoute(
        path:    RoutePaths.login,
        name:    RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),

      // ── Main App Shell — StatefulShellRoute with bottom nav ────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [

          // 1️⃣  Dashboard
          StatefulShellBranch(routes: [
            GoRoute(
              path:    RoutePaths.dashboard,
              name:    RouteNames.dashboard,
              builder: (_, __) => const DashboardScreen(),
            ),
          ]),

          // 2️⃣  Appointments
          StatefulShellBranch(routes: [
            GoRoute(
              path:    RoutePaths.appointments,
              name:    RouteNames.appointments,
              builder: (_, __) => const AppointmentsScreen(),
              routes: [
                // Find Specialist
                GoRoute(
                  path:    'find-specialist',
                  name:    RouteNames.findSpecialist,
                  builder: (_, __) => const FindSpecialistScreen(),
                ),

                // Doctor Details — requires DoctorModel in extra
                GoRoute(
                  path:    'doctor-details/:id',
                  name:    RouteNames.doctorDetails,
                  builder: (_, state) => DoctorDetailsScreen(
                    doctor: state.extra as DoctorModel,
                  ),
                ),

                // Appointment Detail — requires :id
                GoRoute(
                  path:    'detail/:id',
                  name:    RouteNames.appointmentDetail,
                  builder: (_, state) => AppointmentDetailScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),

          // 3️⃣  Records
          StatefulShellBranch(routes: [
            GoRoute(
              path:    RoutePaths.records,
              name:    RouteNames.records,
              builder: (_, __) => const RecordsScreen(),
              routes: [
                // Medical Record Detail — requires :id
                GoRoute(
                  path:    'detail/:id',
                  name:    RouteNames.medicalRecordDetail,
                  builder: (_, state) => MedicalRecordDetailScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),

                // Visit History
                GoRoute(
                  path:    'visit-history',
                  name:    RouteNames.visitHistory,
                  builder: (_, __) => const VisitHistoryScreen(),
                ),

                // Lab Results list → detail
                GoRoute(
                  path:    'test-results',
                  name:    RouteNames.testResults,
                  builder: (_, __) => const TestResultsScreen(),
                  routes: [
                    GoRoute(
                      path:    'detail/:id',
                      name:    RouteNames.testResultDetail,
                      builder: (_, state) => TestResultDetailScreen(
                        id: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),

                // Imaging List
                GoRoute(
                  path:    'imaging',
                  name:    RouteNames.imagingList,
                  builder: (_, __) => const ImagingListScreen(),
                ),

                // Image Viewer — requires :id
                GoRoute(
                  path:    'image-viewer/:id',
                  name:    RouteNames.imageViewer,
                  builder: (_, state) => ImageViewerScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),

                // Prescription Details — requires :id (navigated from Records tabs)
                GoRoute(
                  path:    'prescription-details/:id',
                  name:    RouteNames.prescriptionDetails,
                  builder: (_, state) => PrescriptionDetailsScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),

          // 4️⃣  Notifications (replaces Rx tab)
          StatefulShellBranch(routes: [
            GoRoute(
              path:    RoutePaths.notifications,
              name:    RouteNames.notifications,
              builder: (_, __) => const NotificationsScreen(),
            ),
          ]),

          // 5️⃣  Profile
          StatefulShellBranch(routes: [
            GoRoute(
              path:    RoutePaths.profile,
              name:    RouteNames.profile,
              builder: (_, __) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path:    'edit',
                  name:    RouteNames.editProfile,
                  builder: (_, __) => const EditProfileScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],

    // ── 404 handler ──────────────────────────────────────────────────────────
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Page not found', style: TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Auth state listenable — triggers GoRouter.redirect on auth state changes
// ─────────────────────────────────────────────────────────────────────────────

class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
