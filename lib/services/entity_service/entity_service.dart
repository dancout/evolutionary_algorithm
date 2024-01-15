part of 'package:genetic_evolution/genetic_evolution.dart';

/// Used to manipulate Entity objects.
class EntityService<T> extends Equatable {
  EntityService({
    required this.dnaService,
    required this.fitnessService,

    /// Represents the service used when mutating genes.
    required GeneMutationService<T> geneMutationService,
    required this.entityParentManinpulator,
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

  /// Represents the service used to crossover parents into a child entity.
  final CrossoverService<T> crossoverService;

  /// Used to handle keeping track of the parents of an Entity after it has been
  /// crossed over.
  final EntityParentManinpulator<T> entityParentManinpulator;

  /// Generates a random Entity.
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

    // Update parents of Entity using helper class
    final updatedParents = entityParentManinpulator.updateParents(
      parents: parents,
      currentGeneration: 1,
    );

    // Return the newly created Entity
    return Entity<T>(
      dna: dna,
      fitnessScore: fitnessScore,
      parents: updatedParents,
    );
  }

  @override
  List<Object?> get props => [
        dnaService,
        fitnessService,
        crossoverService,
        entityParentManinpulator,
      ];
}
