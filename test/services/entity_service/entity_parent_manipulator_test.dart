import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';

void main() {
  const greatGrandParentsGenEntity = Entity(
    dna: DNA(genes: []),
    fitnessScore: 1.0,
    parents: [],
  );
  const grandParentsGenEntity = Entity(
    dna: DNA(genes: []),
    fitnessScore: 2.0,
    parents: [greatGrandParentsGenEntity, greatGrandParentsGenEntity],
  );

  const parentsGenEntity = Entity(
    dna: DNA(genes: []),
    fitnessScore: 3.0,
    parents: [
      grandParentsGenEntity,
      grandParentsGenEntity,
    ],
  );

  const kidsGenEntity = Entity(
    dna: DNA(genes: []),
    fitnessScore: 4.0,
    parents: [
      parentsGenEntity,
      parentsGenEntity,
    ],
  );

  group('updateParents', () {
    test('returns null when trackParents is false', () async {
      final actual =
          const EntityParentManinpulator(trackParents: false).updateParents(
        parents: [grandParentsGenEntity, grandParentsGenEntity],
        currentGeneration: 1,
      );

      expect(actual, isNull);
    });

    test('returns null when trackParents is true and parents are null',
        () async {
      final actual =
          const EntityParentManinpulator(trackParents: true).updateParents(
        parents: null,
        currentGeneration: 1,
      );

      expect(actual, isNull);
    });

    test('returns null when trackParents is true and parents are empty',
        () async {
      final actual =
          const EntityParentManinpulator(trackParents: false).updateParents(
        parents: [],
        currentGeneration: 1,
      );

      expect(actual, isNull);
    });

    test('returns null when trackParents is true and generationsToTrack is 0',
        () async {
      final actual = const EntityParentManinpulator(
        trackParents: true,
        generationsToTrack: 0,
      ).updateParents(
        parents: [grandParentsGenEntity, grandParentsGenEntity],
        currentGeneration: 1,
      );

      expect(actual, isNull);
    });

    test(
        'returns up to kids generation parents when trackParents is true and generationsToTrack is 1',
        () async {
      final actual = const EntityParentManinpulator(
        trackParents: true,
        generationsToTrack: 1,
      ).updateParents(
        parents: [kidsGenEntity, kidsGenEntity],
        currentGeneration: 1,
      );

      final kidsGenEntityWithoutParents = kidsGenEntity.copyWith(
        parents: [],
      );

      expect(
        actual,
        [
          kidsGenEntityWithoutParents,
          kidsGenEntityWithoutParents,
        ],
      );
    });

    test(
        'returns up to parents generation parents when trackParents is true and generationsToTrack is 2',
        () async {
      final actual = const EntityParentManinpulator(
        trackParents: true,
        generationsToTrack: 2,
      ).updateParents(
        parents: [kidsGenEntity, kidsGenEntity],
        currentGeneration: 1,
      );

      final parentsGenEntityWithoutParents = parentsGenEntity.copyWith(
        parents: [],
      );

      final updatedKidsGenEntity = kidsGenEntity.copyWith(
        parents: [
          parentsGenEntityWithoutParents,
          parentsGenEntityWithoutParents,
        ],
      );

      expect(
        actual,
        [
          updatedKidsGenEntity,
          updatedKidsGenEntity,
        ],
      );
    });

    test(
        'returns up to grandparents generation parents when trackParents is true and generationsToTrack is 3',
        () async {
      final actual = const EntityParentManinpulator(
        trackParents: true,
        generationsToTrack: 3,
      ).updateParents(
        parents: [kidsGenEntity, kidsGenEntity],
        currentGeneration: 1,
      );

      final grandparentsGenEntityWithoutParents =
          grandParentsGenEntity.copyWith(
        parents: [],
      );

      final updatedParentsGenEntity = parentsGenEntity.copyWith(
        parents: [
          grandparentsGenEntityWithoutParents,
          grandparentsGenEntityWithoutParents,
        ],
      );

      final updatedKidsGenEntity = kidsGenEntity.copyWith(
        parents: [
          updatedParentsGenEntity,
          updatedParentsGenEntity,
        ],
      );

      expect(
        actual,
        [
          updatedKidsGenEntity,
          updatedKidsGenEntity,
        ],
      );
    });

    test(
        'returns all generations of parents when trackParents is true and generationsToTrack is null',
        () async {
      final actual = const EntityParentManinpulator(
        trackParents: true,
        generationsToTrack: null,
      ).updateParents(
        parents: [kidsGenEntity, kidsGenEntity],
        currentGeneration: 1,
      );

      expect(
        actual,
        [
          kidsGenEntity,
          kidsGenEntity,
        ],
      );
    });
  });
}
