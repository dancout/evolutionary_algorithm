import 'package:equatable/equatable.dart';

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
}
