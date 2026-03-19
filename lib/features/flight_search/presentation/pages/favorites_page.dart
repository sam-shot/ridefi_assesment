import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/app/router.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/favorites_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/flight_search_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/flight_result_card.dart';

@RoutePage()
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => context.router.back(),
        ),
        title: Text(
          'Saved Flights',
          style: AppTypography.h3.copyWith(
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text(
                'No favorite flights yet.',
                style: AppTypography.body1.copyWith(color: const Color(0xFF6B7280)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final flight = favorites[index];
                return FlightResultCard(
                  flight: flight,
                  onTap: () {
                    ref.read(flightSearchProvider.notifier).selectFlight(flight);
                    context.router.push(const FlightDetailsRoute());
                  },
                );
              },
            ),
    );
  }
}
