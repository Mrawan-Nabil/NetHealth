import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/ui/splash_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/onboarding_screen.dart';
import '../../features/auth/ui/select_role_screen.dart';
import '../../features/auth/ui/registration_screen.dart';
import '../../features/auth/ui/success_screen.dart';
import '../../features/home/ui/home_shell.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/profile/ui/edit_profile_screen.dart';
import '../../features/home/ui/dashboard_screen.dart';
import '../../features/appointments/ui/appointments_screen.dart';
import '../../features/appointments/ui/find_specialist_screen.dart';
import '../../features/appointments/ui/doctor_details_screen.dart';
import '../../features/records/ui/records_screen.dart';
import '../../features/prescriptions/ui/prescriptions_screen.dart';
import '../../features/prescriptions/ui/prescription_details_screen.dart';
import '../../features/tests_imaging/ui/test_results_screen.dart';
import '../../features/tests_imaging/ui/image_viewer_screen.dart';
import '../constants/route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: AppConstants.useMock,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoading = authState.isLoading;

      // Don't redirect while loading
      if (isLoading) return null;

      final user = authState.valueOrNull;
      final isAuthenticated = user != null;
      final loc = state.uri.path;

      final isAuthRoute = loc == RoutePaths.login ||
          loc == RoutePaths.splash ||
          loc == RoutePaths.onboarding ||
          loc == RoutePaths.selectRole ||
          loc.startsWith('/register');

      if (!isAuthenticated && !isAuthRoute) return RoutePaths.onboarding;
      if (isAuthenticated && loc == RoutePaths.login) return RoutePaths.home;

      return null;
    },
    refreshListenable: _AuthStateListenable(ref),
    routes: [
      // Splash
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),

      // Select Role
      GoRoute(
        path: RoutePaths.selectRole,
        name: RouteNames.selectRole,
        builder: (_, __) => const SelectRoleScreen(),
      ),

      // Registration
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (_, state) {
          final role = state.pathParameters['role'] ?? 'patient';
          return RegistrationScreen(role: role);
        },
      ),

      // Registration Success
      GoRoute(
        path: RoutePaths.registerSuccess,
        name: RouteNames.registerSuccess,
        builder: (_, __) => const SuccessScreen(),
      ),

      // Login
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),

      // Home shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          // Dashboard tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.dashboard,
              name: RouteNames.dashboard,
              builder: (_, __) => const DashboardScreen(),
            ),
          ]),

          // Appointments tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.appointments,
              name: RouteNames.appointments,
              builder: (_, __) => const AppointmentsScreen(),
              routes: [
                GoRoute(
                  path: 'find-specialist',
                  name: RouteNames.findSpecialist,
                  builder: (_, __) => const FindSpecialistScreen(),
                ),
                GoRoute(
                  path: 'doctor-details',
                  name: RouteNames.doctorDetails,
                  builder: (_, __) => const DoctorDetailsScreen(),
                ),
              ],
            ),
          ]),

          // Records tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.records,
              name: RouteNames.records,
              builder: (_, __) => const RecordsScreen(),
              routes: [
                GoRoute(
                  path: 'test-results',
                  name: RouteNames.testResults,
                  builder: (_, __) => const TestResultsScreen(),
                ),
                GoRoute(
                  path: 'image-viewer',
                  name: RouteNames.imageViewer,
                  builder: (_, __) => const ImageViewerScreen(),
                ),
              ],
            ),
          ]),

          // Prescriptions tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.prescriptions,
              name: RouteNames.prescriptions,
              builder: (_, __) => const PrescriptionsScreen(),
              routes: [
                GoRoute(
                  path: 'details',
                  name: RouteNames.prescriptionDetails,
                  builder: (_, __) => const PrescriptionDetailsScreen(),
                ),
              ],
            ),
          ]),

          // Profile tab
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (_, __) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: RouteNames.editProfile,
                  builder: (_, __) => const EditProfileScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});

// Listens to auth state changes and triggers router refresh
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}


