// ignore_for_file: avoid_dynamic_calls

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:ridefi_assessment/core/base/base_repository.dart';
import 'package:ridefi_assessment/core/errors/app_exception.dart';
import 'package:ridefi_assessment/core/services/api/api_client.dart';
import 'package:ridefi_assessment/core/services/api/api_response.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/airport.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight_search_params.dart';

abstract class FlightRepository {
  Future<ApiResponse<List<Airport>>> getAirports({
    int limit = 100,
    int offset = 0,
  });

  Future<ApiResponse<int>> getFlightCount(FlightSearchParams params);

  Future<ApiResponse<List<Flight>>> searchFlights(FlightSearchParams params);
}

@LazySingleton(as: FlightRepository)
class FlightRepositoryImpl with BaseRepository implements FlightRepository {
  const FlightRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ApiResponse<List<Airport>>> getAirports({
    int limit = 100,
    int offset = 0,
  }) => guard(() async {
    final results = await _apiClient.get(
      '/airports',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    return results.parsedListData
        .map((e) => Airport.fromJson(e as Map<String, dynamic>))
        .where((a) => a.iataCode.isNotEmpty)
        .toList();
  });

  @override
  Future<ApiResponse<int>> getFlightCount(FlightSearchParams params) =>
      guard(() async {
        return 0;
      });
  @override
  Future<ApiResponse<List<Flight>>> searchFlights(
    FlightSearchParams params,
  ) => guard(() async {
    final queryParams = <String, dynamic>{
      'dep_iata': params.departureIata,
      'limit': params.limit,
      'offset': params.offset,
    };

    if (params.arrivalIata.isNotEmpty) {
      queryParams['arr_iata'] = params.arrivalIata;
    }

    if (params.date != null) {
      queryParams['flight_date'] = DateFormat(
        'yyyy-MM-dd',
      ).format(params.date!);
    }

    final response = await _apiClient.get(
      '/flights',
      queryParameters: queryParams,
    );
    final responseData = response.data as Map<String, dynamic>;

    if (responseData.containsKey('error')) {
      throw AppException(
        responseData['error']?['message']?.toString() ?? 'API Error',
      );
    }

    final rawData = responseData['data'] as List<dynamic>? ?? [];
    final flights = rawData
        .map((e) => Flight.fromJson(e as Map<String, dynamic>))
        .toList();

    return flights;
  });
}
