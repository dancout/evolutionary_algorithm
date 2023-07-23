import 'package:evolutionary_algorithm/models/dna.dart';
import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/services/dna_service.dart';
import 'package:evolutionary_algorithm/services/entity_service.dart';
import 'package:evolutionary_algorithm/services/fitness_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  final DNA mockDNA = MockDNA();
  const fitnessScore = 100.0;

  late DNAService mockDnaService;
  late FitnessService mockFitnessService;

  late EntityService testObject;

  setUp(() async {
    mockDnaService = MockDNAService();
    mockFitnessService = MockFitnessService();
    testObject = EntityService(
      dnaService: mockDnaService,
      fitnessService: mockFitnessService,
    );
  });

  group('randomEntity', () {
    test(
        'calls proper services to createa random DNA object and score its fitness',
        () async {
      when(() => mockDnaService.randomDNA()).thenReturn(mockDNA);
      when(() => mockFitnessService.calculateScore(dna: mockDNA))
          .thenAnswer((_) => fitnessScore);
      final expected = Entity(dna: mockDNA, fitnessScore: fitnessScore);
      final actual = testObject.randomEntity();

      expect(actual, expected);

      verify(() => mockDnaService.randomDNA());
      verify(() => mockFitnessService.calculateScore(dna: mockDNA));
    });
  });
}
