import 'package:equatable/equatable.dart';

class Gene<T> extends Equatable {
  const Gene({
    /// The intended encoded value for this Gene.
    required this.value,
  });

  /// The encoded value for this gene.
  final T value;

  @override
  List<Object?> get props => [
        value,
      ];
}
