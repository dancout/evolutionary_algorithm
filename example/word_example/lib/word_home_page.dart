import 'package:flutter/material.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/generation.dart';
import 'package:genetic_evolution/models/genetic_evolution_config.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:word_example/word_fitness_service.dart';
import 'package:word_example/word_gene_service.dart';

// Declaring the target word globally
const target = 'HELLO WORLD';

/// An example of Genetic Evolution through text.
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
  Generation<String>? generation;
  bool isPlaying = false;
  int? waveTargetFound;

  @override
  void initState() {
    final numGenes = target.characters.length;
    const populationSize = 30;
    const mutationRate = 0.05; // 5%
    final wordFitnessService = WordFitnessService();
    final wordGeneService = WordGeneService();

    final GeneticEvolutionConfig geneticEvolutionConfig =
        GeneticEvolutionConfig(
      numGenes: numGenes,
      populationSize: populationSize,
      mutationRate: mutationRate,
    );

    geneticEvolution = GeneticEvolution(
      geneticEvolutionConfig: geneticEvolutionConfig,
      fitnessService: wordFitnessService,
      geneService: wordGeneService,
    );

    // Initialize the first generation
    geneticEvolution.nextGeneration().then((value) {
      setState(() {
        generation = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generation = this.generation;
    if (generation == null) {
      return const CircularProgressIndicator();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (isPlaying) {
        await Future.delayed(const Duration(milliseconds: 100));
        geneticEvolution.nextGeneration().then((value) {
          setState(() {
            this.generation = value;
          });
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
    final entities = generation.population.entities;
    for (var entity in entities) {
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
            geneticEvolution.nextGeneration().then((value) {
              setState(() {
                this.generation = value;
              });
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
