import 'package:flutter/material.dart';

class EnergyDetailsPage extends StatelessWidget {
  const EnergyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Energy Details Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
