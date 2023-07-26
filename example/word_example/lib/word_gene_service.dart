import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/gene_service.dart';

class WordGeneService extends GeneService<String> {
  WordGeneService({
    required super.mutationRate,
    super.random,
  });

  @override
  mutateValue({value}) {
    return randomGene().value;
  }

  @override
  Gene<String> randomGene() {
    final List<int> possibleCharacters = [];

    for (int i = 65; i < 91; i++) {
      possibleCharacters.add(i);
    }

    possibleCharacters.add(32); // space

    var nextInt = random.nextInt(possibleCharacters.length);
    final randomUppercaseLetter =
        String.fromCharCode(possibleCharacters[nextInt]);

    return Gene(
      value: randomUppercaseLetter,
    );
  }
}
