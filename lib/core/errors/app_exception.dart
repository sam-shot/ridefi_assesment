class AppException implements Exception {
  AppException(
    this.message, {
    this.code,
    this.stackTrace,
    this.sourceError,
  });
  final String message;
  final String? code;
  final StackTrace? stackTrace;
  final dynamic sourceError;

  @override
  String toString() => 'AppException: $message';
}
