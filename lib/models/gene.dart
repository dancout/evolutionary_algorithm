part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents a single Gene in a larget set of DNA.
class Gene<T> extends Equatable {
  const Gene({
    /// The intended encoded value for this Gene.
    required this.value,
    this.mutatedWaves,
  });

  /// The encoded value for this gene.
  final T value;

  /// The list of waves that this Gene has mutated.
  final List<int>? mutatedWaves;

  @override
  List<Object?> get props => [
        value,
        mutatedWaves,
      ];

  /// Converts the input [json] into a [Gene] object.
  factory Gene.fromJson(Map<String, dynamic> json) {
    // Grab the static JsonConverter
    final geneJsonConverter = GeneticEvolution.geneJsonConverter;

    // Check that it has been set
    if (geneJsonConverter != null) {
      return Gene<T>(
        value: geneJsonConverter.fromJson(json['value']),
        mutatedWaves: (json['mutatedWaves'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(),
      );
    }
    // If not, then throw an error from attempting to use a null JsonConverter.
    throw GeneticEvolution.jsonConverterUnimplementedError;
  }

  /// Converts the [Gene] object to JSON.
  Map<String, dynamic> toJson() {
    // Grab the static JsonConverter
    final geneJsonConverter = GeneticEvolution.geneJsonConverter;

    // Check that it has been set
    if (geneJsonConverter != null) {
      return {
        'value': geneJsonConverter.toJson(value),
        'mutatedWaves': mutatedWaves,
      };
    }

    // If not, then throw an error from attempting to use a null JsonConverter.
    throw GeneticEvolution.jsonConverterUnimplementedError;
  }
}
