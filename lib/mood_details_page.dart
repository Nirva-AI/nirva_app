import 'package:flutter/material.dart';

class MoodDetailsPage extends StatelessWidget {
  const MoodDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Mood Details Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
