import 'package:evolutionary_algorithm/models/dna.dart';
import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:evolutionary_algorithm/services/dna_service.dart';
import 'package:evolutionary_algorithm/services/entity_service.dart';
import 'package:evolutionary_algorithm/services/fitness_service.dart';
import 'package:evolutionary_algorithm/services/gene_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGeneService extends Mock implements GeneService {}

class MockGene extends Mock implements Gene {}

class MockFitnessService extends Mock implements FitnessService {}

class MockDNAService extends Mock implements DNAService {}

class MockDNA extends Mock implements DNA {}

class MockEntityService extends Mock implements EntityService {}

class MockEntity extends Mock implements Entity {}
