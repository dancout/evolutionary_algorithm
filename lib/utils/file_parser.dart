part of 'package:genetic_evolution/genetic_evolution.dart';

/// Parses [Generation] objects of type [T] to and from text files.
class FileParser<T> {
  FileParser({
    required this.geneJsonConverter,
    GenerationJsonConverter<T>? generationJsonConverter,
    this.getDirectoryPath = getApplicationDocumentsDirectory,
  }) {
    // Set the generationJsonConverter to the default value if one was not
    // passed in.
    this.generationJsonConverter =
        generationJsonConverter ?? GenerationJsonConverter<T>();

    // Set the jsonConverter within the GeneticEvolution class so that we can
    // properly convert to and from Json on Type <T>.
    GeneticEvolution.geneJsonConverter = geneJsonConverter;
  }

  /// Used to convert [Gene] objects of Type [T] to and from Json.
  // TODO: Check on this Typed line below!
  // final JsonConverter<T, JSON> geneJsonConverter;
  final JsonConverter geneJsonConverter;

  /// Used to convert a [Generation] of Type [T] to and from Json.
  late final GenerationJsonConverter<T> generationJsonConverter;

  /// Represents the directory path to find the parsed documents.
  final Future<Directory> Function() getDirectoryPath;

  /// Returns a formatted filename based on the input [wave].
  String generationFileName(int wave) => 'generation wave $wave.txt';

  /// Writes the input [generation] to a text file.
  Future<void> writeGenerationToFile({
    required Generation<T> generation,
  }) async {
    final directoryPath = (await getDirectoryPath()).path;
    final filename = generationFileName(generation.wave);
    final myFile = File('$directoryPath/$filename');
    await myFile.writeAsString(
      jsonEncode(generationJsonConverter.toJson(generation)),
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

    return generationJsonConverter.fromJson(jsonDecode(jsonString));
  }
}
