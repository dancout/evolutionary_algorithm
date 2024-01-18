import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';

void main() {
  const numGenes = 5;
  const fitnessScore = 1.0;
  const updatedFitnessScore = 2.0;

  final entity = Entity(
    dna: DNA(
      genes: List.generate(
        numGenes,
        (index) => Gene(value: index),
      ),
    ),
    fitnessScore: fitnessScore,
  );

  group('copyWith', () {
    test('updates dna', () async {
      final actual = entity.copyWith(
        dna: const DNA(
          genes: [],
        ),
      );

      const expected = Entity<int>(
        dna: DNA(
          genes: [],
        ),
        fitnessScore: fitnessScore,
      );

      expect(actual, expected);
    });

    test('updates fitnessScore', () async {
      final actual = entity.copyWith(
        fitnessScore: updatedFitnessScore,
      );

      final expected = Entity(
        dna: DNA(
          genes: List.generate(
            numGenes,
            (index) => Gene(value: index),
          ),
        ),
        fitnessScore: updatedFitnessScore,
      );

      expect(actual, expected);
    });

    test('updates parents', () async {
      final actual = entity.copyWith(
        parents: [entity],
      );

      final expected = Entity(
        dna: DNA(
          genes: List.generate(
            numGenes,
            (index) => Gene(value: index),
          ),
        ),
        fitnessScore: fitnessScore,
        parents: [entity],
      );

      expect(actual, expected);
    });
  });
}
