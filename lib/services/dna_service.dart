part of 'package:genetic_evolution/genetic_evolution.dart';

/// Used to manipulate DNA.
class DNAService<T> extends Equatable {
  DNAService({
    required this.numGenes,
    required this.geneMutationService,
  }) {
    assert(numGenes > 0);
  }

  /// The number of Genes required for a DNA sequence.
  final int numGenes;

  /// Used to manipulate genes.
  final GeneMutationService<T> geneMutationService;

  /// Returns a randomly intialized DNA object.
  DNA<T> randomDNA() {
    final List<Gene<T>> genes = <Gene<T>>[];

    for (int i = 0; i < numGenes; i++) {
      final randomGene = geneMutationService.geneService.randomGene();
      genes.add(
        // mutateGene is called to account for trackMutatedWaves
        geneMutationService.mutateGene(
          gene: randomGene,
          wave: 0,
        ),
      );
    }

    return DNA(genes: genes);
  }

  @override
  List<Object?> get props => [
        numGenes,
        geneMutationService,
      ];
}
