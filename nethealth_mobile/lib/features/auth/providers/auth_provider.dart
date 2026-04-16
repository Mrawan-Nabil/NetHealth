import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/auth_user.dart';
import '../../../core/utils/app_error.dart';
import '../../../core/utils/result.dart';
import '../data/auth_repository.dart';
import '../data/remote_auth_repository.dart';
import '../../../core/network/dio_provider.dart';

// ── Repository provider ───────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return RemoteAuthRepository(ref.watch(dioProvider));
});

// ── Auth state ────────────────────────────────────────────────────────────────
class AuthNotifier extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    // On startup, try to restore user from secure storage
    return ref.read(authRepositoryProvider).getStoredUser();
  }

  Future<void> login(LoginCredentials credentials) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).login(credentials);
    if (result is Success<AuthUser, AppError>) {
      state = AsyncData(result.data);
    } else if (result is Failure<AuthUser, AppError>) {
      state = AsyncError(result.error, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }

  void forceLogout() {
    state = const AsyncData(null);
  }

  Future<void> checkAuthStatus() async {
    final result = await ref.read(authRepositoryProvider).getMe();
    if (result is Success<AuthUser, AppError>) {
      state = AsyncData(result.data);
    } else {
      if (result is Failure<AuthUser, AppError> && result.error is UnauthorizedError) {
        state = const AsyncData(null);
      }
    }
  }

  AppError? get lastError => state.hasError ? state.error as AppError? : null;
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthUser?>(
  AuthNotifier.new,
);

// Convenience: is the user authenticated?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).valueOrNull != null;
});
