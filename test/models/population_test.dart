import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';

import '../mocks.dart';

void main() {
  const lowScore = 1.0;
  const mediumScore = 5.0;
  const highScore = 10.0;
  final lowScoreEntity = Entity(dna: MockDNA(), fitnessScore: lowScore);
  final mediumScoreEntity = Entity(dna: MockDNA(), fitnessScore: mediumScore);
  final highScoreEntity = Entity(dna: MockDNA(), fitnessScore: highScore);
  final entities = [
    mediumScoreEntity,
    highScoreEntity,
    lowScoreEntity,
  ];

  late Population testObject;

  setUp(() async {
    testObject = Population(entities: entities);
  });

  group('sortedEntities', () {
    test('should return entities in sorted order based on fitnessScore',
        () async {
      final expected = [highScoreEntity, mediumScoreEntity, lowScoreEntity];

      final actual = testObject.sortedEntities;

      expect(actual, expected);
    });
  });

  group('topScoringEntity', () {
    test('should return the entity with the highest fitness score', () async {
      final expected = highScoreEntity;

      final actual = testObject.topScoringEntity;

      expect(actual, expected);
    });
  });
}
