library genetic_evolution;

import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:genetic_evolution/services/gene_service.dart';
import 'package:genetic_evolution/services/population_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';

class GeneticEvolution {
  GeneticEvolution({
    required this.populationSize,
    required this.numGenes,
    required this.fitnessService,
    required this.geneService,
    this.numParents = 2,
    this.canReproduceWithSelf,
  }) {
    final dnaService = DNAService(
      numGenes: numGenes,
      geneService: geneService,
    );

    final entityService = EntityService(
      dnaService: dnaService,
      fitnessService: fitnessService,
      geneService: geneService,
    );

    final selectionService = SelectionService(
      canReproduceWithSelf: canReproduceWithSelf,
      numParents: numParents,
    );

    populationService = PopulationService(
      entityService: entityService,
      selectionService: selectionService,
    );
  }

  /// The service used to generate new populations for each generation
  late final PopulationService populationService;

  /// The size of each population
  final int populationSize;

  /// The number of parents for each child Entity within a Population
  final int numParents;

  /// The number of genes in each DNA sequence within each Entity
  final int numGenes;

  /// Indicates if an entity can reproduce with itself. If false, then the
  /// entity will be removed from the selection pool after being selected the
  /// first time.
  final bool? canReproduceWithSelf;

  /// Represents the service used to calculate an entity's fitness core.
  final FitnessService fitnessService;

  /// The GeneService used to intialize new Genes.
  final GeneService geneService;

  Generation? generation;

  Generation nextGeneration() {
    late Population population;

    final generation = this.generation;
    if (generation == null) {
      // Initialize
      population =
          populationService.randomPopulation(populationSize: populationSize);
    } else {
      population = populationService.reproduce(
        population: generation.population,
      );
    }

    return this.generation = Generation(
      // Default to -1 so that we are actually 0 indexed
      wave: (generation?.wave ?? -1) + 1,
      population: population,
    );
  }
}
