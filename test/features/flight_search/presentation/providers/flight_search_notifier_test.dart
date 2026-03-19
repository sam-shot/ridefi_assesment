import 'package:flutter_test/flutter_test.dart';
import 'package:ridefi_assessment/core/errors/app_exception.dart';
import 'package:ridefi_assessment/core/services/api/api_response.dart';
import 'package:ridefi_assessment/features/flight_search/data/repositories/flight_repository.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/airport.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight_search_params.dart';
import 'package:ridefi_assessment/features/flight_search/domain/models/flight_search_state.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/flight_search_provider.dart';

void main() {
  group('FlightSearchNotifier', () {
    test('search sets success state when flights are returned', () async {
      final params = FlightSearchParams(
        departureIata: 'JFK',
        arrivalIata: 'LAX',
        limit: 2,
      );
      final flights = [
        _buildFlight(iata: 'RF100'),
        _buildFlight(iata: 'RF200'),
      ];
      final repository = _FakeFlightRepository(
        searchResponses: [Success<List<Flight>>(flights)],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.search(params);

      expect(notifier.state.status, FlightSearchStatus.success);
      expect(notifier.state.flights, flights);
      expect(notifier.state.hasMore, isTrue);
      expect(notifier.state.totalCount, flights.length);
      expect(notifier.state.params, same(params));
      expect(repository.searchFlightsCallCount, 1);
    });

    test('search sets empty state when no flights are returned', () async {
      final params = FlightSearchParams(
        departureIata: 'JFK',
        arrivalIata: 'LAX',
      );
      final repository = _FakeFlightRepository(
        searchResponses: [const Success<List<Flight>>(<Flight>[])],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.search(params);

      expect(notifier.state.status, FlightSearchStatus.empty);
      expect(notifier.state.flights, isEmpty);
      expect(notifier.state.hasMore, isFalse);
      expect(notifier.state.totalCount, 0);
    });

    test('search sets failure state when repository returns an error', () async {
      final params = FlightSearchParams(
        departureIata: 'JFK',
        arrivalIata: 'LAX',
      );
      final repository = _FakeFlightRepository(
        searchResponses: [
          Failure<List<Flight>>(AppException('Network error')),
        ],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.search(params);

      expect(notifier.state.status, FlightSearchStatus.failure);
      expect(notifier.state.errorMessage, 'Network error');
      expect(notifier.state.flights, isEmpty);
    });

    test('loadMore appends flights and advances pagination', () async {
      final params = FlightSearchParams(
        departureIata: 'JFK',
        arrivalIata: 'LAX',
        limit: 2,
      );
      final initialFlights = [
        _buildFlight(iata: 'RF100'),
        _buildFlight(iata: 'RF200'),
      ];
      final additionalFlights = [_buildFlight(iata: 'RF300')];
      final repository = _FakeFlightRepository(
        searchResponses: [
          Success<List<Flight>>(initialFlights),
          Success<List<Flight>>(additionalFlights),
        ],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.search(params);
      await notifier.loadMore();

      expect(repository.searchFlightsCallCount, 2);
      expect(repository.recordedParams.last.offset, params.limit);
      expect(notifier.state.status, FlightSearchStatus.success);
      expect(notifier.state.flights, [...initialFlights, ...additionalFlights]);
      expect(notifier.state.totalCount, 3);
      expect(notifier.state.hasMore, isFalse);
    });

    test('loadMore is ignored when state has no more pages', () async {
      final repository = _FakeFlightRepository(
        searchResponses: [],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.loadMore();

      expect(repository.searchFlightsCallCount, 0);
      expect(notifier.state.status, FlightSearchStatus.initial);
    });

    test('loadMore preserves success state when next page fails', () async {
      final params = FlightSearchParams(
        departureIata: 'JFK',
        arrivalIata: 'LAX',
        limit: 1,
      );
      final initialFlights = [_buildFlight(iata: 'RF100')];
      final repository = _FakeFlightRepository(
        searchResponses: [
          Success<List<Flight>>(initialFlights),
          Failure<List<Flight>>(AppException('Timeout')),
        ],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.search(params);
      await notifier.loadMore();

      expect(notifier.state.status, FlightSearchStatus.success);
      expect(notifier.state.flights, initialFlights);
      expect(notifier.state.totalCount, 1);
    });

    test('selectFlight and clearSelectedFlight update selected item only', () async {
      final params = FlightSearchParams(
        departureIata: 'JFK',
        arrivalIata: 'LAX',
      );
      final flights = [_buildFlight(iata: 'RF100')];
      final repository = _FakeFlightRepository(
        searchResponses: [Success<List<Flight>>(flights)],
      );
      final notifier = FlightSearchNotifier(repository);

      await notifier.search(params);
      notifier.selectFlight(flights.first);
      notifier.clearSelectedFlight();

      expect(notifier.state.selectedFlight, isNull);
      expect(notifier.state.flights, flights);
      expect(notifier.state.status, FlightSearchStatus.success);
    });
  });
}

class _FakeFlightRepository implements FlightRepository {
  _FakeFlightRepository({
    required List<ApiResponse<List<Flight>>> searchResponses,
  }) : _searchResponses = List<ApiResponse<List<Flight>>>.from(searchResponses);

  final List<ApiResponse<List<Flight>>> _searchResponses;
  final List<FlightSearchParams> recordedParams = <FlightSearchParams>[];
  int searchFlightsCallCount = 0;

  @override
  Future<ApiResponse<List<Airport>>> getAirports({
    int limit = 100,
    int offset = 0,
  }) async {
    return const Success<List<Airport>>(<Airport>[]);
  }

  @override
  Future<ApiResponse<int>> getFlightCount(FlightSearchParams params) async {
    return const Success<int>(0);
  }

  @override
  Future<ApiResponse<List<Flight>>> searchFlights(
    FlightSearchParams params,
  ) async {
    searchFlightsCallCount += 1;
    recordedParams.add(params);

    if (_searchResponses.isEmpty) {
      return const Success<List<Flight>>(<Flight>[]);
    }

    return _searchResponses.removeAt(0);
  }
}

Flight _buildFlight({required String iata}) {
  return Flight(
    flightIata: iata,
    flightNumber: iata,
    airline: 'RideFi Air',
    airlineIata: 'RF',
    departureIata: 'JFK',
    departureAirport: 'John F. Kennedy International Airport',
    arrivalIata: 'LAX',
    arrivalAirport: 'Los Angeles International Airport',
  );
}
