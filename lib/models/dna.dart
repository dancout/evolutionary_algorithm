part of 'package:genetic_evolution/genetic_evolution.dart';

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
