import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight_search_params.dart';

enum FlightSearchStatus {
  initial,
  loading,
  success,
  failure,
  empty,
  loadingMore,
}

class FlightSearchState {
  const FlightSearchState({
    this.status = FlightSearchStatus.initial,
    this.flights = const [],
    this.errorMessage,
    this.params,
    this.selectedFlight,
    this.hasMore = false,
    this.totalCount = 0,
  });

  final FlightSearchStatus status;
  final List<Flight> flights;
  final String? errorMessage;
  final FlightSearchParams? params;
  final Flight? selectedFlight;
  final bool hasMore;
  final int totalCount;

  bool get isLoading =>
      status == FlightSearchStatus.loading ||
      status == FlightSearchStatus.loadingMore;
  bool get isLoadingMore => status == FlightSearchStatus.loadingMore;
  bool get hasError => status == FlightSearchStatus.failure;
  bool get isEmpty => status == FlightSearchStatus.empty;
  bool get hasResults => status == FlightSearchStatus.success;

  FlightSearchState copyWith({
    FlightSearchStatus? status,
    List<Flight>? flights,
    String? errorMessage,
    FlightSearchParams? params,
    Flight? selectedFlight,
    bool? hasMore,
    int? totalCount,
  }) {
    return FlightSearchState(
      status: status ?? this.status,
      flights: flights ?? this.flights,
      errorMessage: errorMessage ?? this.errorMessage,
      params: params ?? this.params,
      selectedFlight: selectedFlight ?? this.selectedFlight,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
