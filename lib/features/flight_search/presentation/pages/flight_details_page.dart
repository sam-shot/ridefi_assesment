import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ridefi_assessment/core/gen_assets/assets.gen.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/core/widget/app_button.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/favorites_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/flight_search_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/feature_info_row.dart';

@RoutePage()
class FlightDetailsPage extends ConsumerWidget {
  const FlightDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flight = ref.watch(flightSearchProvider).selectedFlight;

    if (flight == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'No flight selected.',
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Color(0xFF1E293B),
          ),
          onPressed: () => context.router.back(),
        ),
        title: Text(
          'Flight Details',
          style: AppTypography.h3.copyWith(
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(favoritesProvider.notifier).isFavorite(flight.flightIata)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: const Color(0xFF1E293B),
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggle(flight);
              // rebuild manually for the synchronous UI feedback since we watch the list
              // oh wait, we can just watch the provider to rebuild
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(8),

                  FeatureInfoRow(
                    icon: CircleAvatar(
                      backgroundColor: const Color(0xFF0F172A),
                      radius: 18,
                      child: Text(
                        flight.airline.isNotEmpty ? flight.airline[0] : '?',
                        style: AppTypography.body1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: flight.airline,
                    subtitle: 'Flight Number: ${flight.flightIata}',
                  ),

                  FeatureInfoRow(
                    icon: const Icon(
                      Icons.airplanemode_active,
                    ),
                    title: 'Aircraft Type',
                    subtitle: flight.aircraftIata ?? 'Boeing 737',
                  ),

                  const Gap(16),

                  _buildSectionHeader('Flight Information'),
                  const Gap(4),

                  const FeatureInfoRow(
                    icon: Icon(Icons.chair_alt),
                    title: 'Seat Class',
                    subtitle: 'Economy',
                  ),
                  FeatureInfoRow(
                    icon: const Icon(Icons.schedule),
                    title: 'Total Duration',
                    subtitle: flight.durationLabel,
                  ),
                  FeatureInfoRow(
                    icon: const Icon(Icons.location_on),
                    title: 'Layovers and Stops',
                    subtitle: flight.stops == 0
                        ? 'Direct'
                        : '${flight.stops} stop',
                  ),

                  const Gap(20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color(0xFFF1F5F9),
                      child: Assets.images.map.image(),
                    ),
                  ),

                  const Gap(24),

                  _buildSectionHeader('Baggage Information'),
                  const Gap(4),

                  const FeatureInfoRow(
                    icon: Icon(Icons.luggage),
                    title: 'Checked Baggage',
                    subtitle: '1 checked bag',
                  ),
                  const FeatureInfoRow(
                    icon: Icon(Icons.shopping_bag_outlined),
                    title: 'Carry-on Baggage',
                    subtitle: '1 carry-on',
                  ),

                  const Gap(20),

                  _buildSectionHeader('Policies'),
                  const Gap(4),

                  const FeatureInfoRow(
                    icon: Icon(Icons.description_outlined),
                    title: 'Cancellation Policy',
                    subtitle: '',
                  ),
                  const FeatureInfoRow(
                    icon: Icon(Icons.description_outlined),
                    title: 'Refund Policy',
                    subtitle: '',
                  ),

                  const Gap(20),

                  _buildSectionHeader('Amenities'),
                  const Gap(4),

                  const FeatureInfoRow(
                    icon: Icon(Icons.tv),
                    title: 'In-flight Entertainment',
                    subtitle: '',
                  ),
                  const FeatureInfoRow(
                    icon: Icon(Icons.wifi),
                    title: 'Wi-Fi',
                    subtitle: '',
                  ),
                  const FeatureInfoRow(
                    icon: Icon(Icons.restaurant),
                    title: 'Meals',
                    subtitle: '',
                  ),

                  const Gap(32),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: AppButton(
              onPressed: () {},
              text: 'Continue to Book',
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        fontSize: 17,
        color: const Color(0xFF1E293B),
      ),
    );
  }
}
