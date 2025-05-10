import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({Key? key}) : super(key: key);

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _variety = '상추';
  DateTime _date = DateTime.now();
  double _temp = 20;
  double _bright = 300;
  double _hum = 50;
  double _tank = 0;
  double _tray = 0;

  final List<String> _varietyOptions = ['상추', '딸기', '토마토'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
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
              // 이름 입력
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                validator: (val) => val == null || val.isEmpty ? '필수 입력' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 16),

              // 품종 선택 다이얼로그
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '품종',
                ),
                controller: TextEditingController(text: _variety),
                onTap: () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (ctx) => SimpleDialog(
                      title: const Text('품종 선택'),
                      children: _varietyOptions
                          .map((v) => SimpleDialogOption(
                                onPressed: () => Navigator.pop(ctx, v),
                                child: Text(v),
                              ))
                          .toList(),
                    ),
                  );
                  if (selected != null) {
                    setState(() => _variety = selected);
                  }
                },
                validator: (_) => _variety.isEmpty ? '필수 입력' : null,
                onSaved: (_) {},
              ),
              const Divider(height: 32),

              // 날짜 선택
              Row(
                children: [
                  Text('심은 날짜: ${_date.toLocal().toString().split(' ')[0]}'),
                  const Spacer(),
                  TextButton(onPressed: _pickDate, child: const Text('선택')),
                ],
              ),
              const SizedBox(height: 16),

              // 센서 초기값 입력
              _buildNumberField(
                label: '온도 (℃)',
                initialValue: _temp.toString(),
                onSaved: (val) => _temp = double.parse(val!),
              ),
              _buildNumberField(
                label: '조명 밝기 (lx)',
                initialValue: _bright.toString(),
                onSaved: (val) => _bright = double.parse(val!),
              ),
              _buildNumberField(
                label: '습도 (%)',
                initialValue: _hum.toString(),
                onSaved: (val) => _hum = double.parse(val!),
              ),
              _buildNumberField(
                label: '수통 잔량 (%)',
                initialValue: _tank.toString(),
                onSaved: (val) => _tank = double.parse(val!),
              ),
              _buildNumberField(
                label: '물받이 높이 (cm)',
                initialValue: _tray.toString(),
                onSaved: (val) => _tray = double.parse(val!),
              ),
              const SizedBox(height: 16),

              // 저장 버튼
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
        validator: (val) => val == null || val.isEmpty ? '필수 입력' : null,
        onSaved: onSaved,
      ),
    );
  }
}