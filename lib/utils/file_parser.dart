part of 'package:genetic_evolution/genetic_evolution.dart';

/// Parses [Generation] objects to and from text files.
///
/// This class has a Type <T> where <T> is meant to be Generation<S>.
/// ie. FileParser<Generation<int>>.
class FileParser<T> {
  FileParser({
    required this.geneJsonConverter,
    required this.generationJsonConverter,
    this.getDirectoryPath = getApplicationDocumentsDirectory,
  }) {
    // TODO: This GeneticEvolution.jsonConverter is meant to convert the Gene of
    /// Type <T>, and should not be shared with the converter of a Generation!

    // Set the jsonConverter within the GeneticEvolution class so that we can
    // properly convert to and from Json on Type <T>.
    GeneticEvolution.geneJsonConverter = geneJsonConverter;
  }

  /// Used to convert [Gene] objects to and from Json.
  final JsonConverter geneJsonConverter;

  /// Used to convert the object of Type <T> to and from Json.
  final JsonConverter generationJsonConverter;

  /// Represents the directory path to find the parsed documents.
  final Future<Directory> Function() getDirectoryPath;

  /// Returns a formatted filename based on the input [wave].
  String generationFileName(int wave) => 'generation wave $wave.txt';

  /// Writes the input [generation] to a text file.
  Future<void> writeGenerationToFile({
    required T generation,
  }) async {
    final directoryPath = (await getDirectoryPath()).path;
    final filename = generationFileName((generation as Generation).wave);

    final myFile = File('$directoryPath/$filename');
    await myFile.writeAsString(
      jsonEncode(generationJsonConverter.toJson(generation)),
    );
  }

  /// Returns a [Generation] object read in from a text file corresponding with
  /// the input [wave].
  Future<T> readGenerationFromFile({
    required int wave,
  }) async {
    final directoryPath = (await getDirectoryPath()).path;
    final filename = generationFileName(wave);

    final myFile = File('$directoryPath/$filename');
    final jsonString = await myFile.readAsString();

    return generationJsonConverter.fromJson(jsonDecode(jsonString));
  }
}
