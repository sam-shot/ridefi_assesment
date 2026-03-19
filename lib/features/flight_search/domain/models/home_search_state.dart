import 'package:ridefi_assessment/features/flight_search/presentation/widgets/trip_type_selector.dart';

class HomeSearchState {
  const HomeSearchState({
    required this.tripType,
    this.from,
    this.to,
    this.departureDate,
    this.directFlightsOnly = false,
    this.includeNearbyAirports = false,
    this.travelClass = 'Economy',
    this.passengers = 1,
  });

  final TripType tripType;
  final String? from;
  final String? to;
  final DateTime? departureDate;
  final bool directFlightsOnly;
  final bool includeNearbyAirports;
  final String travelClass;
  final int passengers;

  HomeSearchState copyWith({
    TripType? tripType,
    String? from,
    String? to,
    DateTime? departureDate,
    bool? directFlightsOnly,
    bool? includeNearbyAirports,
    String? travelClass,
    int? passengers,
  }) {
    return HomeSearchState(
      tripType: tripType ?? this.tripType,
      from: from ?? this.from,
      to: to ?? this.to,
      departureDate: departureDate ?? this.departureDate,
      directFlightsOnly: directFlightsOnly ?? this.directFlightsOnly,
      includeNearbyAirports:
          includeNearbyAirports ?? this.includeNearbyAirports,
      travelClass: travelClass ?? this.travelClass,
      passengers: passengers ?? this.passengers,
    );
  }
}
