import '../../../shared/models/auth_user.dart';
import '../../../core/utils/result.dart';
import '../../../core/utils/app_error.dart';

class LoginCredentials {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginCredentials({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

abstract interface class AuthRepository {
  Future<Result<AuthUser, AppError>> login(LoginCredentials credentials);
  Future<Result<void, AppError>> logout();
  Future<AuthUser?> getStoredUser();
}
