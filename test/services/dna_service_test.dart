import 'package:evolutionary_algorithm/models/dna.dart';
import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:evolutionary_algorithm/services/dna_service.dart';
import 'package:evolutionary_algorithm/services/gene_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const numGenes = 10;
  final mockGene = MockGene();

  late GeneService mockGeneService;
  late DNAService testObject;

  setUp(() async {
    mockGeneService = MockGeneService();
    testObject = DNAService(numGenes: numGenes, geneService: mockGeneService);
  });

  group('randomDNA', () {
    test('returns a List of Genes that is numGenes long', () async {
      when(() => mockGeneService.randomGene()).thenReturn(mockGene);
      final List<Gene> genes = [];
      for (int i = 0; i < numGenes; i++) {
        genes.add(mockGene);
      }
      final expected = DNA(genes: genes);
      final actual = testObject.randomDNA();

      expect(actual, expected);

      verify(() => mockGeneService.randomGene()).called(numGenes);
    });
  });
}
