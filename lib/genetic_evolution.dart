library genetic_evolution;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

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
part 'package:genetic_evolution/utils/file_parser.dart';

/// Used for generating populations that evolve over time through genetic
/// breeding and mutation.
class GeneticEvolution<T> {
  GeneticEvolution({
    required this.geneticEvolutionConfig,
    required this.fitnessService,
    required this.geneService,
    JsonConverter? geneJsonConverter,
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

    if (geneJsonConverter != null) {
      GeneticEvolution.geneJsonConverter = geneJsonConverter;
    }
  }

  /// Writes the current [Generation] to a file.
  Future<void> writeGenerationToFile({
    // TODO: Should this fileparser exist on the GeneticEvolution object itself?
    FileParser<Generation<T>>? fileParser,
    JsonConverter? geneJsonConverter,
    required JsonConverter generationJsonConverter,
  }) async {
    final generation = _generation;
    if (generation == null) {
      throw Exception('Tried to write a null generation to file.');
    }

    // Ensure that a FileParser is set so that we can properly load in a File.
    fileParser = _getFileParser(
      fileParser,
      geneJsonConverter,
      generationJsonConverter,
    );

    fileParser.writeGenerationToFile(generation: generation);
  }

  /// Loads in a [Generation] from a file corresponding to the input [wave] and
  /// sets it internally on this [GeneticEvolution] object.
  ///
  /// This newly loaded in Generation will be visible on the following
  /// [GeneticEvolution.nextGeneration] call.
  Future<void> loadGenerationFromFile({
    required int wave,
    // TODO: Should this be required?
    JsonConverter? geneJsonConverter,
    required JsonConverter generationJsonConverter,
    FileParser<Generation<T>>? fileParser,
  }) async {
    // Ensure that a FileParser is set so that we can properly load in a File.
    fileParser = _getFileParser(
      fileParser,
      geneJsonConverter,
      generationJsonConverter,
    );

    // Load the Generation from file.
    _generation = await fileParser.readGenerationFromFile(
      wave: wave,
    );
    // Set _fromLoad so that we know to return the generation from file on the
    // next retrieval call.
    _fromLoad = true;
  }

  /// Returns a valid [FileParser] object based on the input [fileParser] and
  /// [geneJsonConverter].
  // TODO: Should probably move this to a FileParserHelper class or something
  /// similar.
  FileParser<Generation<T>> _getFileParser(
    FileParser<Generation<T>>? fileParser,
    JsonConverter<dynamic, dynamic>? geneJsonConverter,
    JsonConverter<dynamic, dynamic> generationJsonConverter,
  ) {
    if (fileParser == null) {
      // TODO: Should update this to also check on generationJsonConverter
      geneJsonConverter ??= GeneticEvolution.geneJsonConverter;
      if (geneJsonConverter == null) {
        throw AssertionError(
          'Either JsonConverter or FileParser must be provided for '
          'GeneticEvolution loadFromFile.',
        );
      } else {
        fileParser = FileParser<Generation<T>>(
          geneJsonConverter: geneJsonConverter,
          generationJsonConverter: generationJsonConverter,
        );
      }
    }
    return fileParser;
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
  static JsonConverter? geneJsonConverter;

  /// The error to throw during an attempt to use a null [JsonConverter].
  static Error jsonConverterUnimplementedError = UnimplementedError(
    'geneJsonConverter is undefined on GeneticEvolution.',
  );

  /// Represents whether this object was created from a preloaded Generation.
  bool _fromLoad = false;

  Future<Generation<T>> nextGeneration() async {
    late Population<T> population;

    final generation = this._generation;
    // Default to -1 so that we are actually 0 indexed.
    final previousWave = generation?.wave ?? -1;
    // If we are preloading in, we do not want to increment the wave number yet.
    final increment = _fromLoad ? 0 : 1;
    final wave = previousWave + increment;
    if (generation == null) {
      // Initialize
      population = await populationService.randomPopulation(
        populationSize: geneticEvolutionConfig.populationSize,
      );
    } else if (_fromLoad) {
      // Set the population from the incoming generation
      population = generation.population;

      // We should only preload a population in once
      _fromLoad = false;
    } else {
      population = await populationService.reproduce(
        population: generation.population,
        wave: wave,
        populationSize: geneticEvolutionConfig.populationSize,
      );
    }

    return this._generation = Generation<T>(
      wave: wave,
      population: population,
    );
  }
}
