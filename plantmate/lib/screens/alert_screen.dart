import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/db_helper.dart';
import '../models/plant.dart';
import '../models/variety_defaults.dart';
import 'add_plant_screen.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final DBHelper _db = DBHelper();
  List<Plant> _plants = [];
  List<VarietyDefault> _varieties = [];
  String _variety = '';
  bool _varietyEmpty = false;
  String _name = '';
  DateTime _date = DateTime.now();
  double _tank = 0;
  double _tray = 0;

  // loaded defaults for selected variety
  VarietyDefault? _defaults;

  @override
  void initState() {
    super.initState();
    _db.fetchAllPlants().then((plants) {
      setState(() {
        _plants = plants;
      });
    });
    _db.fetchAllVarietyDefaults().then((varieties) {
      setState(() {
        _varieties = varieties;
      });
    });
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const ListTile(
            title: Text('물 부족'),
            subtitle: Text('2025-01-01 12:00:00'),
            leading: Icon(Icons.format_color_reset_outlined),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: null,
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('물 알림'),
            subtitle: Text('2025-01-01 11:00:00'),
            leading: Icon(Icons.format_color_reset_outlined),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: null,
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('물받이 가득 참'),
            subtitle: Text('2025-01-01 10:00:00'),
            leading: Icon(Icons.water_drop),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: null,
            ),
          ),
        ],
      )
    );
  }
}