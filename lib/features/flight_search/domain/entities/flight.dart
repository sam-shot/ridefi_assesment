// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:intl/intl.dart';

class Flight {
  const Flight({
    required this.flightIata,
    required this.flightNumber,
    required this.airline,
    required this.airlineIata,
    required this.departureIata,
    required this.departureAirport,
    required this.arrivalIata,
    required this.arrivalAirport,
    this.scheduledDeparture,
    this.scheduledArrival,
    this.status,
    this.aircraftIata,
    this.stops = 0,
    this.terminal,
    this.gate,
    this.priceLabel,
    this.departureCity,
    this.arrivalCity,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    final flight = json['flight'] as Map<String, dynamic>? ?? {};
    final airline = json['airline'] as Map<String, dynamic>? ?? {};
    final departure = json['departure'] as Map<String, dynamic>? ?? {};
    final arrival = json['arrival'] as Map<String, dynamic>? ?? {};
    final aircraft = json['aircraft'] as Map<String, dynamic>? ?? {};

    return Flight(
      flightIata: flight['iata']?.toString() ?? 'UNKNOWN',
      flightNumber: flight['number']?.toString() ?? 'N/A',
      airline: airline['name']?.toString() ?? 'Unknown Airline',
      airlineIata: airline['iata']?.toString() ?? '',
      departureIata: departure['iata']?.toString() ?? '',
      departureAirport: departure['airport']?.toString() ?? '',
      arrivalIata: arrival['iata']?.toString() ?? '',
      arrivalAirport: arrival['airport']?.toString() ?? '',
      scheduledDeparture: DateTime.tryParse(
        departure['scheduled']?.toString() ?? '',
      ),
      scheduledArrival: DateTime.tryParse(
        arrival['scheduled']?.toString() ?? '',
      ),
      status: json['flight_status']?.toString(),
      aircraftIata: aircraft['iata']?.toString(),
      terminal: departure['terminal']?.toString(),
      gate: departure['gate']?.toString(),
    );
  }

  final String flightIata;
  final String flightNumber;
  final String airline;
  final String airlineIata;
  final String departureIata;
  final String departureAirport;
  final String arrivalIata;
  final String arrivalAirport;
  final DateTime? scheduledDeparture;
  final DateTime? scheduledArrival;
  final String? status;
  final String? aircraftIata;
  final int stops;
  final String? terminal;
  final String? gate;
  final String? priceLabel;
  final String? departureCity;
  final String? arrivalCity;

  String get airlineLogoUrl =>
      'https://images.kiwi.com/airlines/64/$airlineIata.png';

  String get durationLabel {
    final mins = durationMinutes;
    if (mins == null || mins <= 0) return 'N/A';
    final h = mins ~/ 60;
    final m = mins % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  int? get durationMinutes {
    if (scheduledDeparture == null || scheduledArrival == null) return null;
    return scheduledArrival!.difference(scheduledDeparture!).inMinutes;
  }

  @override
  int get hashCode => flightIata.hashCode;

  String get scheduledArrivalTime => scheduledArrival != null
      ? DateFormat('h:mm a').format(scheduledArrival!)
      : 'N/A';

  String get scheduledDepartureTime => scheduledDeparture != null
      ? DateFormat('h:mm a').format(scheduledDeparture!)
      : 'N/A';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Flight &&
          runtimeType == other.runtimeType &&
          flightIata == other.flightIata;

  Flight copyWith({
    String? flightIata,
    String? flightNumber,
    String? airline,
    String? airlineIata,
    String? departureIata,
    String? departureAirport,
    String? arrivalIata,
    String? arrivalAirport,
    DateTime? scheduledDeparture,
    DateTime? scheduledArrival,
    String? status,
    String? aircraftIata,
    int? stops,
    String? terminal,
    String? gate,
    String? priceLabel,
    String? departureCity,
    String? arrivalCity,
  }) {
    return Flight(
      flightIata: flightIata ?? this.flightIata,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      airlineIata: airlineIata ?? this.airlineIata,
      departureIata: departureIata ?? this.departureIata,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalIata: arrivalIata ?? this.arrivalIata,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      scheduledDeparture: scheduledDeparture ?? this.scheduledDeparture,
      scheduledArrival: scheduledArrival ?? this.scheduledArrival,
      status: status ?? this.status,
      aircraftIata: aircraftIata ?? this.aircraftIata,
      stops: stops ?? this.stops,
      terminal: terminal ?? this.terminal,
      gate: gate ?? this.gate,
      priceLabel: priceLabel ?? this.priceLabel,
      departureCity: departureCity ?? this.departureCity,
      arrivalCity: arrivalCity ?? this.arrivalCity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flight': {'iata': flightIata, 'number': flightNumber},
      'airline': {'name': airline, 'iata': airlineIata},
      'departure': {
        'iata': departureIata,
        'airport': departureAirport,
        'scheduled': scheduledDeparture?.toIso8601String(),
        'terminal': terminal,
        'gate': gate,
      },
      'arrival': {
        'iata': arrivalIata,
        'airport': arrivalAirport,
        'scheduled': scheduledArrival?.toIso8601String(),
      },
      'flight_status': status,
      'aircraft': {'iata': aircraftIata},
      'custom_info': {
        'stops': stops,
        'priceLabel': priceLabel,
        'departureCity': departureCity,
        'arrivalCity': arrivalCity,
      },
    };
  }
}
