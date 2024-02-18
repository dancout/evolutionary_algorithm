library genetic_evolution;

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package:genetic_evolution/models/dna.dart';
part 'package:genetic_evolution/models/entity.dart';
part 'package:genetic_evolution/models/gene.dart';
part 'package:genetic_evolution/models/generation.dart';
part 'package:genetic_evolution/models/genetic_evolution_config.dart';
part 'package:genetic_evolution/models/population.dart';
part 'package:genetic_evolution/services/crossover_service.dart';
part 'package:genetic_evolution/services/dna_service.dart';
part 'package:genetic_evolution/services/entity_service/entity_parent_manipulator.dart';
part 'package:genetic_evolution/services/entity_service/entity_service.dart';
part 'package:genetic_evolution/services/fitness_service.dart';
part 'package:genetic_evolution/services/gene_mutation_service.dart';
part 'package:genetic_evolution/services/gene_service.dart';
part 'package:genetic_evolution/services/population_service.dart';
part 'package:genetic_evolution/services/selection_service.dart';

/// Used for generating populations that evolve over time through genetic
/// breeding and mutation.
class GeneticEvolution<T> {
  GeneticEvolution({
    required this.geneticEvolutionConfig,
    required this.fitnessService,
    required this.geneService,
    JsonConverter? jsonConverter,
    @visibleForTesting PopulationService<T>? populationService,
    @visibleForTesting EntityService<T>? entityService,
    @visibleForTesting EntityParentManinpulator<T>? entityParentManinpulator,
  }) {
    final geneMutationService = GeneMutationService(
      trackMutatedWaves: geneticEvolutionConfig.trackMutatedWaves,
      mutationRate: geneticEvolutionConfig.mutationRate,
      geneService: geneService,
      random: geneticEvolutionConfig.random,
    );

    final dnaService = DNAService<T>(
      numGenes: geneticEvolutionConfig.numGenes,
      geneMutationService: geneMutationService,
    );

    this._entityService = entityService ??
        EntityService<T>(
          dnaService: dnaService,
          fitnessService: fitnessService,
          geneMutationService: geneMutationService,
          random: geneticEvolutionConfig.random,
          entityParentManinpulator: entityParentManinpulator ??
              EntityParentManinpulator(
                trackParents: geneticEvolutionConfig.trackParents,
                generationsToTrack: geneticEvolutionConfig.generationsToTrack,
              ),
        );

    final selectionService = SelectionService<T>(
      canReproduceWithSelf: geneticEvolutionConfig.canReproduceWithSelf,
      numParents: geneticEvolutionConfig.numParents,
      random: geneticEvolutionConfig.random,
    );

    this.populationService = populationService ??
        PopulationService<T>(
          entityService: _entityService,
          selectionService: selectionService,
        );

    if (jsonConverter != null) {
      GeneticEvolution.jsonConverter = jsonConverter;
    }
  }

  /// The config object used to store setup parameters for the Genetic Evolution
  /// algorithm.
  final GeneticEvolutionConfig geneticEvolutionConfig;

  /// The service used to generate new populations for each generation
  @visibleForTesting
  late final PopulationService<T> populationService;

  /// The EntityService used to populate the entities of this Population.
  late final EntityService<T> _entityService;

  /// Represents the service used to calculate an entity's fitness core.
  final FitnessService<T> fitnessService;

  /// The GeneService used to intialize new Genes.
  final GeneService<T> geneService;

  // Represents the current generation.
  Generation<T>? _generation;

  /// Used to convert objects of Type <T> to and from Json.
  static JsonConverter? jsonConverter;

  /// The error to throw during an attempt to use a null [JsonConverter].
  static Error jsonConverterUnimplementedError = UnimplementedError(
    'JsonConverter is undefined on GeneticEvolution.',
  );
  Future<Generation<T>> nextGeneration() async {
    late Population<T> population;

    final generation = this._generation;
    final wave = (generation?.wave ?? -1) + 1;
    if (generation == null) {
      // Initialize
      population = await populationService.randomPopulation(
        populationSize: geneticEvolutionConfig.populationSize,
      );
    } else {
      population = await populationService.reproduce(
        population: generation.population,
        wave: wave,
      );
    }

    return this._generation = Generation<T>(
      // Default to -1 so that we are actually 0 indexed
      wave: wave,
      population: population,
    );
  }
}
