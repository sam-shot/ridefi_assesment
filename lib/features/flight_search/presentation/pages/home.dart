import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ridefi_assessment/app/router.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/core/widget/app_button.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/airport.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight_search_params.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/flight_search_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/home_search_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/airport_search_sheet.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/filter_switch_row.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/flight_input_card.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/trip_type_selector.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(homeSearchProvider);
    final notifier = ref.read(homeSearchProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const AutoLeadingButton(
          color: Color(0xFF1E293B),
        ),
        title: Text(
          'Search Flights',
          style: AppTypography.h3.copyWith(
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.blueAccent),
            onPressed: () => context.router.push(const FavoritesRoute()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(24),

              FlightInputCard(
                label: 'From',
                value: searchState.from,
                hint: 'From',
                icon: const Icon(
                  Icons.unfold_more,
                  color: Color(0xFF64748B),
                  size: 22,
                ),
                onTap: () => _showAirportSearch(context, ref, true),
              ),
              const Gap(12),

              FlightInputCard(
                label: 'To',
                value: searchState.to,
                hint: 'To',
                icon: const Icon(
                  Icons.unfold_more,
                  color: Color(0xFF64748B),
                  size: 22,
                ),
                onTap: () => _showAirportSearch(context, ref, false),
              ),
              const Gap(20),

              TripTypeSelector(
                selectedType: searchState.tripType,
                onChanged: notifier.setTripType,
              ),
              const Gap(20),

              FlightInputCard(
                label: 'Departure Date',
                value: searchState.departureDate != null
                    ? DateFormat(
                        'EEE, d MMM yyyy',
                      ).format(searchState.departureDate!)
                    : null,
                hint: 'Departure Date',
                onTap: () => _selectDate(context, ref),
              ),
              const Gap(28),

              Text(
                'Optional Filters',
                style: AppTypography.h3.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const Gap(8),

              FilterSwitchRow(
                label: 'Direct Flights Only',
                value: searchState.directFlightsOnly,
                onChanged: notifier.setDirectFlightsOnly,
              ),
              FilterSwitchRow(
                label: 'Include Nearby Airports',
                value: searchState.includeNearbyAirports,
                onChanged: notifier.setIncludeNearbyAirports,
              ),

              _buildInfoRow(
                'Travel Class',
                searchState.travelClass,
              ),

              _buildInfoRow(
                'Passengers',
                searchState.passengers.toString(),
              ),

              const Gap(60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: AppButton(
          onPressed: () => _onSearch(context, ref),
          text: 'Search Flights',
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF374151),
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _onSearch(BuildContext context, WidgetRef ref) {
    final searchState = ref.read(homeSearchProvider);
    if (searchState.from == null || searchState.to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both cities.'),
        ),
      );
      return;
    }

    final params = FlightSearchParams(
      departureIata: searchState.from!.toUpperCase(),
      arrivalIata: searchState.to!.toUpperCase(),
    );

    ref.read(flightSearchProvider.notifier).search(params);
    context.router.push(const FlightResultsRoute());
  }

  Future<void> _selectDate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(homeSearchProvider.notifier).setDepartureDate(picked);
    }
  }

  Future<void> _showAirportSearch(
    BuildContext context,
    WidgetRef ref,
    bool isFrom,
  ) async {
    final searchState = ref.read(homeSearchProvider);
    final excludedIata = isFrom ? searchState.to : searchState.from;

    final airport = await showModalBottomSheet<Airport>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AirportSearchSheet(excludedIata: excludedIata),
    );

    if (airport != null) {
      final notifier = ref.read(homeSearchProvider.notifier);
      if (isFrom) {
        notifier.setFrom(airport.iataCode);
      } else {
        notifier.setTo(airport.iataCode);
      }
    }
  }
}
