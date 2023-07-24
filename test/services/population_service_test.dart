import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/population.dart';
import 'package:evolutionary_algorithm/services/entity_service.dart';
import 'package:evolutionary_algorithm/services/population_service.dart';
import 'package:evolutionary_algorithm/services/selection_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const populationSize = 100;
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
      when(() => mockEntityService.randomEntity()).thenReturn(mockEntity);

      final List<Entity> entities = [];
      for (int i = 0; i < populationSize; i++) {
        entities.add(mockEntity);
      }
      final expected = Population(entities: entities);

      final actual =
          testObject.randomPopulation(populationSize: populationSize);

      expect(actual, expected);

      verify(() => mockEntityService.randomEntity()).called(populationSize);
    });
  });

  group('reproduce', () {
    test('returns a newly created population', () async {
      const numParents = 2;
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

      when(() => mockEntityService.crossOver(parents: parents))
          .thenReturn(newChild);

      when(() => mockSelectionService.selectParents(
          population: population,
          numParents: numParents)).thenAnswer((invocation) => parents);

      final expected = Population(entities: [
        newChild,
        newChild,
        newChild,
      ]);

      final actual = testObject.reproduce(
        population: population,
        numParents: numParents,
      );

      expect(actual, expected);

      verify(
        () => mockSelectionService.selectParents(
          population: population,
          numParents: numParents,
        ),
      );

      verify(() => mockEntityService.crossOver(parents: parents));
    });
  });
}
