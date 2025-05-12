import 'package:flutter/material.dart';
import 'package:nirva_app/service_manager.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Profile Screen = ${ServiceManager().apiEndPointsJson()}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
