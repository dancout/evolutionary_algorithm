import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/services/dna_service.dart';
import 'package:evolutionary_algorithm/services/fitness_service.dart';

class EntityService {
  const EntityService({
    required this.dnaService,
    required this.fitnessService,
  });

  final DNAService dnaService;
  final FitnessService fitnessService;

  Entity randomEntity() {
    final randomDNA = dnaService.randomDNA();
    return Entity(
      dna: randomDNA,
      fitnessScore: fitnessService.calculateScore(dna: randomDNA),
    );
  }
}
