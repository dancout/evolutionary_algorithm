part of 'package:genetic_evolution/genetic_evolution.dart';

/// Used to manipulate Entity objects.
class EntityService<T> extends Equatable {
  EntityService({
    required this.dnaService,
    required this.fitnessService,
    required this.geneMutationService,
    required this.trackParents,
    Random? random,
    @visibleForTesting CrossoverService<T>? crossoverService,
  }) : crossoverService = crossoverService ??
            CrossoverService(
              geneMutationService: geneMutationService,
              random: random ?? Random(),
            );

  /// Represents the DNAService used internally.
  final DNAService<T> dnaService;

  /// Represents the service used to calculate this entity's fitness core.
  final FitnessService fitnessService;

  /// Represents the service used when mutating genes.
  final GeneMutationService<T> geneMutationService;

  final CrossoverService<T> crossoverService;

  /// Whether or not to keep track of an Entity's parents from the previous
  /// generation.
  final bool trackParents;

  Future<Entity<T>> randomEntity() async {
    final randomDNA = dnaService.randomDNA();
    return Entity<T>(
      dna: randomDNA,
      fitnessScore: await fitnessService.calculateScore(dna: randomDNA),
    );
  }

  /// Returns an Entity created by randomly crossing over the genes present
  /// within the input [parents].
  Future<Entity<T>> crossOver({
    required List<Entity<T>> parents,
    required int wave,
  }) async {
    // Create a list of genes that have been crossed over between the parents
    final List<Gene<T>> crossedOverGenes = await crossoverService.crossover(
      parents: parents,
      wave: wave,
    );

    // Declare the new DNA
    final dna = DNA<T>(genes: crossedOverGenes);
    // Declare the fitness score of this new DNA
    final fitnessScore = await fitnessService.calculateScore(dna: dna);

    // Return the newly created Entity
    return Entity(
      dna: dna,
      fitnessScore: fitnessScore,
      parents: trackParents ? parents : null,
    );
  }

  @override
  List<Object?> get props => [
        dnaService,
        fitnessService,
        geneMutationService,
        trackParents,
        crossoverService,
      ];
}
