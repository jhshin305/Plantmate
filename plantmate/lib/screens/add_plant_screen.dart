import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({Key? key}) : super(key: key);

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final Map<String, Map<String, dynamic>> _varietyDefaults = {
    '상추': {
      'tempMin': 15,
      'tempMax': 22,
      'brightMin': 5000,
      'brightMax': 10000,
      'humMin': 60,
      'humMax': 80,
      'waterCycleDays': 3,
    },
    '딸기': {
      'tempMin': 18,
      'tempMax': 26,
      'brightMin': 8000,
      'brightMax': 15000,
      'humMin': 65,
      'humMax': 85,
      'waterCycleDays': 2,
    },
    '토마토': {
      'tempMin': 20,
      'tempMax': 30,
      'brightMin': 10000,
      'brightMax': 20000,
      'humMin': 55,
      'humMax': 75,
      'waterCycleDays': 2,
    },
  };

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _variety = '';
  bool _varietyError = false;
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
      firstDate: DateTime(2000),
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
    if (selected != null) {
      final defaults = _varietyDefaults[selected]!;
      setState(() {
        _variety = selected;
        _varietyError = false;
        // 센서 값 자동 설정
        _temp = (defaults['tempMin'] + defaults['tempMax']) / 2;
        _bright = (defaults['brightMin'] + defaults['brightMax']) / 2;
        _hum = (defaults['humMin'] + defaults['humMax']) / 2;
        _tank = 100;
        _tray = 0;
      });
    }
  }

  void _save() {
    if (_variety.isEmpty) {
      setState(() => _varietyError = true);
      return;
    }
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
    final defaults = _variety.isNotEmpty ? _varietyDefaults[_variety]! : null;
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
                      border: _varietyError
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
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
              const SizedBox(height: 8),
              if (_varietyError)
                Center(
                  child: Text(
                    '품종을 선택해주세요',
                    style: const TextStyle(color: Colors.red),
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
              
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // 이름 입력
                      TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '이름',
                          border: InputBorder.none,
                        ),
                        validator: (val) => val == null || val.isEmpty ? '필수 입력' : null,
                        onSaved: (val) => _name = val!,
                      ),
                      const SizedBox(height: 8),

                      // 날짜 선택
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

              // 권장 범위 표시
              if (defaults != null) ...[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '권장 환경 정보',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('온도: ${defaults['tempMin']}~${defaults['tempMax']}℃'),
                        Text('조명 밝기: ${defaults['brightMin']}~${defaults['brightMax']} lx'),
                        Text('습도: ${defaults['humMin']}~${defaults['humMax']}%'),
                        Text('급수 주기: ${defaults['waterCycleDays']}일마다'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // // 센서 초기값 입력
              // _buildNumberField(
              //   label: '온도 (℃)',
              //   initialValue: _temp.toString(),
              //   onSaved: (val) => _temp = double.parse(val!),
              // ),
              // _buildNumberField(
              //   label: '조명 밝기 (lx)',
              //   initialValue: _bright.toString(),
              //   onSaved: (val) => _bright = double.parse(val!),
              // ),
              // _buildNumberField(
              //   label: '습도 (%)',
              //   initialValue: _hum.toString(),
              //   onSaved: (val) => _hum = double.parse(val!),
              // ),
              // _buildNumberField(
              //   label: '수통 잔량 (%)',
              //   initialValue: _tank.toString(),
              //   onSaved: (val) => _tank = double.parse(val!),
              // ),
              // _buildNumberField(
              //   label: '물받이 높이 (cm)',
              //   initialValue: _tray.toString(),
              //   onSaved: (val) => _tray = double.parse(val!),
              // ),
              // const SizedBox(height: 16),

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
}
