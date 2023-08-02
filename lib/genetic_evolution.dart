library genetic_evolution;

import 'package:flutter/foundation.dart';
import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/genetic_evolution_config.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:genetic_evolution/services/gene_service.dart';
import 'package:genetic_evolution/services/population_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';

/// Used for generating populations that evolve over time through genetic
/// breeding and mutation.
class GeneticEvolution<T> {
  GeneticEvolution({
    required this.geneticEvolutionConfig,
    required this.fitnessService,
    required this.geneService,
    @visibleForTesting PopulationService<T>? populationService,
  }) {
    final dnaService = DNAService<T>(
      numGenes: geneticEvolutionConfig.numGenes,
      geneService: geneService,
    );

    final entityService = EntityService<T>(
      dnaService: dnaService,
      fitnessService: fitnessService,
      geneService: geneService,
      trackParents: geneticEvolutionConfig.trackParents,
      random: geneticEvolutionConfig.random,
    );

    final selectionService = SelectionService<T>(
      canReproduceWithSelf: geneticEvolutionConfig.canReproduceWithSelf,
      numParents: geneticEvolutionConfig.numParents,
      random: geneticEvolutionConfig.random,
    );

    this.populationService = populationService ??
        PopulationService<T>(
          entityService: entityService,
          selectionService: selectionService,
        );
  }

  /// The config object used to store setup parameters for the Genetic Evolution
  /// algorithm.
  final GeneticEvolutionConfig geneticEvolutionConfig;

  /// The service used to generate new populations for each generation
  @visibleForTesting
  late final PopulationService<T> populationService;

  /// Represents the service used to calculate an entity's fitness core.
  final FitnessService fitnessService;

  /// The GeneService used to intialize new Genes.
  final GeneService<T> geneService;

  Generation<T>? generation;

  Generation<T> nextGeneration() {
    late Population<T> population;

    final generation = this.generation;
    final wave = (generation?.wave ?? -1) + 1;
    if (generation == null) {
      // Initialize
      population = populationService.randomPopulation(
        populationSize: geneticEvolutionConfig.populationSize,
      );
    } else {
      population = populationService.reproduce(
        population: generation.population,
        wave: wave,
      );
    }

    return this.generation = Generation<T>(
      // Default to -1 so that we are actually 0 indexed
      wave: wave,
      population: population,
    );
  }
}
