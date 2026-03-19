import 'package:flutter/material.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';

class FeatureInfoRow extends StatelessWidget {
  const FeatureInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.subtitleColor,
    super.key,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconTheme(
              data: const IconThemeData(
                color: Color(0xFF64748B),
                size: 22,
              ),
              child: icon,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: titleColor ?? const Color(0xFF1E293B),
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: AppTypography.body2.copyWith(
                      color: subtitleColor ?? const Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
