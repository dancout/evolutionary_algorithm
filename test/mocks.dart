import 'package:evolutionary_algorithm/models/gene.dart';
import 'package:evolutionary_algorithm/services/gene_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGeneService extends Mock implements GeneService {}

class MockGene extends Mock implements Gene {}
