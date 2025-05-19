import 'package:flutter/material.dart';

class AwakeTimeAllocationDetailsPage extends StatelessWidget {
  const AwakeTimeAllocationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awake Time Allocation Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Awake Time Allocation Details Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
