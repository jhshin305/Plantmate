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
  bool _editingName = false;
  late TextEditingController _nameController;

  final Map<String, String> _varietyAssets = {
    '상추': 'assets/icons/lettuce.png',
    '딸기': 'assets/icons/strawberry.png',
    '토마토': 'assets/icons/tomato.png',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadPlant();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadPlant() async {
    final plants = await _db.fetchAllPlants();
    if (plants.isNotEmpty) {
      setState(() {
        _plant = plants.first;
        _nameController.text = _plant!.name;
      });
    } else {
      setState(() {
        _plant = null;
      });
    }
  }

  Future<void> _addOrEditPlant() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddPlantScreen()),
    );
    if (result != null) {
      final newPlant = Plant(
        id: _plant?.id,
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
        await _db.updatePlant(newPlant);
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

  Future<void> _saveNameEdit() async {
    if (_plant != null) {
      final updatedPlant = Plant(
        id: _plant!.id,
        name: _nameController.text.trim(),
        variety: _plant!.variety,
        plantedDate: _plant!.plantedDate,
        temperature: _plant!.temperature,
        brightness: _plant!.brightness,
        humidity: _plant!.humidity,
        tankLevel: _plant!.tankLevel,
        trayHeight: _plant!.trayHeight,
      );
      await _db.updatePlant(updatedPlant);
      setState(() {
        _editingName = false;
      });
      _loadPlant();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌿 PlantMate'),
        actions: _plant != null
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _addOrEditPlant,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _removePlant,
                ),
              ]
            : null,
      ),
      body: _plant == null
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('새 식물 추가'),
                onPressed: _addOrEditPlant,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Plant Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // 상단 이미지
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                              _varietyAssets[_plant!.variety] ?? 'assets/icons/pot.png',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _plant!.variety,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          // 이름
                          _editingName
                              ? TextField(
                                  controller: _nameController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (_) => _saveNameEdit(),
                                  autofocus: true,
                                )
                              : GestureDetector(
                                  onTap: () => setState(() => _editingName = true),
                                  child: Text(
                                    _plant!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                          const SizedBox(height: 8),
                          Text(
                            '심은 날짜: ${_plant!.plantedDate.toLocal().toString().split(' ')[0]}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sensor Data Grid
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildMetric(
                              icon: Icons.thermostat,
                              label: '온도',
                              value: '${_plant!.temperature}℃'),
                          _buildMetric(
                              icon: Icons.wb_sunny,
                              label: '조명',
                              value: '${_plant!.brightness} lx'),
                          _buildMetric(
                              icon: Icons.water_drop,
                              label: '습도',
                              value: '${_plant!.humidity}%'),
                          _buildMetric(
                              icon: Icons.invert_colors,
                              label: '수통',
                              value: '${_plant!.tankLevel}%'),
                          _buildMetric(
                              icon: Icons.height,
                              label: '물받이',
                              value: '${_plant!.trayHeight} cm'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _plant != null
          ? null
          : FloatingActionButton(
              onPressed: _addOrEditPlant,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.green[700]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}