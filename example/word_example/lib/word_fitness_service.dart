import 'dart:math';

import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:word_example/word_home_page.dart';

class WordFitnessService extends FitnessService<String> {
  @override
  double get nonZeroBias => 0.01;

  @override
  Future<double> scoringFunction({required DNA<String> dna}) async {
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
