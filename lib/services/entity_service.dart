import 'dart:math';

import 'package:evolutionary_algorithm/models/dna.dart';
import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:evolutionary_algorithm/services/dna_service.dart';
import 'package:evolutionary_algorithm/services/fitness_service.dart';

class EntityService {
  EntityService({
    required this.dnaService,
    required this.fitnessService,
    Random? random,
  }) : random = random ?? Random();

  /// Represents the DNAService used internally.
  final DNAService dnaService;

  /// Represents the service used to calculate this entity's fitness core.
  final FitnessService fitnessService;

  /// Used as the internal random number generator.
  final Random random;

  Entity randomEntity() {
    final randomDNA = dnaService.randomDNA();
    return Entity(
      dna: randomDNA,
      fitnessScore: fitnessService.calculateScore(dna: randomDNA),
    );
  }

  /// Returns an Entity created by randomly crossing over the genes present
  /// within the input [parents].
  Entity crossOver({
    required List<Entity> parents,
  }) {
    // Initialize your list of Genes
    final List<Gene> crossedOverGenes = [];
    // Declare the number of parents
    final numParents = parents.length;

    // Generate a list of random indices between 0 and the number of parents
    final List<int> randIndices = List.generate(
      dnaService.numGenes,
      (_) => random.nextInt(numParents),
    );

    // Populate the crossedOverGenes list with genes from the input parents
    for (int i = 0; i < dnaService.numGenes; i++) {
      crossedOverGenes.add(parents[randIndices[i]].dna.genes[i]);
    }

    // Declare the new DNA
    final dna = DNA(genes: crossedOverGenes);
    // Declare the fitness score of this new DNA
    final fitnessScore = fitnessService.calculateScore(dna: dna);

    // Return the newly created Entity
    return Entity(dna: dna, fitnessScore: fitnessScore);
  }
}
