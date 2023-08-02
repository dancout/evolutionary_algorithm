import 'package:color_contrast_example/color_contrast_fitness_service.dart';
import 'package:color_contrast_example/color_contrast_service.dart';
import 'package:flutter/material.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/genetic_evolution_config.dart';
import 'package:genetic_evolution/models/population.dart';

/// An example of Genetic Evolution through Color Contrast.
class ColorContrastHomePage extends StatefulWidget {
  const ColorContrastHomePage({
    super.key,
    this.autoPlay = true,
  });

  final bool autoPlay;

  @override
  State<ColorContrastHomePage> createState() => _ColorContrastHomePageState();
}

class _ColorContrastHomePageState extends State<ColorContrastHomePage> {
  late GeneticEvolution<int> geneticEvolution;
  late Generation<int> generation;
  bool isPlaying = false;
  int? targetWaveFound;
  late double targetScore;
  double allTimeTopScore = 0.0;
  static const populationSize = 150;
  // 3 parents can contribute to the reproduced Entity
  static const numParents = 3;
  // A parent cannot be picked twice for the same child Entity
  static const canReproduceWithSelf = false;
  // Whether we should keep track of an entity's parents from the previous
  // generation.
  static const trackParents = true;
  // Whether we should keep track of which wave a particular gene was mutated.
  static const trackMutatedWaves = true;

  @override
  void initState() {
    const numGenes = 6;
    const mutationRate = 0.40;

    final colorContrastFitnessService = ColorContrastFitnessService();
    final colorContrastGeneService = ColorContrastGeneService(
      mutationRate: mutationRate,
      trackMutatedWaves: trackMutatedWaves,
    );

    targetScore = colorContrastFitnessService.calculateScore(
        dna: DNA(genes: [
      Gene(value: Colors.black.red),
      Gene(value: Colors.black.green),
      Gene(value: Colors.black.blue),
      Gene(value: Colors.white.red),
      Gene(value: Colors.white.green),
      Gene(value: Colors.white.blue),
    ]));

    const GeneticEvolutionConfig geneticEolutionConfig = GeneticEvolutionConfig(
      numGenes: numGenes,
      numParents: numParents,
      populationSize: populationSize,
      canReproduceWithSelf: canReproduceWithSelf,
      trackParents: trackParents,
    );

    geneticEvolution = GeneticEvolution(
      geneticEvolutionConfig: geneticEolutionConfig,
      fitnessService: colorContrastFitnessService,
      geneService: colorContrastGeneService,
    );

    // Initialize the first generation
    generation = geneticEvolution.nextGeneration();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (isPlaying) {
        setState(() {
          // Move on to the next generation
          generation = geneticEvolution.nextGeneration();
        });
      }
    });
    final topScoringEntity = generation.population.topScoringEntity;
    final topFitnessScore = topScoringEntity.fitnessScore;
    if (targetWaveFound == null && topFitnessScore == targetScore) {
      targetWaveFound = generation.wave;
    }

    if (topFitnessScore > allTimeTopScore) {
      allTimeTopScore = topFitnessScore;
    }

    // Convert all entities into visual elements
    final entities = generation.population.entities;

    final entitiesToDisplay = <Widget>[];

    for (var entity in entities) {
      entitiesToDisplay.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            convertColorToBlockValue(entity),
            const SizedBox(width: 8.0),
            convertColorToBlockScore(entity),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Target score: ${truncatedScore(targetScore)}'),
            Text(
              'Wave: ${generation.wave.toString()}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Wave Top Value'),
                    convertColorToBlockValue(topScoringEntity),
                    const SizedBox(height: 12),
                    const Text('Child Parents'),
                    ...?topScoringEntity.parents
                        ?.map((e) => convertColorToBlockValue(e))
                        .toList(),
                    const SizedBox(height: 12),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    const Text('Wave Top Score'),
                    Text(
                      truncatedScore(
                        generation.population.topScoringEntity.fitnessScore,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Child Parents\' Scores'),
                    ...?topScoringEntity.parents
                        ?.map((e) => Text(truncatedScore(e.fitnessScore)))
                        .toList(),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
            if (targetWaveFound != null)
              Text('Top score found in wave: $targetWaveFound'),
            if (targetWaveFound == null)
              Text(
                  'Top score found so far: ${truncatedScore(allTimeTopScore)}'),
            const SizedBox(height: 24),
            const Text('Entities'),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 24.0,
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: entitiesToDisplay,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.autoPlay) {
            setState(() {
              isPlaying = !isPlaying;
            });
          } else {
            setState(() {
              generation = geneticEvolution.nextGeneration();
            });
          }
        },
        child: (!widget.autoPlay || !isPlaying)
            ? const Icon(Icons.play_arrow)
            : const Icon(Icons.pause),
      ),
    );
  }

  String truncatedScore(fitnessScore) {
    return fitnessScore.toString().replaceRange(8, null, '');
  }

  Widget convertColorToBlockValue(Entity<int> entity) {
    const opacity = 1.0;
    final backgroundColor = Color.fromRGBO(
      entity.dna.genes[0].value,
      entity.dna.genes[1].value,
      entity.dna.genes[2].value,
      opacity,
    );

    final textColor = Color.fromRGBO(
      entity.dna.genes[3].value,
      entity.dna.genes[4].value,
      entity.dna.genes[5].value,
      opacity,
    );

    return Container(
      color: backgroundColor,
      child: Text(
        'Hello World',
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }

  Widget convertColorToBlockScore(Entity<int> entity) {
    return Text(truncatedScore(entity.fitnessScore));
  }
}
