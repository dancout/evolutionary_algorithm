part of 'package:genetic_evolution/genetic_evolution.dart';

/// Used to manipulate Entity objects.
class EntityService<T> extends Equatable {
  EntityService({
    required this.dnaService,
    required this.fitnessService,

    /// Represents the service used when mutating genes.
    required GeneMutationService<T> geneMutationService,
    required this.trackParents,
    int? generationsToTrack,
    Random? random,
    @visibleForTesting CrossoverService<T>? crossoverService,
  })  : generationsToTrack = generationsToTrack ?? (trackParents ? 1 : 0),
        crossoverService = crossoverService ??
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

  /// Whether or not to keep track of an Entity's parents from the previous
  /// generation.
  final bool trackParents;

  /// The number of generations of parents to track.
  ///
  /// For example:
  /// - 1 means you would only track the parents of this Entity
  /// - 2 means you would track the parents & grandparents of this Entity
  /// - 3 means you would track the parents, grandparents, & great grandparents
  ///     of this Entity.
  /// TODO: What does null mean? Or zero? How can I specify that I want to track *all* generations?
  final int generationsToTrack;

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

    // Update parents, if necessary
    final updatedParents = trackParents
        ? updateParents(
            parents: parents,
            currentGeneration: 1,
          )
        : null;
    // Return the newly created Entity
    return Entity<T>(
      dna: dna,
      fitnessScore: fitnessScore,
      parents: updatedParents,
    );
  }

// TODO: This should probs be in a helper function elsewhere to be mockable
// TODO: Tests around this!
  List<Entity<T>>? updateParents({
    required List<Entity<T>>? parents,
    required int currentGeneration,
  }) {
    // Check if there are parents to be updated
    if (parents == null || parents.isEmpty) {
      return parents;
    }

    // Check if our recursive end state has been met.
    if (currentGeneration == generationsToTrack) {
      // Now that we have found the last generation to track, the parents above
      // this generation does not need to be stored.
      return parents
          .map(
            (parentEntity) => parentEntity.copyWith(
              parents: [],
            ),
          )
          .toList();
    }

    // Recursively call to update the parents of the next generation.
    return parents
        .map(
          (parentEntity) => parentEntity.copyWith(
            parents: updateParents(
              parents: parentEntity.parents,
              currentGeneration: currentGeneration + 1,
            ),
          ),
        )
        .toList();
  }

  @override
  List<Object?> get props => [
        dnaService,
        fitnessService,
        trackParents,
        crossoverService,
      ];
}
