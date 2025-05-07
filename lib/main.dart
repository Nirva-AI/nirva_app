import 'package:flutter/material.dart';
import 'package:nirva_app/main_app.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/chat_manager.dart';

void main() {
  // Initialize the DataManager
  DataManager().initialize();
  // Initialize the ChatManager
  ChatManager().initialize();
  // Run the app
  runApp(const MainApp());
}
