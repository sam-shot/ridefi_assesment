import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/flight_search_provider.dart';

class AirportSearchSheet extends ConsumerStatefulWidget {
  const AirportSearchSheet({
    super.key,
    this.excludedIata,
  });

  final String? excludedIata;

  @override
  ConsumerState<AirportSearchSheet> createState() => _AirportSearchSheetState();
}

class _AirportSearchSheetState extends ConsumerState<AirportSearchSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final airportsAsyncValue = ref.watch(airportsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Select Airport',
            style: AppTypography.h3.copyWith(
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _controller,
            autofocus: true,
            style: AppTypography.body1.copyWith(
              color: const Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              hintText: 'Search city or airport...',
              hintStyle: AppTypography.body2.copyWith(
                color: const Color(0xFF94A3B8),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: (val) {
              setState(() {
                _query = val.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 16),

          Expanded(
            child: airportsAsyncValue.when(
              data: (airports) {
                final filtered = airports.where((a) {
                  if (widget.excludedIata != null &&
                      a.iataCode.toUpperCase() ==
                          widget.excludedIata!.toUpperCase()) {
                    return false;
                  }

                  if (_query.isEmpty) return true;

                  return a.airportName.toLowerCase().contains(_query) ||
                      a.iataCode.toLowerCase().contains(_query) ||
                      (a.cityName?.toLowerCase().contains(_query) ?? false);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No airports found.',
                      style: AppTypography.body1.copyWith(
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      filtered.length +
                      (airportsAsyncValue.isLoading && filtered.isNotEmpty
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index == filtered.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      );
                    }

                    final airport = filtered[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      title: Text(
                        airport.airportName,
                        style: AppTypography.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        '${airport.cityName ?? ''} · ${airport.iataCode}',
                        style: AppTypography.body2.copyWith(
                          color: const Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, airport),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.airplanemode_active,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3B82F6),
                ),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Failed to load airports',
                  style: AppTypography.body1.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(airportsProvider.notifier).loadMore();
    }
  }
}
