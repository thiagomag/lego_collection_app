import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(LegoCollectionApp());
}

class LegoCollectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEGO Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}