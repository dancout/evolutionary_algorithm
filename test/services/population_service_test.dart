import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const populationSize = 100;
  const wave = 1;
  final Entity mockEntity = MockEntity();

  late EntityService mockEntityService;
  late SelectionService mockSelectionService;
  late PopulationService testObject;

  setUp(() async {
    mockEntityService = MockEntityService();
    mockSelectionService = MockSelectionService();

    testObject = PopulationService(
      entityService: mockEntityService,
      selectionService: mockSelectionService,
    );
  });

  group('randomPopulation', () {
    test('returns a population with correct number of entities', () async {
      when(() => mockEntityService.randomEntity())
          .thenAnswer((_) async => mockEntity);

      final List<Entity> entities = [];
      for (int i = 0; i < populationSize; i++) {
        entities.add(mockEntity);
      }
      final expected = Population(entities: entities);

      final actual =
          await testObject.randomPopulation(populationSize: populationSize);

      expect(actual, expected);

      verify(() => mockEntityService.randomEntity()).called(populationSize);
    });
  });

  group('reproduce', () {
    test('returns a newly created population', () async {
      const smallPopulationSize = 3;
      final List<Entity> entities = [];
      for (int i = 0; i < smallPopulationSize; i++) {
        entities.add(mockEntity);
      }
      final population = Population(entities: entities);

      final newChild = MockEntity();

      final parents = [
        entities[0],
        entities[1],
      ];

      when(() => mockEntityService.crossOver(
            parents: parents,
            wave: wave,
          )).thenAnswer((_) async => newChild);

      when(() => mockSelectionService.selectParents(
            population: population,
          )).thenAnswer((invocation) => parents);

      final expected = Population(entities: [
        newChild,
        newChild,
        newChild,
      ]);

      final actual = await testObject.reproduce(
        population: population,
        wave: wave,
      );

      expect(actual, expected);

      verify(
        () => mockSelectionService.selectParents(
          population: population,
        ),
      );

      verify(() => mockEntityService.crossOver(
            parents: parents,
            wave: wave,
          ));
    });
  });
}
