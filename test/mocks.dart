import 'dart:math';

import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:mocktail/mocktail.dart';

class MockGeneService extends Mock implements GeneService {}

class MockGene extends Mock implements Gene {}

class MockFitnessService extends Mock implements FitnessService {}

class MockDNAService extends Mock implements DNAService {}

class MockDNA extends Mock implements DNA {}

class MockEntityService extends Mock implements EntityService {}

class MockEntity extends Mock implements Entity {}

class MockRandom extends Mock implements Random {}

class MockSelectionService extends Mock implements SelectionService {}

class MockPopulationService extends Mock implements PopulationService {}

class MockGeneMutationService extends Mock implements GeneMutationService {}

class MockCrossoverService extends Mock implements CrossoverService {}
