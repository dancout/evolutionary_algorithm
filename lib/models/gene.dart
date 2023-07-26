import 'package:equatable/equatable.dart';

class Gene<T> extends Equatable {
  const Gene({
    /// The intended encoded value for this Gene.
    required this.value,
    this.mutatedWaves,
  });

  /// The encoded value for this gene.
  final T value;

  // TODO: Add this into the mix as a list of waves that this gene was mutated
  /// on. The intention is to historically show when this gene was mutated.
  final List<int>? mutatedWaves;

  @override
  List<Object?> get props => [
        value,
      ];
}
