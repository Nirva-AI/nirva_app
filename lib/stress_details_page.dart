import 'package:flutter/material.dart';

class StressDetailsPage extends StatelessWidget {
  const StressDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Stress Details Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
