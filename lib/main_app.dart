import 'package:flutter/material.dart';
import 'package:nirva_app/home_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Running on: ${Theme.of(context).platform}');
    final screenSize = MediaQuery.of(context).size;
    debugPrint('Screen size: ${screenSize.width} x ${screenSize.height}');

    return MaterialApp(
      title: 'Nirva App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Nirva App Home Page'),
    );
  }
}
