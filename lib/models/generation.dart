part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents a [population] of entities created within the same [wave].
class Generation<T> extends Equatable {
  const Generation({
    required this.wave,
    required this.population,
  });

  /// Represents this Generation's number.
  ///
  /// This is intended to increment by 1 after each population continues to
  /// reproduce.
  final int wave;

  /// Represents the Popoulation of Entities within this Generation.
  final Population<T> population;

  @override
  List<Object?> get props => [
        wave,
        population,
      ];

  /// Converts the input [json] into a [Generation] object.
  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation<T>(
      wave: (json['wave'] as num).toInt(),
      population: Population<T>.fromJson(
        json['population'],
      ),
    );
  }

  /// Converts the [Generation] object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'wave': wave,
      'population': population.toJson(),
    };
  }
}

/// Additionally functionality that can be run on a [Generation].
extension GenerationExtension on Generation {
  /// Returns a formatted filename based on the input [wave].
  String filename(int wave) => 'generation wave $wave.txt';

  /// Writes this [Generation] to a text file.
  Future<void> writeToFile() async {
    final directoryPath = (await getApplicationDocumentsDirectory()).path;
    final filename = this.filename(wave);

    final myFile = File('$directoryPath/$filename');
    await myFile.writeAsString(
      jsonEncode(
        toJson(),
      ),
    );
  }

  /// Returns a [Generation] object read in from a text file corresponding with
  /// the input [wave].
  Future<Generation> readFromFile({
    required int wave,
  }) async {
    final directoryPath = (await getApplicationDocumentsDirectory()).path;
    final filename = this.filename(wave);

    final myFile = File('$directoryPath/$filename');
    final jsonString = await myFile.readAsString();

    return Generation.fromJson(jsonDecode(jsonString));
  }
}
