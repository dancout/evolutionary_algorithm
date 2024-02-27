part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents a single Entity within a larger Population.
class Entity<T> extends Equatable {
  const Entity({
    required this.dna,
    required this.fitnessScore,
    this.parents,
  });

  /// Represents the DNA makeup of this Entity.
  final DNA<T> dna;

  /// Represents the fitness score for this Entity.
  final double fitnessScore;

  /// Represents the parents of this entity.
  final List<Entity<T>>? parents;

  /// Returns a copied version of this [Entity] with only the inputs updated.
  Entity<T> copyWith({
    DNA<T>? dna,
    double? fitnessScore,
    List<Entity<T>>? parents,
  }) {
    return Entity(
      dna: dna ?? this.dna,
      fitnessScore: fitnessScore ?? this.fitnessScore,
      parents: parents ?? this.parents,
    );
  }

  @override
  List<Object?> get props => [
        dna,
        fitnessScore,
        parents,
      ];

  /// Converts the input [json] into a [Entity] object.
  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity<T>(
      dna: DNA<T>.fromJson(json['dna']),
      fitnessScore: (json['fitnessScore'] as num).toDouble(),
      parents: (json['parents'] as List<dynamic>?)
          ?.map((parentJson) =>
              Entity<T>.fromJson(parentJson as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts the [Entity] object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'dna': dna.toJson(),
      'fitnessScore': fitnessScore,
      'parents': parents?.map((parent) => parent.toJson()).toList(),
    };
  }
}
