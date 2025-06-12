import 'package:flutter/material.dart';

class EnergyLevelDetailsPage extends StatefulWidget {
  const EnergyLevelDetailsPage({super.key});

  @override
  State<EnergyLevelDetailsPage> createState() => _EnergyLevelDetailsPageState();
}

class _EnergyLevelDetailsPageState extends State<EnergyLevelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Level'),
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
