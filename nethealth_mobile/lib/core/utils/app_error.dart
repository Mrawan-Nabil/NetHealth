sealed class AppError {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

class UnauthorizedError extends AppError {
  const UnauthorizedError([super.message = 'Session expired. Please login again.']);
}

class ValidationError extends AppError {
  final Map<String, List<String>> errors;
  const ValidationError(this.errors, [super.message = 'Validation failed.']);

  String? firstError(String field) => errors[field]?.firstOrNull;
}

class ServerError extends AppError {
  const ServerError([super.message = 'Server error. Please try again later.']);
}

class NetworkError extends AppError {
  const NetworkError([super.message = 'No internet connection.']);
}

class NotFoundError extends AppError {
  const NotFoundError([super.message = 'Resource not found.']);
}

class UnknownError extends AppError {
  const UnknownError([super.message = 'An unexpected error occurred.']);
}
