/// A simple Result type to wrap success/failure without exceptions.
sealed class Result<T, E> {
  const Result();
}

final class Success<T, E> extends Result<T, E> {
  final T data;
  const Success(this.data);
}

final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}

extension ResultExtension<T, E> on Result<T, E> {
  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T get dataOrThrow => switch (this) {
        Success(:final data) => data,
        Failure(:final error) => throw Exception(error),
      };

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(E error) onFailure,
  }) =>
      switch (this) {
        Success(:final data)   => onSuccess(data),
        Failure(:final error)  => onFailure(error),
      };
}
