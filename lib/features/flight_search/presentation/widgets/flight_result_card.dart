import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/features/flight_search/domain/entities/flight.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/providers/favorites_provider.dart';

class FlightResultCard extends ConsumerWidget {
  const FlightResultCard({
    required this.flight,
    required this.onTap,
    super.key,
  });

  final Flight flight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref
        .watch(favoritesProvider)
        .any((f) => f.flightIata == flight.flightIata);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: flight.airlineLogoUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A88),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          flight.airline,
                          style: AppTypography.h2.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, e) => Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A88),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          flight.airline,
                          style: AppTypography.h2.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${flight.priceLabel ?? r'$320'} · Economy',
                      style: AppTypography.body2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(favoritesProvider.notifier).toggle(flight);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : const Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              flight.stops == 0
                  ? 'Non-stop'
                  : '${flight.stops} Stop${flight.stops > 1 ? 's' : ''}',
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF3B82F6),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              flight.airline,
              style: AppTypography.h4.copyWith(
                color: const Color(0xFF1E293B),
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '${flight.departureIata} '
              '${flight.scheduledDepartureTime} · '
              '${flight.arrivalIata} '
              '${flight.scheduledArrivalTime} · '
              '${flight.durationLabel}',
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF6B7280),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
