import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_challenge/src/data/models/asset.dart';
import 'package:tractian_challenge/src/data/models/location.dart';
import 'package:tractian_challenge/src/features/company/pages/company_assets_page.dart';
import 'package:tractian_challenge/src/widgets/tractian_tree_view.dart';

void main() {
  group('TractianTreeView Widget Tests', ()
  {
    late List<Location> mockLocations;
    late List<Asset> mockAssets;
    late Set<AssetsFilter> filters;

    setUp(() {
      // Configuração básica para todos os testes
      mockLocations = [
        Location('loc1', 'Location 1', null),
        Location('loc2', 'Location 2', 'loc1'),
      ];
      mockAssets = [
        Asset('asset1', 'Asset 1', parentId: 'loc2',
            sensorType: 'Temperature',
            status: 'alert'),
        Asset('asset2', 'Asset 2', locationId: 'loc1'),
        Asset('asset3', 'Asset 3', sensorType: 'Energy', sensorId: 'MTC052', gatewayId: 'GWT001', status: 'operating'),
      ];

      filters = <AssetsFilter>{};
    });

    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TractianTreeView(
              root: buildTree(mockLocations, mockAssets, filters, ''),
            ),
          ),
        ),
      );

      expect(find.byType(TractianTreeView), findsOneWidget);
    });

    testWidgets('Tap on Asset shows dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TractianTreeView(
              root: buildTree(mockLocations, mockAssets, filters, ''),
            ),
          ),
        ),
      );
      expect(find.byType(ExpansionTile), findsNWidgets(1));
      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Asset 2'));
      await tester.pumpAndSettle();

      //Verifica se o dialogo é exibido
      expect(find.byType(AlertDialog), findsOneWidget);

    });

    testWidgets('Should filter tree by Energy Sensors', (WidgetTester tester) async {
      filters.add(AssetsFilter.energySensors);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TractianTreeView(
              root: buildTree(mockLocations, mockAssets, filters, ''),
            ),
          ),
        ),
      );

      expect(find.text('Asset 3'), findsOneWidget);
      expect(find.text('Asset 1'), findsNothing);
      expect(find.text('Asset 2'), findsNothing);
    });

    testWidgets('Should filter tree by Critical', (WidgetTester tester) async {
      filters.add(AssetsFilter.critics);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TractianTreeView(
              root: buildTree(mockLocations, mockAssets, filters, ''),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Location 2'));
      await tester.pumpAndSettle();

      expect(find.text('Asset 1'), findsOneWidget);
      expect(find.text('Asset 2'), findsNothing);
      expect(find.text('Asset 3'), findsNothing);
    });

  });
}
