import 'package:flutter_test/flutter_test.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/home_search_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/trip_type_selector.dart';

void main() {
  group('HomeSearchNotifier', () {
    test('starts with expected default values', () {
      final notifier = HomeSearchNotifier();

      expect(notifier.state.tripType, TripType.oneWay);
      expect(notifier.state.travelClass, 'Economy');
      expect(notifier.state.passengers, 1);
      expect(notifier.isValid, isFalse);
    });

    test('setters update state and validity', () {
      final notifier = HomeSearchNotifier();
      final departureDate = DateTime(2026, 3, 19);

      notifier
        ..setFrom('JFK')
        ..setTo('LAX')
        ..setTripType(TripType.roundTrip)
        ..setDepartureDate(departureDate)
        ..setDirectFlightsOnly(true)
        ..setIncludeNearbyAirports(true)
        ..setTravelClass('Business')
        ..setPassengers(3);

      expect(notifier.isValid, isTrue);
      expect(notifier.state.from, 'JFK');
      expect(notifier.state.to, 'LAX');
      expect(notifier.state.tripType, TripType.roundTrip);
      expect(notifier.state.departureDate, departureDate);
      expect(notifier.state.directFlightsOnly, isTrue);
      expect(notifier.state.includeNearbyAirports, isTrue);
      expect(notifier.state.travelClass, 'Business');
      expect(notifier.state.passengers, 3);
    });

    test('isValid is false when one endpoint is missing', () {
      final notifierWithFromOnly = HomeSearchNotifier();
      final notifierWithToOnly = HomeSearchNotifier();

      notifierWithFromOnly.setFrom('JFK');
      expect(notifierWithFromOnly.isValid, isFalse);

      notifierWithToOnly.setTo('LAX');
      expect(notifierWithToOnly.isValid, isFalse);
    });
  });
}
