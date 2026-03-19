// ignore_for_file: avoid_catches_without_on_clauses

import 'package:dio/dio.dart';
import 'package:ridefi_assessment/core/errors/app_exception.dart';
import 'package:ridefi_assessment/core/services/api/api_response.dart';

mixin BaseRepository {
  Future<ApiResponse<T>> guard<T>(Future<T> Function() callback) async {
    try {
      final result = await callback();
      return Success(result);
    } on Exception catch (e, stackTrace) {
      if (e is AppException) {
        return Failure(
          e,
          stackTrace: stackTrace,
        );
      }

      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          return Failure(
            AppException(
              e.error.toString(),
              stackTrace: stackTrace,
              sourceError: e,
            ),
            stackTrace: stackTrace,
          );
        }
      }

      return Failure(
        AppException(
          e.toString(),
          stackTrace: stackTrace,
          sourceError: e,
        ),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          'Unknown Error: $e',
          stackTrace: stackTrace,
          sourceError: e,
        ),
        stackTrace: stackTrace,
      );
    }
  }
}
