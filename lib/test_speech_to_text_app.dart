import 'package:flutter/material.dart';
import 'package:nirva_app/speech_to_text_test_page.dart';

class TestSpeechToTextApp extends StatelessWidget {
  const TestSpeechToTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text Test App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SpeechToTextTestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
