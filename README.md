# genetic_evolution
 A package that simulates an Evolutionary Algorithm among its generations.


## Installation

Add `genetic_evolution` as a dependency in your `pubspec.yaml` file.

Import Genetic Evolution:
```dart
import 'package:genetic_evolution/genetic_evolution.dart';
```

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


## Simple Word Example
The code for this Word example can be found in the `/example/word_example` folder.

<img src="https://github.com/dancout/genetic_evolution/assets/5490028/c450e7d6-7012-4a31-9dbe-65920ec8c1a2" width="400">

## Intermediate Color Contrast Example
The code for this Color Contrast example can be found in the `/example/color_contrast_example` folder.

![color_contrast_genetic_evolution_video](https://github.com/dancout/genetic_evolution/assets/5490028/5268cf33-aeaa-4dbe-b506-eecf1af3108e)