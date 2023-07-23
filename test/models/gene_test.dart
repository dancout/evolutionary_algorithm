import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:flutter_test/flutter_test.dart';

const mutatedValue = 100;

void main() {
  const value = 1;

  group('mutationRate', () {
    test('less than zero will throw assertion', () async {
      const mutationRate = -1.0;

      expect(
        () => FakeGene(value: value, mutationRate: mutationRate),
        throwsAssertionError,
      );
    });

    test('more than one will throw assertion', () async {
      const mutationRate = 1.1;

      expect(
        () => FakeGene(value: value, mutationRate: mutationRate),
        throwsAssertionError,
      );
    });

    test('within 0 and 1, inclusively, will complete without error', () async {
      double mutationRate = 0.0;

      while (mutationRate <= 1.0) {
        FakeGene(value: value, mutationRate: mutationRate); // Expect no errors
        mutationRate += 0.1;
      }
    });
  });

  group('mutate', () {
    test('is called when mutationRate is higher than internal random number',
        () async {
      const randomValue = 0.1;
      const mutationRate = 0.2;
      final actualValue = FakeGene(
        value: value,
        mutationRate: mutationRate,
        randomValue: randomValue,
      ).value;

      expect(actualValue, mutatedValue);
    });

    test(
        'is not called when mutationRate is higher than internal random number',
        () async {
      const randomValue = 0.2;
      const mutationRate = 0.1;
      final actualValue = FakeGene(
        value: value,
        mutationRate: mutationRate,
        randomValue: randomValue,
      ).value;

      expect(actualValue, value);
    });
  });
}

class FakeGene extends Gene<int> {
  FakeGene({
    required super.value,
    super.mutationRate,
    super.randomValue,
  });

  @override
  int mutate({int? value}) {
    return mutatedValue;
  }
}
