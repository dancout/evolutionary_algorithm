import 'dart:math';

import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/services/dna_service.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/fitness_service.dart';
import 'package:genetic_evolution/services/gene_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';
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
