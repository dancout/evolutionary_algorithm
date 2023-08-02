import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  final DNA mockDNA = MockDNA();
  const fitnessScore = 100.0;
  const crossoverFitnessScore = 200.0;
  const trackParents = false;
  const wave = 1;

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

  late DNAService mockDnaService;
  late FitnessService mockFitnessService;
  late GeneService mockGeneService;
  late GeneMutationService mockGeneMutationService;
  late Random mockRandom;

  late EntityService testObject;

  setUp(() async {
    mockDnaService = MockDNAService();
    mockFitnessService = MockFitnessService();
    mockGeneService = MockGeneService();
    mockGeneMutationService = MockGeneMutationService();
    mockRandom = MockRandom();
    testObject = EntityService(
      trackParents: trackParents,
      dnaService: mockDnaService,
      fitnessService: mockFitnessService,
      geneMutationService: mockGeneMutationService,
      random: mockRandom,
    );

    when(() => mockGeneMutationService.geneService).thenReturn(mockGeneService);
  });

  group('randomEntity', () {
    test(
        'calls proper services to create a random DNA object and score its fitness',
        () async {
      when(() => mockDnaService.randomDNA()).thenReturn(mockDNA);
      when(() => mockFitnessService.calculateScore(dna: mockDNA))
          .thenAnswer((_) async => fitnessScore);
      final expected = Entity(dna: mockDNA, fitnessScore: fitnessScore);
      final actual = await testObject.randomEntity();

      expect(actual, expected);

      verify(() => mockDnaService.randomDNA());
      verify(() => mockFitnessService.calculateScore(dna: mockDNA));
    });
  });

  group('crossOver', () {
    test(
        'will create an Entity with randomly crossed over genes from the parents'
        'without tracking parents when trackParents is false', () async {
      when(() => mockDnaService.numGenes).thenReturn(numGenes);

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

      final List<int Function(Invocation)> removableParentIndices =
          List.generate(
        parentIndices.length,
        (index) => (_) => parentIndices[index],
      );

      when(() => mockDnaService.numGenes).thenReturn(numGenes);

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

      for (var crossoverGene in crossoverGenes) {
        when(() => mockGeneMutationService.mutateGene(
              gene: crossoverGene,
              wave: wave,
            )).thenReturn(crossoverGene);
      }

      final crossoverDna = DNA(genes: crossoverGenes);
      when(() => mockFitnessService.calculateScore(dna: crossoverDna))
          .thenAnswer((_) async => crossoverFitnessScore);

      final expected = Entity(
        dna: crossoverDna,
        fitnessScore: crossoverFitnessScore,
        parents: null,
      );

      final actual = await testObject.crossOver(
        parents: parents,
        wave: wave,
      );
      expect(actual, expected);

      for (var crossoverGene in crossoverGenes) {
        verify(() => mockGeneMutationService.mutateGene(
              gene: crossoverGene,
              wave: wave,
            ));
      }
      verify(() => mockFitnessService.calculateScore(dna: crossoverDna));
      verify(() => mockDnaService.numGenes);
    });

    test(
        'will create an Entity with randomly crossed over genes from the parents'
        'while tracking parents when trackParents is true', () async {
      when(() => mockDnaService.numGenes).thenReturn(numGenes);

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

      final List<int Function(Invocation)> removableParentIndices =
          List.generate(
        parentIndices.length,
        (index) => (_) => parentIndices[index],
      );

      when(() => mockDnaService.numGenes).thenReturn(numGenes);

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

      for (var crossoverGene in crossoverGenes) {
        when(() => mockGeneMutationService.mutateGene(
              gene: crossoverGene,
              wave: wave,
            )).thenReturn(crossoverGene);
      }

      final crossoverDna = DNA(genes: crossoverGenes);
      when(() => mockFitnessService.calculateScore(dna: crossoverDna))
          .thenAnswer((_) async => crossoverFitnessScore);

      final expected = Entity(
        dna: crossoverDna,
        fitnessScore: crossoverFitnessScore,
        parents: parents,
      );

      testObject = EntityService(
        trackParents: true,
        dnaService: mockDnaService,
        fitnessService: mockFitnessService,
        geneMutationService: mockGeneMutationService,
        random: mockRandom,
      );

      final actual = await testObject.crossOver(
        parents: parents,
        wave: wave,
      );
      expect(actual, expected);

      for (var crossoverGene in crossoverGenes) {
        verify(() => mockGeneMutationService.mutateGene(
              gene: crossoverGene,
              wave: wave,
            ));
      }
      verify(() => mockFitnessService.calculateScore(dna: crossoverDna));
      verify(() => mockDnaService.numGenes);
    });
  });
}
