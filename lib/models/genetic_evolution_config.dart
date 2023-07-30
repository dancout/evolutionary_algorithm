class GeneticEvolutionConfig {
  const GeneticEvolutionConfig({
    required this.numGenes,
    this.populationSize = 100,
    this.numParents = 2,
    this.trackParents = false,
    this.canReproduceWithSelf = true,
  });

  /// The number of genes in each DNA sequence within each Entity
  final int numGenes;

  /// The size of each population
  final int populationSize;

  /// The number of parents for each child Entity within a Population
  final int numParents;

  /// Whether or not to keep track of an Entity's parents from the previous
  /// generation.
  final bool trackParents;

  /// Indicates if an entity can reproduce with itself. If false, then the
  /// entity will be removed from the selection pool after being selected the
  /// first time.
  final bool canReproduceWithSelf;
}
