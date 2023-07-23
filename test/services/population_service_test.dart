import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/population.dart';
import 'package:evolutionary_algorithm/services/entity_service.dart';
import 'package:evolutionary_algorithm/services/population_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const populationSize = 100;
  final Entity mockEntity = MockEntity();

  late EntityService mockEntityService;
  late PopulationService testObject;

  setUp(() async {
    mockEntityService = MockEntityService();

    testObject = PopulationService(entityService: mockEntityService);
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
}
