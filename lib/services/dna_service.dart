import 'package:evolutionary_algorithm/models/dna.dart';
import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:evolutionary_algorithm/services/gene_service.dart';

class DNAService {
  const DNAService({
    required this.numGenes,
    required this.geneService,
  });

  /// The number of Genes required for a DNA sequence.
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
