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

  /// Converts the input [json] into a [DNA] object.
  factory DNA.fromJson(Map<String, dynamic> json) {
    return DNA<T>(
      genes: (json['genes'] as List<dynamic>)
          .map((geneJson) => Gene<T>.fromJson(geneJson as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts the [DNA] object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'genes': genes.map((gene) => gene.toJson()).toList(),
    };
  }
}
