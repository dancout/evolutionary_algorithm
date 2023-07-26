import 'package:flutter/material.dart';
import 'package:genetic_evolution/genetic_evolution.dart';
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

    final sortedEntities = generation.population.sortedEntities.reversed;

    final List<String> words = [];

    for (var entity in sortedEntities) {
      String word = '';
      for (var gene in entity.dna.genes) {
        var value = gene.value;

        word += value;
      }

      word += ' - score: ${entity.fitnessScore}';

      words.add(word);
    }

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Center(
              child: Text(
                'Wave: ${generation.wave.toString()}',
              ),
            ),
            ...words.map((e) => Center(child: Text(e))).toList(),
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
}
