import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _resetDatabase(BuildContext context) async {
    // 1. 데이터베이스 파일 경로 구하기
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plantmate.db');

    // 2. 파일 삭제 (DB 삭제)
    await deleteDatabase(path);

    // 3. 사용자에게 알림
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터베이스가 초기화되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _resetDatabase(context),
          child: const Text('DB 초기화'),
        ),
      ),
    );
  }
}
