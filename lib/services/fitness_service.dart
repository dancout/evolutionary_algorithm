import 'package:genetic_evolution/models/dna.dart';

abstract class FitnessService<T> {
  double calculateScore({required DNA dna});
}
