import 'package:injectable/injectable.dart';
import 'package:ridefi_assessment/core/services/database_service.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';

@LazySingleton()
class FavoritesService {
  FavoritesService(this._databaseService);

  static const String _boxName = 'favorites_box';
  final DatabaseService _databaseService;

  Future<void> addFavorite(Flight flight) async {
    await _databaseService.put(_boxName, flight.flightIata, flight.toJson());
  }

  Future<void> clearFavorites() async {
    await _databaseService.clear(_boxName);
  }

  Future<List<Flight>> loadFavorites() async {
    final results = await _databaseService.getAll(_boxName);
    return results.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return Flight.fromJson(map);
    }).toList();
  }

  Future<void> removeFavorite(String flightIata) async {
    await _databaseService.delete(_boxName, flightIata);
  }
}
