part of 'package:genetic_evolution/genetic_evolution.dart';

/// Parses [Generation] objects to and from text files.
class FileParser<T> {
  FileParser({
    required this.jsonConverter,
    this.getDirectoryPath = getApplicationDocumentsDirectory,
  }) {
    // Set the jsonConverter within the GeneticEvolution class so that we can
    // properly convert to and from Json on Type <T>.
    GeneticEvolution.jsonConverter = jsonConverter;
  }

  /// Used to convert objects of Type <T> to and from Json.
  final JsonConverter jsonConverter;

  /// Represents the directory path to find the parsed documents.
  final Future<Directory> Function() getDirectoryPath;

  /// Returns a formatted filename based on the input [wave].
  static String generationFileName(int wave) => 'generation wave $wave.txt';

  /// Writes the input [generation] to a text file.
  Future<void> writeGenerationToFile({
    required Generation<T> generation,
  }) async {
    final directoryPath = (await getDirectoryPath()).path;
    final filename = generationFileName(generation.wave);

    final myFile = File('$directoryPath/$filename');
    await myFile.writeAsString(
      jsonEncode(
        generation.toJson(),
      ),
    );
  }

  /// Returns a [Generation] object read in from a text file corresponding with
  /// the input [wave].
  Future<Generation<T>> readGenerationFromFile({
    required int wave,
  }) async {
    final directoryPath = (await getDirectoryPath()).path;
    final filename = generationFileName(wave);

    final myFile = File('$directoryPath/$filename');
    final jsonString = await myFile.readAsString();

    return Generation.fromJson(jsonDecode(jsonString));
  }
}
