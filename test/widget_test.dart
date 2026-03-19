import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/widgets/trip_type_selector.dart';

void main() {
	testWidgets('TripTypeSelector shows tabs and reports selection changes', (
		tester,
	) async {
		TripType? selectedType;

		await tester.pumpWidget(
			MaterialApp(
				home: Scaffold(
					body: TripTypeSelector(
						selectedType: TripType.oneWay,
						onChanged: (value) => selectedType = value,
					),
				),
			),
		);

		expect(find.text('One way'), findsOneWidget);
		expect(find.text('Round trip'), findsOneWidget);
		expect(find.text('Multi-City'), findsOneWidget);

		await tester.tap(find.text('Round trip'));
		await tester.pumpAndSettle();

		expect(selectedType, TripType.roundTrip);
	});
}

