import 'package:flutter/material.dart';
import 'package:tourism/feature/main_page/main_page.dart';

void main() {

  runApp(const TourismApp());
}

class TourismApp extends StatelessWidget {
  const TourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeNomad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const TouristApp(),
    );
    
  }

}
