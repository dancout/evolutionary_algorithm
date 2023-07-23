import 'package:evolutionary_algorithm/models/dna.dart';
import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:evolutionary_algorithm/services/gene_service.dart';

class DNAService {
  DNAService({
    required this.numGenes,
    required this.geneService,
  }) {
    assert(numGenes > 0);
  }

  /// The number of Genes required for a DNA sequence.
  // TODO: Consider moving this into randomDNA as a parameter
  final int numGenes;

  /// The GeneService used to intialize new Genes.
  final GeneService geneService;

  /// Returns a randomly intialized DNA object.
  DNA randomDNA() {
    final List<Gene> genes = <Gene>[];

    for (int i = 0; i < numGenes; i++) {
      genes.add(geneService.randomGene());
    }

    return DNA(genes: genes);
  }
}
