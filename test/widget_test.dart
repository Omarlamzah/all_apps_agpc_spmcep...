import 'package:congress_app/src/app.dart';
import 'package:congress_app/src/config/app_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows features enabled for the selected congress', (
    tester,
  ) async {
    final brand = AppBrand.brands['agpc']!;
    await tester.pumpWidget(
      CongressApp(brand: brand, brandLoader: (_) async => brand),
    );
    await tester.pumpAndSettle();

    expect(find.text('AGPC ANNUAL CONGRESS'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(find.text('Programme'), findsWidgets);
    expect(find.text('Informations'), findsOneWidget);
    expect(find.text('E-Posters'), findsOneWidget);
    expect(find.text('Live voting'), findsNothing);
    expect(find.text('Floor plan'), findsNothing);
  });
}
