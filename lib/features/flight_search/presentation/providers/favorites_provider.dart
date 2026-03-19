import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/app/injection.dart';
import 'package:ridefi_assessment/features/flight_search/data/services/favorites_service.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Flight>>(
  (ref) {
    return FavoritesNotifier(locator<FavoritesService>());
  },
);

class FavoritesNotifier extends StateNotifier<List<Flight>> {
  FavoritesNotifier(this._service) : super([]) {
    _load();
  }

  final FavoritesService _service;

  bool isFavorite(String flightIata) => state.any((f) => f.flightIata == flightIata);

  Future<void> toggle(Flight flight) async {
    if (isFavorite(flight.flightIata)) {
      await _service.removeFavorite(flight.flightIata);
      state = state.where((f) => f.flightIata != flight.flightIata).toList();
    } else {
      await _service.addFavorite(flight);
      state = [...state, flight];
    }
  }

  Future<void> _load() async {
    final favorites = await _service.loadFavorites();
    state = favorites;
  }
}
