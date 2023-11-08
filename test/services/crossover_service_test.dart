import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  // A list meant to represent a random selection of the index corresponding to
  // 1 of 4 parents.
  const List<int> parentIndices = [
    1,
    3,
    0,
    2,
    1,
    3,
    1,
    0,
    2,
    3,
  ];
  final numGenes = parentIndices.length;
  const fitnessScore = 100.0;

  final parent0 = Entity(
    dna: DNA(
        genes: List.generate(
      numGenes,
      (index) => Gene(value: index),
    )),
    fitnessScore: fitnessScore,
  );

  final parent1 = Entity(
    dna: DNA(
        genes: List.generate(
      numGenes,
      (index) => Gene(value: 10 + index),
    )),
    fitnessScore: fitnessScore,
  );

  final parent2 = Entity(
    dna: DNA(
        genes: List.generate(
      numGenes,
      (index) => Gene(value: 20 + index),
    )),
    fitnessScore: fitnessScore,
  );

  final parent3 = Entity(
    dna: DNA(
        genes: List.generate(
      numGenes,
      (index) => Gene(value: 30 + index),
    )),
    fitnessScore: fitnessScore,
  );
  final List<Entity> parents = [
    parent0,
    parent1,
    parent2,
    parent3,
  ];

  const wave = 0;

  late GeneMutationService mockGeneMutationService;
  late Random mockRandom;

  late CrossoverService testObject;

  setUp(() async {
    mockGeneMutationService = MockGeneMutationService();
    mockRandom = MockRandom();
    testObject = CrossoverService(
      geneMutationService: mockGeneMutationService,
      random: mockRandom,
    );
  });

  group('crossover', () {
    test('crosses over from parents properly', () async {
      final List<int Function(Invocation)> removableParentIndices =
          List.generate(
        parentIndices.length,
        (index) => (_) => parentIndices[index],
      );

      // This is done so that we can return a different value each time .nextInt
      // is called.
      when(() => mockRandom.nextInt(parents.length))
          .thenAnswer((_) => removableParentIndices.removeAt(0)(_));

      // Generate the list of genes based on the index of the parent
      final List<Gene> crossoverGenes = List.generate(
        numGenes,
        (index) {
          final parentIndex = parentIndices[index];
          return parents[parentIndex].dna.genes[index];
        },
      );

      // Each gene will potentially be mutated
      for (var crossoverGene in crossoverGenes) {
        when(() => mockGeneMutationService.mutateGene(
              gene: crossoverGene,
              wave: wave,
            )).thenReturn(crossoverGene);
      }

      final actual = await testObject.crossover(parents: parents, wave: wave);
      expect(actual, crossoverGenes);

      for (var crossoverGene in crossoverGenes) {
        verify(
          () => mockGeneMutationService.mutateGene(
            gene: crossoverGene,
            wave: wave,
          ),
        );
      }
    });
  });
}
