import 'package:flutter/material.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';

class FlightRouteSummary extends StatelessWidget {
  const FlightRouteSummary({
    required this.departureIata,
    required this.departureCity,
    required this.arrivalIata,
    required this.arrivalCity,
    super.key,
  });

  final String departureIata;
  final String departureCity;
  final String arrivalIata;
  final String arrivalCity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCityInfo(
          departureIata,
          departureCity,
          CrossAxisAlignment.start,
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Transform.rotate(
            angle: 1.5708 / 2, // 45 degrees
            child: const Icon(
              Icons.airplanemode_active,
              color: Color(0xFF1E293B),
              size: 22,
            ),
          ),
        ),
        _buildCityInfo(
          arrivalIata,
          arrivalCity,
          CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Widget _buildCityInfo(
    String iata,
    String city,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          iata,
          style: AppTypography.h2.copyWith(
            fontSize: 22,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          city,
          style: AppTypography.body2.copyWith(
            color: const Color(0xFF3B82F6),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
