part of 'package:genetic_evolution/genetic_evolution.dart';

/// Used for mutating a given gene.
class GeneMutationService<T> extends Equatable {
  @visibleForTesting
  GeneMutationService({
    required this.trackMutatedWaves,
    required this.mutationRate,
    required this.geneService,
    Random? random,
  }) {
    assert(
      mutationRate >= 0.toDouble() && mutationRate <= 1.toDouble(),
      'mutationRate must be between 0 and 1, inclusively',
    );

    this.random = random ?? Random();
  }

  /// A value between 0 and 1, inclusively, that represents if this gene
  /// should mutate its value.
  ///
  /// A value of 0 will never mutate and a value of 1 will always mutate.
  final double mutationRate;

  /// Whether to track the list of waves this gene has been mutated.
  final bool trackMutatedWaves;

  /// Used for mutating the values of genes.
  final GeneService<T> geneService;

  /// Used as the internal random number generator.
  late final Random random;

  /// This function will return a Gene of type <T> that may have been mutated
  /// based on the [mutationRate] of this class.
  Gene<T> mutateGene({
    /// The base Gene to be potentially mutated against.
    required Gene<T> gene,
    required int wave,
  }) {
    // Declare the value of type <T> to be passed forward.
    late final T value;

    // Grab the list of mutated waves from the incoming Gene.
    var mutatedWaves = gene.mutatedWaves;

    if (wave == 0 && trackMutatedWaves) {
      // If it is the first wave and we should be tracking mutated waves, set
      // the list.
      mutatedWaves = [];
    } else if (mutatedWaves != null) {
      // If mutatedWaves exists, create a new list
      mutatedWaves = List.from(mutatedWaves);
    }
    // Otherwise, we keep the mutatedWaves list null because we are not tracking
    // them.

    // Generate a random value between 0 and 1.
    final randomValue = random.nextDouble();

    // Check if we should mutate this gene. We don't need to mutate on the first
    // wave.
    if (mutationRate > randomValue && wave > 0) {
      // Mutate the value.
      value = geneService.mutateValue(value: gene.value);
      mutatedWaves?.add(wave);
    } else {
      // Pass the same value forward.
      value = gene.value;
    }

    return Gene<T>(
      value: value,
      mutatedWaves: mutatedWaves,
    );
  }

  @override
  List<Object?> get props => [
        trackMutatedWaves,
        mutationRate,
        geneService,
        random,
      ];
}
