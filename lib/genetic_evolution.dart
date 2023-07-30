library genetic_evolution;

import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/genetic_evolution_config.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:genetic_evolution/services/gene_service.dart';
import 'package:genetic_evolution/services/population_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';

class GeneticEvolution<T> {
  GeneticEvolution({
    required this.geneticEolutionConfig,
    required this.fitnessService,
    required this.geneService,
  }) {
    final dnaService = DNAService<T>(
      numGenes: geneticEolutionConfig.numGenes,
      geneService: geneService,
    );

    final entityService = EntityService<T>(
      dnaService: dnaService,
      fitnessService: fitnessService,
      geneService: geneService,
      trackParents: geneticEolutionConfig.trackParents,
    );

    final selectionService = SelectionService<T>(
      canReproduceWithSelf: geneticEolutionConfig.canReproduceWithSelf,
      numParents: geneticEolutionConfig.numParents,
    );

    populationService = PopulationService<T>(
      entityService: entityService,
      selectionService: selectionService,
    );
  }

  /// The config object used to store setup parameters for the Genetic Evolution
  /// algorithm.
  final GeneticEvolutionConfig geneticEolutionConfig;

  /// The service used to generate new populations for each generation
  late final PopulationService<T> populationService;

  /// Represents the service used to calculate an entity's fitness core.
  final FitnessService fitnessService;

  /// The GeneService used to intialize new Genes.
  final GeneService<T> geneService;

  Generation<T>? generation;

  Generation<T> nextGeneration() {
    late Population<T> population;

    final generation = this.generation;
    if (generation == null) {
      // Initialize
      population = populationService.randomPopulation(
        populationSize: geneticEolutionConfig.populationSize,
      );
    } else {
      population = populationService.reproduce(
        population: generation.population,
      );
    }

    return this.generation = Generation<T>(
      // Default to -1 so that we are actually 0 indexed
      wave: (generation?.wave ?? -1) + 1,
      population: population,
    );
  }
}
