import 'package:evolutionary_algorithm/models/dna.dart';

abstract class FitnessService<T> {
  double calculateScore({required DNA dna});
}
