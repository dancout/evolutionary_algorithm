import 'package:equatable/equatable.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/gene_service.dart';

/// Used to manipulate DNA.
class DNAService<T> extends Equatable {
  DNAService({
    required this.numGenes,
    required this.geneService,
  }) {
    assert(numGenes > 0);
  }

  /// The number of Genes required for a DNA sequence.
  final int numGenes;

  /// The GeneService used to intialize new Genes.
  final GeneService<T> geneService;

  /// Returns a randomly intialized DNA object.
  DNA<T> randomDNA() {
    final List<Gene<T>> genes = <Gene<T>>[];

    for (int i = 0; i < numGenes; i++) {
      final randomGene = geneService.randomGene();
      genes.add(
        // mutateGene is called to account for trackMutatedWaves
        geneService.mutateGene(
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
        geneService,
      ];
}
