part of 'package:genetic_evolution/genetic_evolution.dart';

// TODO: Write tests for this file.
class CrossoverService<T> {
  const CrossoverService({
    required this.dnaService,
    required this.geneMutationService,
  });

  final DNAService<T> dnaService;
  final GeneMutationService<T> geneMutationService;

  List<Gene<T>> crossover({
    required List<Entity<T>> parents,
    required List<int> randIndices,
    required int wave,
  }) {
    final List<Gene<T>> crossedOverGenes = [];

    // Populate the crossedOverGenes list with genes from the input parents
    for (int i = 0; i < dnaService.numGenes; i++) {
      final parentalGene = parents[randIndices[i]].dna.genes[i];

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
}
