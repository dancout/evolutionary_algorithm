import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/gene_service.dart';
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

  group('initialization', () {
    test('should throw assertion error if numGenes is 0', () async {
      const zeroNumGenes = 0;

      expect(
        () => DNAService(numGenes: zeroNumGenes, geneService: mockGeneService),
        throwsAssertionError,
      );
    });

    test('should throw assertion error if numGenes is negative', () async {
      const zeroNumGenes = -1;

      expect(
        () => DNAService(numGenes: zeroNumGenes, geneService: mockGeneService),
        throwsAssertionError,
      );
    });
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
