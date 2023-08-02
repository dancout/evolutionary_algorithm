import 'package:equatable/equatable.dart';
import 'package:genetic_evolution/models/gene.dart';

/// Represents the DNA makeup of a single Entity.
class DNA<T> extends Equatable {
  const DNA({
    required this.genes,
  });

  final List<Gene<T>> genes;

  @override
  List<Object?> get props => [
        genes,
      ];
}
