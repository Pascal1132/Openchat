import 'package:freezed_annotation/freezed_annotation.dart';

import 'errors.dart';

part 'result.freezed.dart';

/// A simple Result type that carries either a success value or a failure.
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(OpenChatException error) = Failure<T>;

  const Result._();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get valueOrNull => when(success: (v) => v, failure: (_) => null);
  OpenChatException? get errorOrNull => when(success: (_) => null, failure: (e) => e);

  T get valueOrThrow => when(
        success: (v) => v,
        failure: (e) => throw e,
      );

  R whenOrElse<R>({
    required R Function(T value) success,
    required R Function(OpenChatException error) failure,
  }) =>
      when(success: success, failure: failure);
}
