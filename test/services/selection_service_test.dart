import 'dart:math';

import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/population.dart';
import 'package:evolutionary_algorithm/services/selection_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late Random mockRandom;

  late SelectionService testObject;

  setUp(() async {
    mockRandom = MockRandom();
    testObject = SelectionService(
      random: mockRandom,
      numParents: 2,
    );
  });

  group('normalizedFitnessScore', () {
    test('returns the total sum of fitness scores among entities', () async {
      final List<Entity> entities = List.generate(
        10,
        (index) => Entity(dna: MockDNA(), fitnessScore: index.toDouble()),
      );

      const expected = 45.0;

      final actual = testObject.totalEntitiesFitnessScore(entities: entities);

      expect(actual, expected);
    });
  });

  group('selectParentFromPool', () {
    test('randomly selects a parent based on its probability', () async {
      // The entity fitness scores and associated selection probabilities are as
      // follows:

      // 101.0 - 0.18035714285714285
      // 91.0 - 0.1625
      // 81.0 - 0.14464285714285716
      // 71.0 - 0.12678571428571428
      // 61.0 - 0.10892857142857143
      // 51.0 - 0.09107142857142857
      // 41.0 - 0.07321428571428572
      // 31.0 - 0.055357142857142855
      // 21.0 - 0.0375
      // 11.0 - 0.019642857142857142

      final List<Entity> entities = List.generate(
        10,
        (index) => Entity(
            dna: MockDNA(), fitnessScore: (1 + 10 * (10 - index)).toDouble()),
      );

      // Used so that we are selecting a random value not at an edge case every
      // time.
      const offset = 0.01;

      final List<double> probabilities = [
        0.18035714285714285,
        0.1625,
        0.14464285714285716,
        0.12678571428571428,
        0.10892857142857143,
        0.09107142857142857,
        0.07321428571428572,
        0.055357142857142855,
        0.0375,
        0.019642857142857142,
      ];

      double randNumber = 0;

      for (int i = 0; i < entities.length; i++) {
        randNumber += probabilities[i];
        when(() => mockRandom.nextDouble())
            .thenAnswer((invocation) => randNumber - offset);

        final actual = testObject.selectParentFromPool(entities: entities);
        final expected = entities[i];
        expect(actual, expected);
      }
    });

    test(
        'throws exception when there are not enough positive fitnessScores within the pool',
        () async {
      final List<Entity> entities =
          List.generate(10, (index) => Entity(dna: MockDNA(), fitnessScore: 0));
      when(() => mockRandom.nextDouble()).thenAnswer((invocation) => 0.1);

      expect(
        () => testObject.selectParentFromPool(entities: entities),
        throwsException,
      );
    });
  });

  group('selectParents', () {
    test('selects correct number of Parents from population', () async {
      final List<Entity> entities = List.generate(
        10,
        (index) => Entity(
            dna: MockDNA(), fitnessScore: (1 + 10 * (10 - index)).toDouble()),
      );

      for (int i = 0; i < 5; i++) {
        testObject = SelectionService(
          numParents: i,
        );
        final population = Population(entities: entities);
        final actual = testObject.selectParents(
          population: population,
        );

        expect(actual.length, i);
      }
    });

    test('will not duplicate parents when canReproduceWithSelf is false',
        () async {
      final List<Entity> entities = List.generate(
        10,
        (index) => Entity(
            dna: MockDNA(), fitnessScore: (1 + 10 * (10 - index)).toDouble()),
      );

      // Because we are returning the same randNumber every time, we should
      // always grab the first parent in the list of sorted entities
      when(() => mockRandom.nextDouble()).thenAnswer((invocation) => 0.1);

      final expected = [
        entities[0],
        entities[1],
        entities[2],
      ];

      testObject = SelectionService(
        numParents: expected.length,
        canReproduceWithSelf: false,
        random: mockRandom,
      );

      final population = Population(entities: entities);
      final actual = testObject.selectParents(
        population: population,
      );

      expect(actual, expected);
    });

    test('will duplicate parents when canReproduceWithSelf is true', () async {
      final List<Entity> entities = List.generate(
        10,
        (index) => Entity(
            dna: MockDNA(), fitnessScore: (1 + 10 * (10 - index)).toDouble()),
      );

      // Because we are returning the same randNumber every time, we should
      // always grab the first parent in the list of sorted entities
      when(() => mockRandom.nextDouble()).thenAnswer((invocation) => 0.1);

      final expected = [
        entities[0],
        entities[0],
        entities[0],
      ];

      testObject = SelectionService(
        numParents: expected.length,
        canReproduceWithSelf: true,
        random: mockRandom,
      );

      final population = Population(entities: entities);
      final actual = testObject.selectParents(
        population: population,
      );

      expect(actual, expected);
    });
  });
}
