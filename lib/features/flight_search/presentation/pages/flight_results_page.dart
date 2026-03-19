import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ridefi_assessment/app/router.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/features/flight_search/domain/models/flight_search_state.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/flight_search_provider.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/flight_result_card.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/flight_route_summary.dart';

@RoutePage()
class FlightResultsPage extends ConsumerStatefulWidget {
  const FlightResultsPage({super.key});

  @override
  ConsumerState<FlightResultsPage> createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends ConsumerState<FlightResultsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flightSearchProvider);

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
          'Flights',
          style: AppTypography.h3.copyWith(
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, state),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildBody(
    BuildContext context,
    FlightSearchState state,
  ) {
    if (state.status == FlightSearchStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3B82F6),
        ),
      );
    }

    if (state.status == FlightSearchStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.errorMessage ?? 'Error occurred',
            textAlign: TextAlign.center,
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    if (state.flights.isEmpty) {
      return Center(
        child: Text(
          'No flights found.',
          style: AppTypography.body1.copyWith(
            color: const Color(0xFF6B7280),
          ),
        ),
      );
    }

    final firstFlight = state.flights.first;

    return Column(
      children: [
        const Gap(16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FlightRouteSummary(
            departureIata: firstFlight.departureIata,
            departureCity: firstFlight.departureCity ?? '',
            arrivalIata: firstFlight.arrivalIata,
            arrivalCity: firstFlight.arrivalCity ?? '',
          ),
        ),
        const Gap(20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Fri, Jul 12 · 1 Adult',
              style: AppTypography.h4.copyWith(
                color: const Color(0xFF1E293B),
                fontSize: 16,
              ),
            ),
          ),
        ),
        const Gap(16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort & Filter',
                style: AppTypography.body1.copyWith(
                  color: const Color(0xFF374151),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              const Icon(
                Icons.tune,
                color: Color(0xFF374151),
                size: 22,
              ),
            ],
          ),
        ),
        const Gap(20),

        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount:
                state.flights.length +
                (state.status == FlightSearchStatus.loadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.flights.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                );
              }

              final flight = state.flights[index];
              return FlightResultCard(
                flight: flight,
                onTap: () {
                  ref.read(flightSearchProvider.notifier).selectFlight(flight);
                  context.router.push(const FlightDetailsRoute());
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(flightSearchProvider.notifier).loadMore();
    }
  }
}
