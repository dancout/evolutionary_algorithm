import 'dart:math';

import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:word_example/word_home_page.dart';

class WordFitnessService extends FitnessService {
  @override
  double get nonZeroBias => 0.01;

  @override
  double scoringFunction({required DNA dna}) {
    final List<String> targetChars = target.split('');

    double score = 0;
    for (int i = 0; i < targetChars.length; i++) {
      if (dna.genes[i].value == targetChars[i]) {
        score += 1;
      }
    }

    return pow(3, score).toDouble();
  }
}
