import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({Key? key}) : super(key: key);

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _variety = '';
  DateTime _date = DateTime.now();
  double _temp = 20;
  double _bright = 300;
  double _hum = 50;
  double _tank = 0;
  double _tray = 0;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Navigator.pop<Map<String, dynamic>>(context, {
      'name': _name,
      'variety': _variety,
      'date': _date.toIso8601String(),
      'temp': _temp,
      'bright': _bright,
      'hum': _hum,
      'tank': _tank,
      'tray': _tray,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 식물 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) =>
                    value == null || value.isEmpty ? '필수 입력' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '품종'),
                validator: (value) =>
                    value == null || value.isEmpty ? '필수 입력' : null,
                onSaved: (value) => _variety = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('심은 날짜: ${_date.toLocal().toString().split(' ')[0]}'),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('선택'),
                  ),
                ],
              ),
              const Divider(),
              _buildNumberField(
                label: '온도 (℃)',
                initialValue: _temp.toString(),
                onSaved: (value) => _temp = double.parse(value ?? '0'),
              ),
              _buildNumberField(
                label: '조명 밝기 (lx)',
                initialValue: _bright.toString(),
                onSaved: (value) => _bright = double.parse(value ?? '0'),
              ),
              _buildNumberField(
                label: '습도 (%)',
                initialValue: _hum.toString(),
                onSaved: (value) => _hum = double.parse(value ?? '0'),
              ),
              _buildNumberField(
                label: '수통 잔량 (%)',
                initialValue: _tank.toString(),
                onSaved: (value) => _tank = double.parse(value ?? '0'),
              ),
              _buildNumberField(
                label: '물받이 높이 (cm)',
                initialValue: _tray.toString(),
                onSaved: (value) => _tray = double.parse(value ?? '0'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String?> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        validator: (value) =>
            value == null || value.isEmpty ? '필수 입력' : null,
        onSaved: onSaved,
      ),
    );
  }
}