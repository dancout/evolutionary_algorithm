import 'package:color_contrast_example/color_contrast_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Color Contrast Demo',
      home: ColorContrastHomePage(
        autoPlay: true,
      ),
    );
  }
}
