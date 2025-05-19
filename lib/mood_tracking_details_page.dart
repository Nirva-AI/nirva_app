import 'package:flutter/material.dart';

class MoodTrackingDetailsPage extends StatelessWidget {
  const MoodTrackingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Mood Tracking Details Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
