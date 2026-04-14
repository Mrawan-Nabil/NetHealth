import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../shared/models/auth_user.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/app_error.dart';
import '../../../core/utils/result.dart';
import '../data/auth_repository.dart';
import '../data/mock_auth_repository.dart';
import '../data/remote_auth_repository.dart';

// ── Dio provider ──────────────────────────────────────────────────────────────
final dioProvider = Provider<Dio>((ref) => ApiClient.create());

// ── Repository provider ───────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConstants.useMock) return MockAuthRepository();
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

  AppError? get lastError => state.hasError ? state.error as AppError? : null;
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthUser?>(
  AuthNotifier.new,
);

// Convenience: is the user authenticated?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).valueOrNull != null;
});
