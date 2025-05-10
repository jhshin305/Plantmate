import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _planted = DateTime.now();

  Future<void> _pickDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: _planted,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (dt != null) setState(() => _planted = dt);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    // TODO: DB 저장 & 서버 동기화 로직
    Navigator.pop(context, _name); // _name을 실제로 사용합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 식물 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '식물이름'),
                validator: (v) => v == null || v.isEmpty ? '이름을 입력해주세요' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('심은 날짜: ${_planted.toLocal().toString().split(' ')[0]}'),
                  const Spacer(),
                  TextButton(onPressed: _pickDate, child: const Text('선택')),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: const Text('저장'), // child를 맨 뒤로 옮겼습니다.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
