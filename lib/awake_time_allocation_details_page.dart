import 'package:flutter/material.dart';

class AwakeTimeAllocationDetailsPage extends StatefulWidget {
  const AwakeTimeAllocationDetailsPage({super.key});

  @override
  State<AwakeTimeAllocationDetailsPage> createState() =>
      _AwakeTimeAllocationDetailsPageState();
}

class _AwakeTimeAllocationDetailsPageState
    extends State<AwakeTimeAllocationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awake Time Allocation'),
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
