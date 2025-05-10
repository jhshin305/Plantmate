import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/add_plant_screen.dart';

void main() => runApp(const PlantMateApp());

class PlantMateApp extends StatelessWidget {
  const PlantMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/detail': (_) => const DetailScreen(),
        '/add': (_) => const AddPlantScreen(),
      },
    );
  }
}
