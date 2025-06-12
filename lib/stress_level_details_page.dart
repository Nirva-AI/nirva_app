import 'package:flutter/material.dart';

class StressLevelDetailsPage extends StatefulWidget {
  const StressLevelDetailsPage({super.key});

  @override
  State<StressLevelDetailsPage> createState() => _StressLevelDetailsPageState();
}

class _StressLevelDetailsPageState extends State<StressLevelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
