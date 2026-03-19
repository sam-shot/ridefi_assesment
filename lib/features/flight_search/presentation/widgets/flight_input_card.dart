import 'package:flutter/material.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';

class FlightInputCard extends StatelessWidget {
  const FlightInputCard({
    required this.label,
    required this.onTap,
    this.value,
    this.hint,
    this.icon,
    super.key,
  });

  final String label;
  final String? value;
  final String? hint;
  final Widget? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? value! : (hint ?? label),
                style: AppTypography.body1.copyWith(
                  color: hasValue
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF94A3B8),
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            ?icon,
          ],
        ),
      ),
    );
  }
}
