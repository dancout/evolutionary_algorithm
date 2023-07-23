import 'package:equatable/equatable.dart';
import 'package:evolutionary_algorithm/models/dna.dart';

class Entity extends Equatable {
  const Entity({
    required this.dna,
    required this.fitnessScore,
  });

  /// Represents the DNA makeup of this Entity.
  final DNA dna;

  /// Represents the fitness score for this Entity.
  final double fitnessScore;

  @override
  List<Object?> get props => [
        dna,
        fitnessScore,
      ];
}
