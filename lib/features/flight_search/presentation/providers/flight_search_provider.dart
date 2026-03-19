// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/app/injection.dart';
import 'package:ridefi_assessment/features/flight_search/data/repositories/flight_repository.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/airport.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight_search_params.dart';
import 'package:ridefi_assessment/features/flight_search/domain/models/flight_search_state.dart';

final airportsProvider = AsyncNotifierProvider<AirportsNotifier, List<Airport>>(
  () {
    return AirportsNotifier();
  },
);

final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  return locator<FlightRepository>();
});

final flightSearchProvider =
    StateNotifierProvider<FlightSearchNotifier, FlightSearchState>((ref) {
      return FlightSearchNotifier(locator<FlightRepository>());
    });

class AirportsNotifier extends AsyncNotifier<List<Airport>> {
  int _offset = 0;
  final int _limit = 100;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  FutureOr<List<Airport>> build() async {
    return _fetchPage(0);
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.hasError) {
      return;
    }

    _isLoadingMore = true;
    try {
      final newAirports = await _fetchPage(_offset + _limit);
      _offset += _limit;
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, ...newAirports]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<List<Airport>> _fetchPage(int offset) async {
    final repo = ref.read(flightRepositoryProvider);
    final response = await repo.getAirports(limit: _limit, offset: offset);
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Failed to load airports');
    }

    final data = response.data ?? [];
    _hasMore = data.length >= _limit;
    return data;
  }
}

class FlightSearchNotifier extends StateNotifier<FlightSearchState> {
  FlightSearchNotifier(this._repository) : super(const FlightSearchState());

  final FlightRepository _repository;

  void clearSelectedFlight() {
    state = FlightSearchState(
      status: state.status,
      flights: state.flights,
      params: state.params,
      hasMore: state.hasMore,
      totalCount: state.totalCount,
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    final nextParams = state.params!.nextPage();
    state = state.copyWith(status: FlightSearchStatus.loadingMore);

    final response = await _repository.searchFlights(nextParams);

    if (response.success) {
      final newFlights = response.data!;
      state = state.copyWith(
        status: FlightSearchStatus.success,
        flights: [...state.flights, ...newFlights],
        params: nextParams,
        hasMore: newFlights.length >= nextParams.limit,
        totalCount: state.totalCount + newFlights.length,
      );
    } else {
      state = state.copyWith(status: FlightSearchStatus.success);
    }
  }

  void reset() {
    state = const FlightSearchState();
  }

  Future<void> search(FlightSearchParams params) async {
    state = state.copyWith(
      status: FlightSearchStatus.loading,
      flights: [],
      params: params,
      hasMore: false,
    );

    final response = await _repository.searchFlights(params);

    if (response.success) {
      final flights = response.data!;
      state = state.copyWith(
        status: flights.isEmpty
            ? FlightSearchStatus.empty
            : FlightSearchStatus.success,
        flights: flights,
        hasMore: flights.length >= params.limit,
        totalCount: flights.length,
      );
    } else {
      state = state.copyWith(
        status: FlightSearchStatus.failure,
        errorMessage: response.error?.message ?? 'Something went wrong.',
      );
    }
  }

  void selectFlight(Flight flight) {
    state = state.copyWith(selectedFlight: flight);
  }
}
