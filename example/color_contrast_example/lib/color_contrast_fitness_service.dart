import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/services/fitness_service.dart';

class ColorContrastFitnessService extends FitnessService<int> {
  @override
  double get nonZeroBias => 0.01;

  @override
  double scoringFunction({required DNA<int> dna}) {
    const opacity = 1.0;
    final textColorR = dna.genes[0].value;
    final textColorG = dna.genes[1].value;
    final textColorB = dna.genes[2].value;

    final textColor =
        Color.fromRGBO(textColorR, textColorG, textColorB, opacity);

    final backgroundColorR = dna.genes[3].value;
    final backgroundColorG = dna.genes[4].value;
    final backgroundColorB = dna.genes[5].value;

    final backgroundColor = Color.fromRGBO(
        backgroundColorR, backgroundColorG, backgroundColorB, opacity);

    return contrastScore(
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  double contrastScore({
    required Color textColor,
    required Color backgroundColor,
  }) {
    final lum1 = textColor.computeLuminance();
    final lum2 = backgroundColor.computeLuminance();

    final brightestLum = max(lum1, lum2);
    final darkestLum = min(lum1, lum2);

    final score = (brightestLum + 0.05) / (darkestLum + 0.05);

    return pow(score, 2.5).toDouble();
  }
}
