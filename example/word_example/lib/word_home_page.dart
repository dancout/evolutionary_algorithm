import 'package:flutter/material.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:word_example/word_fitness_service.dart';
import 'package:word_example/word_gene_service.dart';

// Declaring the target word globally
const target = 'HELLO WORLD';

class WordHomePage extends StatefulWidget {
  const WordHomePage({
    super.key,
    this.autoPlay = true,
  });

  final bool autoPlay;

  @override
  State<WordHomePage> createState() => _WordHomePageState();
}

class _WordHomePageState extends State<WordHomePage> {
  late GeneticEvolution<String> geneticEvolution;
  late Generation<String> generation;
  bool isPlaying = false;
  int? waveTargetFound;

  @override
  void initState() {
    final numGenes = target.characters.length;
    const populationSize = 30;
    const mutationRate = 0.05; // 5%
    final wordFitnessService = WordFitnessService();
    final wordGeneService = WordGeneService(mutationRate: mutationRate);

    geneticEvolution = GeneticEvolution(
      populationSize: populationSize,
      numGenes: numGenes,
      fitnessService: wordFitnessService,
      geneService: wordGeneService,
    );

    // Initialize the first generation
    generation = geneticEvolution.nextGeneration();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (isPlaying) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          // Move on to the next generation
          generation = geneticEvolution.nextGeneration();
        });
      }
    });

    // Check if target has been found.
    if (waveTargetFound == null &&
        convertWord(generation.population.topScoringEntity) == target) {
      waveTargetFound = generation.wave;
    }

    // Convert all entities into words
    final List<Widget> wordRows = [
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('value'),
          SizedBox(width: 72),
          Text('score'),
        ],
      ),
    ];
    final sortedEntities = generation.population.entities;
    for (var entity in sortedEntities) {
      String word = convertWord(entity);

      wordRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(word),
            const SizedBox(width: 24),
            Text(entity.fitnessScore.toString()),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Target: $target',
            ),
            Text(
              'Wave: ${generation.wave.toString()}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Top Value'),
                    Text(
                      convertWord(generation.population.topScoringEntity),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    const Text('Top Score'),
                    Text(
                      generation.population.topScoringEntity.fitnessScore
                          .toString(),
                    ),
                  ],
                ),
              ],
            ),
            if (waveTargetFound != null)
              Text('Target reached at wave: $waveTargetFound'),
            const SizedBox(height: 24),
            const Text('Entities'),
            Flexible(
              child: ListView(
                children: wordRows,
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

  String convertWord(Entity<String> entity) {
    String word = '';
    for (var gene in entity.dna.genes) {
      var value = gene.value;

      word += value;
    }

    return word;
  }
}
