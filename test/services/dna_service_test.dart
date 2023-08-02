import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const numGenes = 10;
  final mockGene = MockGene();

  late GeneMutationService mockGeneMutationService;
  late GeneService mockGeneService;
  late DNAService testObject;

  setUp(() async {
    mockGeneMutationService = MockGeneMutationService();
    mockGeneService = MockGeneService();
    testObject = DNAService(
      numGenes: numGenes,
      geneMutationService: mockGeneMutationService,
    );
  });

  group('initialization', () {
    test('should throw assertion error if numGenes is 0', () async {
      const zeroNumGenes = 0;

      expect(
        () => DNAService(
            numGenes: zeroNumGenes,
            geneMutationService: mockGeneMutationService),
        throwsAssertionError,
      );
    });

    test('should throw assertion error if numGenes is negative', () async {
      const zeroNumGenes = -1;

      expect(
        () => DNAService(
            numGenes: zeroNumGenes,
            geneMutationService: mockGeneMutationService),
        throwsAssertionError,
      );
    });
  });

  group('randomDNA', () {
    test('returns a List of Genes that is numGenes long', () async {
      when(() => mockGeneMutationService.geneService)
          .thenReturn(mockGeneService);
      when(() => mockGeneService.randomGene()).thenReturn(mockGene);
      when(() => mockGeneMutationService.mutateGene(gene: mockGene, wave: 0))
          .thenReturn(mockGene);
      final List<Gene> genes = [];
      for (int i = 0; i < numGenes; i++) {
        genes.add(mockGene);
      }
      final expected = DNA(genes: genes);
      final actual = testObject.randomDNA();

      expect(actual, expected);

      verify(() => mockGeneService.randomGene()).called(numGenes);
      verify(() => mockGeneMutationService.mutateGene(gene: mockGene, wave: 0))
          .called(numGenes);
    });
  });
}
