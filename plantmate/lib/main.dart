import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/add_plant_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const PlantMateApp());

class PlantMateApp extends StatelessWidget {
  const PlantMateApp({super.key});
  @override
  Widget build(BuildContext c) {
    return MaterialApp(
      title: 'PlantMate',
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/add': (_) => const AddPlantScreen(),
        '/detail': (_) => const DetailScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
