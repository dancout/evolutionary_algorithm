import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/gene_service.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

const mutatedValue = 2;

void main() {
  const value = 1;
  const gene = Gene(value: value);
  const wave = 1;

  late Random mockRandom;

  setUp(() async {
    mockRandom = MockRandom();
  });

  group('mutationRate', () {
    test('less than zero will throw assertion', () async {
      const mutationRate = -1.0;

      expect(
        () => FakeGeneService(mutationRate: mutationRate),
        throwsAssertionError,
      );
    });

    test('more than one will throw assertion', () async {
      const mutationRate = 1.1;

      expect(
        () => FakeGeneService(mutationRate: mutationRate),
        throwsAssertionError,
      );
    });

    test('within 0 and 1, inclusively, will complete without error', () async {
      double mutationRate = 0.0;

      while (mutationRate <= 1.0) {
        () => FakeGeneService(mutationRate: mutationRate); // Expect no errors
        mutationRate += 0.1;
      }
    });
  });

  group('mutateGene', () {
    test('is called when mutationRate is higher than internal random number',
        () async {
      const randomValue = 0.1;
      const mutationRate = 0.2;

      when(() => mockRandom.nextDouble()).thenReturn(randomValue);

      final testObject = FakeGeneService(
        mutationRate: mutationRate,
        random: mockRandom,
      );

      final actualValue = testObject
          .mutateGene(
            gene: gene,
            wave: wave,
          )
          .value;

      expect(actualValue, mutatedValue);
    });

    test('is will save list of mutated waves when trackMutatedWaves is true',
        () async {
      const randomValue = 0.1;
      const mutationRate = 0.2;

      when(() => mockRandom.nextDouble()).thenReturn(randomValue);

      final testObject = FakeGeneService(
        mutationRate: mutationRate,
        trackMutatedWaves: true,
        random: mockRandom,
      );

      const expected = Gene(
        value: mutatedValue,
        mutatedWaves: [wave],
      );

      final actualGene = testObject.mutateGene(
        gene: gene,
        wave: wave,
      );

      expect(actualGene, expected);
    });

    test(
        'is not called when mutationRate is higher than internal random number',
        () async {
      const randomValue = 0.2;
      const mutationRate = 0.1;

      when(() => mockRandom.nextDouble()).thenReturn(randomValue);

      final testObject = FakeGeneService(
        mutationRate: mutationRate,
        random: mockRandom,
      );

      final actualValue = testObject
          .mutateGene(
            gene: gene,
            wave: wave,
          )
          .value;

      expect(actualValue, value);
    });
  });
}

class FakeGeneService extends GeneService<int> {
  FakeGeneService({
    required super.mutationRate,
    super.trackMutatedWaves,
    super.random,
  });

  @override
  mutateValue({value}) {
    return mutatedValue;
  }

  @override
  Gene<int> randomGene() {
    throw UnimplementedError();
  }
}
