part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents miscellaneous settings for evolution.
class GeneticEvolutionConfig {
  GeneticEvolutionConfig({
    required this.numGenes,
    required this.mutationRate,
    int? populationSize,
    int? numParents,
    bool? trackParents,
    bool? canReproduceWithSelf,
    bool? trackMutatedWaves,
    this.random,
    this.generationsToTrack,
  }) {
    this.populationSize = populationSize ?? 100;
    this.numParents = numParents ?? 2;
    this.trackParents = trackParents ?? false;
    this.canReproduceWithSelf = canReproduceWithSelf ?? true;
    this.trackMutatedWaves = trackMutatedWaves ?? false;

    assert(
      mutationRate >= 0.toDouble() && mutationRate <= 1.toDouble(),
      'mutationRate must be between 0 and 1, inclusively',
    );
  }

  /// The number of genes in each DNA sequence within each Entity
  final int numGenes;

  /// A value between 0 and 1, inclusively, that represents if this gene
  /// should mutate its value. A value of 0 will never mutate and a value of 1
  /// will always mutate.
  final double mutationRate;

  /// The size of each population
  late final int populationSize;

  /// The number of parents for each child Entity within a Population
  late final int numParents;

  /// Whether or not to keep track of an Entity's parents from the previous
  /// generation.
  late final bool trackParents;

  /// Indicates if an entity can reproduce with itself. If false, then the
  /// entity will be removed from the selection pool after being selected the
  /// first time.
  late final bool canReproduceWithSelf;

  /// Represents whether or not to track the list of waves this gene has been
  /// mutated.
  late final bool trackMutatedWaves;

  /// Used as the internal random number generator.
  final Random? random;

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

  factory GeneticEvolutionConfig.fromJson(Map<String, dynamic> json) {
    return GeneticEvolutionConfig(
      numGenes: json['numGenes'] as int,
      mutationRate: (json['mutationRate'] as num).toDouble(),
      populationSize: json['populationSize'] as int,
      numParents: json['numParents'] as int,
      trackParents: json['trackParents'] as bool,
      canReproduceWithSelf: json['canReproduceWithSelf'] as bool,
      trackMutatedWaves: json['trackMutatedWaves'] as bool,
      // TODO: Can random be written as a JSON object?
      // random: json['random'] as Random?,
      generationsToTrack: json['generationsToTrack'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numGenes': numGenes,
      'mutationRate': mutationRate,
      'populationSize': populationSize,
      'numParents': numParents,
      'trackParents': trackParents,
      'canReproduceWithSelf': canReproduceWithSelf,
      'trackMutatedWaves': trackMutatedWaves,
      'generationsToTrack': generationsToTrack,
    };
  }
}
