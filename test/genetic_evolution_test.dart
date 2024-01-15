import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  const numGenes = 10;
  const numParents = 4;
  const populationSize = 50;
  const trackParents = true;
  const canReproduceWithSelf = true;
  const mutationRate = 0.4;
  const trackMutatedWaves = true;
  late FitnessService mockFitnessService;
  late GeneService mockGeneService;
  late Random mockRandom;
  late PopulationService mockPopulationService;
  late EntityService mockEntityService;
  late GeneticEvolutionConfig geneticEvolutionConfig;

  setUp(() async {
    mockFitnessService = MockFitnessService();
    mockGeneService = MockGeneService();
    mockEntityService = MockEntityService();
    mockRandom = MockRandom();
    mockPopulationService = MockPopulationService();

    geneticEvolutionConfig = GeneticEvolutionConfig(
      numGenes: numGenes,
      trackParents: trackParents,
      canReproduceWithSelf: canReproduceWithSelf,
      numParents: numParents,
      populationSize: populationSize,
      mutationRate: mutationRate,
      random: mockRandom,
      trackMutatedWaves: trackMutatedWaves,
    );
  });

  group('GeneticEvolution', () {
    test('Initializes based on values passed in', () {
      final testObject = GeneticEvolution(
        geneticEvolutionConfig: geneticEvolutionConfig,
        fitnessService: mockFitnessService,
        geneService: mockGeneService,
        entityService: mockEntityService,
        populationService: mockPopulationService,
      );

      expect(testObject.populationService, mockPopulationService);
      expect(testObject.fitnessService, mockFitnessService);
      expect(testObject.geneService, mockGeneService);
    });

    test('Initializes when parameters are not all passed in', () {
      final testObject = GeneticEvolution(
        geneticEvolutionConfig: geneticEvolutionConfig,
        fitnessService: mockFitnessService,
        geneService: mockGeneService,
      );

      final geneMutationService = GeneMutationService(
        trackMutatedWaves: geneticEvolutionConfig.trackMutatedWaves,
        mutationRate: geneticEvolutionConfig.mutationRate,
        geneService: mockGeneService,
        random: geneticEvolutionConfig.random,
      );
      expect(
        testObject.populationService,
        PopulationService(
          entityService: EntityService(
            entityParentManinpulator: EntityParentManinpulator(
              trackParents: geneticEvolutionConfig.trackParents,
            ),
            dnaService: DNAService(
              numGenes: numGenes,
              geneMutationService: geneMutationService,
            ),
            fitnessService: mockFitnessService,
            geneMutationService: geneMutationService,
            random: geneticEvolutionConfig.random,
          ),
          selectionService: SelectionService(
            canReproduceWithSelf: geneticEvolutionConfig.canReproduceWithSelf,
            numParents: geneticEvolutionConfig.numParents,
            random: geneticEvolutionConfig.random,
          ),
        ),
      );
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
          )).thenAnswer((_) async => firstPopulation);

      when(() => mockPopulationService.reproduce(
            population: firstPopulation,
            wave: 1,
          )).thenAnswer((_) async => secondPopulation);

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
      final actualFirstGeneration = await testObject.nextGeneration();

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
      final actualSecondGeneration = await testObject.nextGeneration();

      expect(actualSecondGeneration, expectedSecondGeneration);
      verify(() => mockPopulationService.reproduce(
          population: firstPopulation, wave: 1));
      verifyNever(() => mockPopulationService.randomPopulation(
          populationSize: populationSize));
    });
  });
}
