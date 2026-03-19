// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/features/flight_search/domain/models/home_search_state.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/trip_type_selector.dart';

final homeSearchProvider =
    StateNotifierProvider<HomeSearchNotifier, HomeSearchState>((ref) {
      return HomeSearchNotifier();
    });

class HomeSearchNotifier extends StateNotifier<HomeSearchState> {
  HomeSearchNotifier()
    : super(const HomeSearchState(tripType: TripType.oneWay));

  bool get isValid => state.from != null && state.to != null;
  void setDepartureDate(DateTime? date) =>
      state = state.copyWith(departureDate: date);
  void setDirectFlightsOnly(bool value) =>
      state = state.copyWith(directFlightsOnly: value);
  void setFrom(String? from) => state = state.copyWith(from: from);
  void setIncludeNearbyAirports(bool value) =>
      state = state.copyWith(includeNearbyAirports: value);
  void setPassengers(int value) => state = state.copyWith(passengers: value);
  void setTo(String? to) => state = state.copyWith(to: to);
  void setTravelClass(String value) =>
      state = state.copyWith(travelClass: value);

  void setTripType(TripType type) => state = state.copyWith(tripType: type);
}
