import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DApp());
}

class DApp extends StatelessWidget {
  const DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marine Invertebrate Classifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}