import 'package:flutter/material.dart';
import 'package:word_example/word_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hello World Demo',
      home: WordHomePage(),
    );
  }
}
