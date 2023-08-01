import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/gene_service.dart';

class ColorContrastGeneService extends GeneService<int> {
  ColorContrastGeneService({
    required super.mutationRate,
    super.trackMutatedWaves,
    super.random,
  });

  @override
  int mutateValue({int? value}) {
    if (value == null) {
      throw Exception('Found null Gene value when mutating');
    }

    var offset = 1;
    offset *= (random.nextBool() ? 1 : -1);

    return (value + offset).clamp(0, 255);
  }

  @override
  Gene<int> randomGene() {
    return Gene(value: random.nextInt(256));
  }
}
