part of 'package:genetic_evolution/genetic_evolution.dart';

class EntityParentManinpulator<T> extends Equatable {
  const EntityParentManinpulator({
    required this.trackParents,
    this.generationsToTrack,
  });

  /// The number of generations of parents to track. A null value signifies that
  /// you will track every set of parents across every generation.
  ///
  /// For example:
  /// - null means you would track all parents as far back as possible.
  /// - 1 means you would only track the parents of this Entity.
  /// - 2 means you would track the parents & grandparents of this Entity.
  /// - 3 means you would track the parents, grandparents, & great grandparents
  ///     of this Entity.
  ///
  /// This value is not intended to be negative.
  final int? generationsToTrack;

  /// Whether or not to keep track of an Entity's parents from the previous
  /// generation.
  final bool trackParents;

  List<Entity<T>>? updateParents({
    required List<Entity<T>>? parents,
    required int currentGeneration,
  }) {
    // Check if there are parents to be updated
    if (!trackParents ||
        parents == null ||
        parents.isEmpty ||
        (generationsToTrack == 0)) {
      return null;
    }

    // Check if our recursive end state has been met.
    if (currentGeneration == generationsToTrack) {
      // Now that we have found the last generation to track, the parents above
      // this generation does not need to be stored.
      return parents
          .map(
            (parentEntity) => parentEntity.copyWith(
              // NOTE:  This value cannot be null because the copyWith function
              //        would then fallback to the default value of [parents] on
              //        this parentEntity.
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
        trackParents,
        generationsToTrack,
      ];
}
