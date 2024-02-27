# genetic_evolution
 A package that simulates a Genetic Evolutionary Algorithm among its generations.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Examples](#examples)
    - [Simple Word Example](#simple-word-example)
    - [Intermediate Color Contrast Example](#intermediate-color-contrast-example)
- [File Parsing](#file-parsing)

## Basic Usage

First, you must define your own `GeneService`, describing the Genes within a DNA strand. Notice that we are defining a Gene to be of type `<String>`.
```dart
class MyGeneService extends GeneService<String> {
...
}
```


Then, you must define your own `FitnessService`, describing how well an Entity's DNA performs.

```dart
class MyFitnessService extends FitnessService<String> {
    ...
}
```

Next, you can initialize a `GeneticEvolution` object.

```dart
GeneticEvolution geneticEvolution = GeneticEvolution(
      geneticEvolutionConfig: GeneticEvolutionConfig(
        numGenes: 10,
        mutationRate: 0.25
      ),
      fitnessService: MyFitnessService(),
      geneService: MyGeneService(),
    );
```

And finally, you can get the next generation using `nextGeneration()`.
```dart
Generation generation = await geneticEvolution.nextGeneration();
```


## Examples

### Simple Word Example
The code for this Word example can be found in the `/example/word_example` folder ([here](https://github.com/dancout/genetic_evolution/tree/publishing-setup/example/word_example)).

<img src="https://github.com/dancout/genetic_evolution/assets/5490028/c450e7d6-7012-4a31-9dbe-65920ec8c1a2" width="400">

### Intermediate Color Contrast Example
The code for this Color Contrast example can be found in the `/example/color_contrast_example` folder ([here](https://github.com/dancout/genetic_evolution/tree/publishing-setup/example/color_contrast_example)).

![color_contrast_genetic_evolution_video](https://github.com/dancout/genetic_evolution/assets/5490028/5268cf33-aeaa-4dbe-b506-eecf1af3108e)


## File Parsing
You can write specific generations to a file, and similarly read in specific generations stored on a file.

First, define your own `JsonConverter`. (This class describes how to convert objects of Type `<T>` to and from JSON)

```dart
// Type <T> is Type <String> in this example
class GeneJsonConverter extends JsonConverter<String, Map<String, dynamic>> {
  @override
  fromJson(Map<String, dynamic> json) {
    return json['text'];
  }

  @override
  toJson(String object) {
    return {'text': object};
  }
}
```

Next, define your `FileParser` object based on your above `JsonConverter`.
```dart
final fileParser = FileParser<String>(
  geneJsonConverter: GeneJsonConverter(),
);
```

Include this `fileParser` within the `GeneticEvolution` constructor.
```dart
final geneticEvolution = GeneticEvolution(
  fileParser: fileParser,
  ... // other params go here
)
```


Now, you can write the current `Generation` to a file.
```dart
geneticEvolution.writeGenerationToFile();
```

Lastly, you can load in a specific `Generation` read from a file.
```dart
geneticEvolution.loadGenerationFromFile(wave: 10);
```