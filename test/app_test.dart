import 'package:custom_address/app.dart';
import 'package:custom_address/features/nepal_admin/data/nepal_administrative_repository.dart';
import 'package:custom_address/features/nepal_admin/model/nepal_administrative_hierarchy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders only cascading dropdowns', (tester) async {
    await tester.pumpWidget(
      CustomAddressApp(repository: _FakeNepalAdministrativeRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('province_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('district_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('local_level_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('ward_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('area_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('building_dropdown')), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koshi').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Morang').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Biratnagar Metropolitan City').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ward 1').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pichhara').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('House 12').last);
    await tester.pumpAndSettle();

    expect(find.text('Biratnagar Metropolitan City'), findsWidgets);
    expect(find.text('Pichhara'), findsWidgets);
    expect(find.text('House 12'), findsWidgets);
  });
}

class _FakeNepalAdministrativeRepository
    implements NepalAdministrativeRepository {
  @override
  Future<NepalAdministrativeHierarchy> loadHierarchy() async {
    return const NepalAdministrativeHierarchy(
      metadata: HierarchyMetadata(
        country: 'Nepal',
        description: 'Test hierarchy',
        dataScope: 'Test scope',
        wardLevelNote: 'Test note',
        lastUpdated: '2026-04-23',
        sources: [],
      ),
      overview: HierarchyOverview(
        provinces: 1,
        districts: 2,
        localLevels: LocalLevelBreakdown(
          total: 1,
          metropolises: 1,
          subMetropolises: 0,
          municipalities: 0,
          ruralMunicipalities: 0,
        ),
        wards: WardBreakdown(
          total: 2,
          minimumPerLocalLevel: 2,
          maximumPerLocalLevel: 2,
        ),
      ),
      provinces: [
        Province(
          name: 'Koshi',
          districts: [
            District(name: 'Bhojpur', localLevels: []),
            District(
              name: 'Morang',
              localLevels: [
                LocalLevel(
                  name: 'Biratnagar Metropolitan City',
                  type: 'Metropolitan City',
                  wards: [
                    WardEntry(
                      number: 1,
                      areas: [
                        AreaEntry(
                          name: 'Pichhara',
                          buildings: ['House 12', 'House 14'],
                        ),
                      ],
                    ),
                    WardEntry(
                      number: 2,
                      areas: [
                        AreaEntry(name: 'Shankarapur', buildings: ['House 2']),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
