import 'package:dartz/dartz.dart';
import 'package:trialog/core/errors/failures.dart';

/// Type alias for Result pattern
/// Left: Failure, Right: Success
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result type
extension ResultExtension<T> on Result<T> {
  /// Check if result is success
  bool get isSuccess => isRight();

  /// Check if result is failure
  bool get isFailure => isLeft();

  /// Get success value or null
  T? get valueOrNull => fold((l) => null, (r) => r);

  /// Get failure or null
  Failure? get failureOrNull => fold((l) => l, (r) => null);
}
