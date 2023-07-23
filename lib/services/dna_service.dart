import 'package:evolutionary_algorithm/models/dna.dart';

abstract class DNAService {
  const DNAService();

  /// Returns a randomly intialized DNA object.
  DNA randomDNA({
    /// Optional parameter to describe the number of Genes to be created for
    /// this DNA object.
    int length,
  });
}
