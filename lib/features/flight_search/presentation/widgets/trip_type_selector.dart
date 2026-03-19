import 'package:flutter/material.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';

enum TripType {
  oneWay(label: 'One way'),
  roundTrip(label: 'Round trip'),
  multiCity(label: 'Multi-City');

  const TripType({required this.label});
  final String label;
}

class TripTypeSelector extends StatelessWidget {
  const TripTypeSelector({
    required this.selectedType,
    required this.onChanged,
    super.key,
  });

  final TripType selectedType;
  final ValueChanged<TripType> onChanged;

  @override
  Widget build(BuildContext context) {
    final initialIndex =
        TripType.values.indexOf(selectedType).clamp(0, 2);

    return DefaultTabController(
      length: TripType.values.length,
      initialIndex: initialIndex,
      child: Builder(
        builder: (context) {
          final controller = DefaultTabController.of(context);
          controller.addListener(() {
            if (controller.indexIsChanging) {
              onChanged(TripType.values[controller.index]);
            }
          });

          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            height: 44,
            child: TabBar(
              onTap: (index) =>
                  onChanged(TripType.values[index]),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: const Color(0xFF1E293B),
              unselectedLabelColor: const Color(0xFF94A3B8),
              labelStyle: AppTypography.body2.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTypography.body2.copyWith(
                fontWeight: FontWeight.w400,
              ),
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              tabs: TripType.values
                  .map((type) => Tab(text: type.label))
                  .toList(),
              splashFactory: NoSplash.splashFactory,
              overlayColor:
                  WidgetStateProperty.all(Colors.transparent),
            ),
          );
        },
      ),
    );
  }
}
