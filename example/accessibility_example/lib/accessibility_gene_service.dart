import 'package:flutter/material.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/gene_service.dart';

class AccessibilityGeneService extends GeneService<Color> {
  AccessibilityGeneService({
    required super.mutationRate,
    super.random,
  });

  @override
  Color mutateValue({Color? value}) {
    if (value == null) {
      throw Exception('Found null Color value');
    }

    const opacity = 1.0;
    final index = random.nextInt(3);

    var offset = random.nextInt(1) + 1;
    offset *= (random.nextBool() ? 1 : -1);

    switch (index) {
      case 0:
        return Color.fromRGBO(
            value.red + offset, value.green, value.blue, opacity);
      case 1:
        return Color.fromRGBO(
            value.red, value.green + offset, value.blue, opacity);
      case 2:
        return Color.fromRGBO(
            value.red, value.green, value.blue + offset, opacity);
      default:
        throw Exception('could not match on index');
    }
  }

  @override
  Gene<Color> randomGene() {
    random.nextInt(266);

    final r = random.nextInt(266);
    final g = random.nextInt(266);
    final b = random.nextInt(266);
    const opacity = 1.0;

    var randomColor = Color.fromRGBO(r, g, b, opacity);

    return Gene(value: randomColor);
  }
}
