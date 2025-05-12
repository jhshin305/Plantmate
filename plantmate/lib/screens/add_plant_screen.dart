import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/variety_defaults.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({Key? key}) : super(key: key);

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final DBHelper _db = DBHelper();
  final _formKey = GlobalKey<FormState>();

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
    _db.fetchAllVarietyDefaults().then((varieties) {
      setState(() {
        _varieties = varieties;
      });
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickVariety() async {
    final selected = await showModalBottomSheet<VarietyDefault>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.5;
        return Container(
          height: height,
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: _varieties.map((v) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, v),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(v.assetPath!, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(v.variety),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected != null) {
      final def = await _db.fetchVarietyDefaults(selected.variety);
      setState(() {
        _variety = selected.variety;
        _defaults = def;
        _varietyEmpty = false;
      });
    }
  }

  void _save() {
    if (_variety.isEmpty) {
      setState(() => _varietyEmpty = true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    // apply defaults if needed
    if (_defaults != null) {
      _tank = 100;
      _tray = 0;
    }
    Navigator.pop(context, {
      'name': _name,
      'variety': _variety,
      'date': _date.toIso8601String(),
      'temp': (_defaults!.tempMin + _defaults!.tempMax) / 2,
      'bright': (_defaults!.brightMin + _defaults!.brightMax) / 2,
      'hum': (_defaults!.humMin + _defaults!.humMax) / 2,
      'tank': _tank,
      'tray': _tray,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 식물 심기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickVariety,
                child: Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: _varietyEmpty
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        _defaults?.assetPath ?? 'assets/icons/pot.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              if (_varietyEmpty) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text('품종을 선택해주세요', style: TextStyle(color: Colors.red)),
                ),
              ],
              const SizedBox(height: 16),
              if (_variety.isNotEmpty) ...[
                Center(child: Text(_variety, style: Theme.of(context).textTheme.bodyMedium)),
                const SizedBox(height: 16),
              ],
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextFormField(
                        // focusNode: _nameFocus,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(hintText: '이름', border: InputBorder.none),
                        validator: (val) => val == null || val.isEmpty ? '필수 입력' : null,
                        onSaved: (val) => _name = val!,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('심은 날짜: '),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Text(
                                _date.toLocal().toString().split(' ')[0],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_defaults != null) ...[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('권장 환경 정보', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('온도: ${_defaults!.tempMin}~${_defaults!.tempMax}℃'),
                        // Text('조명 밝기: ${_defaults!.brightMin}~${_defaults!.brightMax} lx'),
                        Text('계절: 사계절'),
                        Text('습도: ${_defaults!.humMin}~${_defaults!.humMax}%'),
                        Text('급수 주기: ${_defaults!.waterCycleDays}일마다'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)), child: const Text('저장')),
            ],
          ),
        ),
      ),
    );
  }
}
