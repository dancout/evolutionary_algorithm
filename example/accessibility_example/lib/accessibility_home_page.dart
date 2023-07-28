import 'package:accessibility_example/accessibility_fitness_service.dart';
import 'package:accessibility_example/accessibility_gene_service.dart';
import 'package:flutter/material.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:genetic_evolution/models/dna.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/gene.dart';
import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/population.dart';

class AccessibilityHomePage extends StatefulWidget {
  const AccessibilityHomePage({
    super.key,
    this.autoPlay = true,
  });

  final bool autoPlay;

  @override
  State<AccessibilityHomePage> createState() => _AccessibilityHomePageState();
}

class _AccessibilityHomePageState extends State<AccessibilityHomePage> {
  late GeneticEvolution<int> geneticEvolution;
  late Generation<int> generation;
  bool isPlaying = false;
  int? targetWaveFound;
  late double targetScore;
  double allTimeTopScore = 0.0;
  static const populationSize = 100;
  static const numParents = 3;

  List<Widget> colorBlocksValues = [];
  List<Widget> colorBlocksScores = [];

  @override
  void initState() {
    const numGenes = 6;
    const mutationRate = 0.15;

    final accessibilityFitnessService = AccessibilityFitnessService();
    final accessibilityGeneService =
        AccessibilityGeneService(mutationRate: mutationRate);

    targetScore = accessibilityFitnessService.calculateScore(
        dna: DNA(genes: [
      Gene(value: Colors.black.red),
      Gene(value: Colors.black.green),
      Gene(value: Colors.black.blue),
      Gene(value: Colors.white.red),
      Gene(value: Colors.white.green),
      Gene(value: Colors.white.blue),
    ]));

    geneticEvolution = GeneticEvolution(
      numParents: numParents,
      populationSize: populationSize,
      numGenes: numGenes,
      fitnessService: accessibilityFitnessService,
      geneService: accessibilityGeneService,
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

    var topFitnessScore = generation.population.topScoringEntity.fitnessScore;
    if (targetWaveFound == null && topFitnessScore == targetScore) {
      targetWaveFound = generation.wave;
    }

    if (topFitnessScore > allTimeTopScore) {
      allTimeTopScore = topFitnessScore;
    }

    // Convert all entities into visual elements
    final entities = generation.population.entities;

    colorBlocksValues = [];
    colorBlocksScores = [];

    for (var entity in entities) {
      colorBlocksValues.add(convertColorToBlockValue(entity));
      colorBlocksScores.add(convertColorToBlockScore(entity));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Wave: ${generation.wave.toString()}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Wave Top Value'),
                    convertColorToBlockValue(
                        generation.population.topScoringEntity)
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    const Text('Wave Top Score'),
                    Text(
                      generation.population.topScoringEntity.fitnessScore
                          .toString(),
                    ),
                  ],
                ),
              ],
            ),
            if (targetWaveFound != null)
              Text('Top score found in wave: $targetWaveFound'),
            if (targetWaveFound == null)
              Text('Top score found so far: $allTimeTopScore'),
            const SizedBox(height: 24),
            const Text('Entities'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('value'),
                SizedBox(width: 72),
                Text('score'),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: colorBlocksValues,
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: colorBlocksScores,
                    ),
                  ],
                ),
              ]),
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
    return Text(entity.fitnessScore.toString());
  }
}
