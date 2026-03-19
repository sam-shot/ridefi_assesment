import 'package:ridefi_assessment/core/errors/app_exception.dart';

sealed class ApiResponse<T> {
  const ApiResponse();

  bool get success => this is Success<T>;
  bool get failure => this is Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  AppException? get error =>
      this is Failure<T> ? (this as Failure<T>).error : null;
}

class Success<T> extends ApiResponse<T> {
  const Success(this.data);
  @override
  final T data;
}

class Failure<T> extends ApiResponse<T> {
  const Failure(this.error, {this.stackTrace});
  @override
  final AppException error;
  final StackTrace? stackTrace;
}
