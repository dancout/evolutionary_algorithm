import 'package:equatable/equatable.dart';
import 'package:genetic_evolution/models/gene.dart';

class DNA extends Equatable {
  const DNA({
    required this.genes,
  });

  final List<Gene> genes;

  @override
  List<Object?> get props => [
        genes,
      ];
}
