import '../../../shared/models/auth_user.dart';
import '../../../core/utils/result.dart';
import '../../../core/utils/app_error.dart';
import '../../../core/utils/secure_storage_service.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _storage = SecureStorageService.instance;

  // Valid mock credentials
  static const _validEmail    = 'patient@test.com';
  static const _validPassword = 'password';

  @override
  Future<Result<AuthUser, AppError>> login(LoginCredentials credentials) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (credentials.email == _validEmail &&
        credentials.password == _validPassword) {
      final user = AuthUser.mock();
      // Persist mock token + user
      await _storage.writeToken('mock_token_12345');
      await _storage.writeUser(user.toJsonString());
      return Success(user);
    }

    return const Failure(
      UnauthorizedError('Invalid email or password.'),
    );
  }

  @override
  Future<Result<void, AppError>> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _storage.clearAll();
    return const Success(null);
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    final json = await _storage.readUser();
    if (json == null) return null;
    try {
      return AuthUser.fromJsonString(json);
    } catch (_) {
      return null;
    }
  }
}
