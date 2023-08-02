import 'package:flutter_test/flutter_test.dart';
import 'package:genetic_evolution/genetic_evolution.dart';

import '../mocks.dart';

const nonZeroBiasVal = 0.1;
const score = 10.0;
void main() {
  late FitnessService testObject;

  setUp(() async {
    testObject = FakeFitnessService();
  });

  group('calculateScore', () {
    test('will add nonZeroBias to internally calculated score', () async {
      const expected = score + nonZeroBiasVal;
      final actual = await testObject.calculateScore(dna: MockDNA());

      expect(actual, expected);
    });
  });
}

class FakeFitnessService extends FitnessService {
  @override
  double get nonZeroBias => nonZeroBiasVal;

  @override
  Future<double> scoringFunction({required DNA dna}) async {
    return score;
  }
}
