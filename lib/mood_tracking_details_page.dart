import 'package:flutter/material.dart';

class MoodTrackingDetailsPage extends StatefulWidget {
  const MoodTrackingDetailsPage({super.key});

  @override
  State<MoodTrackingDetailsPage> createState() =>
      _MoodTrackingDetailsPageState();
}

class _MoodTrackingDetailsPageState extends State<MoodTrackingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
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
