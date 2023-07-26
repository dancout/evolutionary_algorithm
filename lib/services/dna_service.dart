import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/gene_service.dart';

class DNAService<T> {
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
      genes.add(geneService.randomGene());
    }

    return DNA(genes: genes);
  }
}
