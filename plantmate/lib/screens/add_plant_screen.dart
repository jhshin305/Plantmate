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

  late FocusNode _nameFocus;

  final Map<String, String> _varietyAssets = {
    '상추': 'assets/icons/lettuce.png',
    '딸기': 'assets/icons/strawberry.png',
    '토마토': 'assets/icons/tomato.png',
  };
  List<String> get _varietyOptions => _varietyAssets.keys.toList();

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _nameFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickVariety() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16),
          children: _varietyOptions.map((v) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, v),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        _varietyAssets[v]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(v),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
    if (selected != null) setState(() => _variety = selected);
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
      appBar: AppBar(title: const Text('새 식물 심기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 상단 이미지 선택
              GestureDetector(
                onTap: _pickVariety,
                child: Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        _varietyAssets[_variety] ?? 'assets/icons/pot.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 선택된 품종명 표시
              if (_variety.isNotEmpty)
                Center(
                  child: Text(
                    _variety,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (_variety.isNotEmpty) const SizedBox(height: 16),

              // 이름 입력 (중앙 정렬, 힌트 초기, 힌트 사라짐 on focus)
              TextFormField(
                focusNode: _nameFocus,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: _nameFocus.hasFocus ? '' : '이름',
                  border: InputBorder.none,
                ),
                validator: (val) => val == null || val.isEmpty ? '필수 입력' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 16),

              // 날짜 선택 (날짜 텍스트 터치 시 날짜 선택 창 열기)
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
