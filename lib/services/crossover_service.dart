part of 'package:genetic_evolution/genetic_evolution.dart';

class CrossoverService<T> extends Equatable {
  CrossoverService({
    required this.geneMutationService,
    Random? random,
  }) : random = random ?? Random();

  final GeneMutationService<T> geneMutationService;
  final Random random;

  Future<List<Gene<T>>> crossover({
    required List<Entity<T>> parents,
    required int wave,
  }) async {
    final List<Gene<T>> crossedOverGenes = [];

    // Get the number of genes within a parent
    final numGenes = parents.first.dna.genes.length;

    // Get the number of parents
    final numParents = parents.length;

    // Populate the crossedOverGenes list with genes from the input parents
    for (int i = 0; i < numGenes; i++) {
      // Select a gene from a random parent
      final parentalGene = parents[random.nextInt(numParents)].dna.genes[i];

      // Potentially mutate this gene
      final potentiallyMutatedGene = geneMutationService.mutateGene(
        gene: parentalGene,
        wave: wave,
      );

      // Add this gene into the list of Crossed Over Genes
      crossedOverGenes.add(
        potentiallyMutatedGene,
      );
    }
    return crossedOverGenes;
  }

  @override
  List<Object?> get props => [
        geneMutationService,
        random,
      ];
}
