import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/db_helper.dart';
import 'add_plant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _db = DBHelper();
  Plant? _plant;

  @override
  void initState() {
    super.initState();
    _loadPlant();
  }

  Future<void> _loadPlant() async {
    final plants = await _db.fetchAllPlants();
    setState(() => _plant = plants.isNotEmpty ? plants.first : null);
  }

  Future<void> _addPlant() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddPlantScreen()),
    );
    if (result != null) {
      final newPlant = Plant(
        name: result['name'] as String,
        variety: result['variety'] as String,
        plantedDate: DateTime.parse(result['date'] as String),
        temperature: result['temp'] as double,
        brightness: result['bright'] as double,
        humidity: result['hum'] as double,
        tankLevel: result['tank'] as double,
        trayHeight: result['tray'] as double,
      );
      if (_plant == null) {
        await _db.insertPlant(newPlant);
      } else {
        final updated = newPlant..id = _plant!.id;
        await _db.updatePlant(updated);
      }
      _loadPlant();
    }
  }

  Future<void> _removePlant() async {
    if (_plant?.id != null) {
      await _db.deletePlant(_plant!.id!);
      setState(() => _plant = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌿 PlantMate'),
        actions: [
          if (_plant != null) 
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _removePlant,
            ),
        ],
      ),
      body: _plant == null
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('새 식물 심기'),
                onPressed: _addPlant,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _plant!.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('품종: ${_plant!.variety}'),
                  const SizedBox(height: 4),
                  Text('심은 날짜: ${_plant!.plantedDate.toLocal().toString().split(' ')[0]}'),
                  const SizedBox(height: 4),
                  Text('온도: ${_plant!.temperature}℃'),
                  const SizedBox(height: 2),
                  Text('조명 밝기: ${_plant!.brightness} lx'),
                  const SizedBox(height: 2),
                  Text('습도: ${_plant!.humidity}%'),
                  const SizedBox(height: 2),
                  Text('수통 잔량: ${_plant!.tankLevel}%'),
                  const SizedBox(height: 2),
                  Text('물받이 잔량: ${_plant!.trayHeight}%'),
                ],
              ),
            ),
      floatingActionButton: _plant == null
          ? FloatingActionButton(
              onPressed: _addPlant,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
