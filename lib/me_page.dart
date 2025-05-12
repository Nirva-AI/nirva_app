import 'package:flutter/material.dart';
import 'package:nirva_app/service_manager.dart';
import 'dart:convert';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  late Future<String> _apiEndpointsFuture;

  @override
  void initState() {
    super.initState();
    _apiEndpointsFuture = _fetchApiEndpoints();
  }

  Future<String> _fetchApiEndpoints() async {
    await ServiceManager().postAPIEndPointConfiguration();
    return jsonEncode(ServiceManager().api_endpoints.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile Screen')),
      body: FutureBuilder<String>(
        future: _apiEndpointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(
              child: Text(
                snapshot.data ?? 'No data available',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
