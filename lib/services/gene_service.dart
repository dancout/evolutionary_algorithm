part of 'package:genetic_evolution/genetic_evolution.dart';

/// Used for manipulating Genes.
abstract class GeneService<T> {
  GeneService();

  /// Returns a randomly initialized Gene of type <T>.
  Gene<T> randomGene();

  /// Returns a mutated encoded value of type <T>.
  @visibleForTesting
  T mutateValue({T? value});
}
