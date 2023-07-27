import 'dart:math';

import 'package:accessibility_example/accessibility_home_page.dart';
import 'package:flutter/material.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/services/fitness_service.dart';

class AccessibilityFitnessService extends FitnessService<Color> {
  @override
  double get nonZeroBias => 0.01;

  @override
  double scoringFunction({required DNA<Color> dna}) {
    final textColor = dna.genes[textColorIndex].value;
    final backgroundColor = dna.genes[backgroundColorIndex].value;

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

    // TODO: Clean this up
    return pow(score, 1.1).toDouble();
    // return score * 2.25;
    // return score * 2.0;
    // return score * 1.75;
    // return score * 1.5;
    // return score * 1.17;
    // return score * 1.157;
    // return score * 1.15575;
    // this one kinda hovers at 23.24 for like forever - return score * 1.15555;
    // a good one is mutation rate 0.0125 and score multiplyer of 1.15 -- didn't get to saturation though
  }
}
