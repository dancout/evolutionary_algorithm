import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/population.dart';

import '../mocks.dart';

void main() {
  group('sortedEntities', () {
    test('should return entities in sorted order based on fitnessScore',
        () async {
      const lowScore = 1.0;
      const mediumScore = 5.0;
      const highScore = 10.0;

      final lowScoreEntity = Entity(dna: MockDNA(), fitnessScore: lowScore);
      final mediumScoreEntity =
          Entity(dna: MockDNA(), fitnessScore: mediumScore);
      final highScoreEntity = Entity(dna: MockDNA(), fitnessScore: highScore);

      final expected = [lowScoreEntity, mediumScoreEntity, highScoreEntity];

      final actual = Population(
        entities: [
          mediumScoreEntity,
          highScoreEntity,
          lowScoreEntity,
        ],
      ).sortedEntities;

      expect(actual, expected);
    });
  });
}
