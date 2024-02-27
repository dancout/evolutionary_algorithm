part of 'package:genetic_evolution/genetic_evolution.dart';

/// Converts [Generation] objects of Type [T] to and from JSON.
class GenerationJsonConverter<T>
    extends JsonConverter<Generation<T>, Map<String, dynamic>> {
  @override
  Generation<T> fromJson(Map<String, dynamic> json) {
    return Generation.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Generation<T> object) {
    return object.toJson();
  }
}
