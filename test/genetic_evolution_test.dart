import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/genetic_evolution_config.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:genetic_evolution/services/gene_service.dart';
import 'package:genetic_evolution/services/population_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  const numGenes = 10;
  const numParents = 4;
  const populationSize = 50;
  const trackParents = true;
  const canReproduceWithSelf = true;
  late FitnessService mockFitnessService;
  late GeneService mockGeneService;
  late Random mockRandom;
  late PopulationService mockPopulationService;
  late GeneticEvolutionConfig geneticEvolutionConfig;

  setUp(() async {
    mockFitnessService = MockFitnessService();
    mockGeneService = MockGeneService();
    mockRandom = MockRandom();
    mockPopulationService = MockPopulationService();

    geneticEvolutionConfig = GeneticEvolutionConfig(
      numGenes: numGenes,
      trackParents: trackParents,
      canReproduceWithSelf: canReproduceWithSelf,
      numParents: numParents,
      populationSize: populationSize,
      random: mockRandom,
    );
  });

  group('GeneticEvolution', () {
    test('Initializes services properly', () {
      final testObject = GeneticEvolution(
        geneticEvolutionConfig: geneticEvolutionConfig,
        fitnessService: mockFitnessService,
        geneService: mockGeneService,
      );
      final expected = PopulationService(
        entityService: EntityService(
          dnaService: DNAService(
            numGenes: geneticEvolutionConfig.numGenes,
            geneService: mockGeneService,
          ),
          random: mockRandom,
          fitnessService: mockFitnessService,
          geneService: mockGeneService,
          trackParents: geneticEvolutionConfig.trackParents,
        ),
        selectionService: SelectionService(
          numParents: geneticEvolutionConfig.numParents,
          canReproduceWithSelf: geneticEvolutionConfig.canReproduceWithSelf,
          random: mockRandom,
        ),
      );

      expect(testObject.populationService, expected);
    });
  });

  group('nextGeneration', () {
    test('generates next generation properly', () async {
      final mockFirstEntity = MockEntity();
      final mockSecondEntity = MockEntity();
      final firstEntities =
          List.generate(populationSize, (index) => mockFirstEntity);
      final secondEntities =
          List.generate(populationSize, (index) => mockSecondEntity);

      final firstPopulation = Population(entities: firstEntities);
      final secondPopulation = Population(entities: secondEntities);

      when(() => mockPopulationService.randomPopulation(
            populationSize: populationSize,
          )).thenReturn(firstPopulation);

      when(() => mockPopulationService.reproduce(
            population: firstPopulation,
            wave: 1,
          )).thenReturn(secondPopulation);

      final testObject = GeneticEvolution(
        geneticEvolutionConfig: geneticEvolutionConfig,
        fitnessService: mockFitnessService,
        geneService: mockGeneService,
        populationService: mockPopulationService,
      );

      // First Wave
      final expectedFirstGeneration = Generation(
        wave: 0,
        population: firstPopulation,
      );
      final actualFirstGeneration = testObject.nextGeneration();

      expect(actualFirstGeneration, expectedFirstGeneration);
      verify(() => mockPopulationService.randomPopulation(
          populationSize: populationSize));
      verifyNever(() => mockPopulationService.reproduce(
          population: firstPopulation, wave: 0));

      // Second Wave
      final expectedSecondGeneration = Generation(
        wave: 1,
        population: secondPopulation,
      );
      final actualSecondGeneration = testObject.nextGeneration();

      expect(actualSecondGeneration, expectedSecondGeneration);
      verify(() => mockPopulationService.reproduce(
          population: firstPopulation, wave: 1));
      verifyNever(() => mockPopulationService.randomPopulation(
          populationSize: populationSize));
    });
  });
}
