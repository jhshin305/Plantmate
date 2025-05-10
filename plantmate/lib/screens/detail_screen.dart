import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plantName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('$plantName 상세 정보')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plantName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            // 센서 데이터 차트 자리
            Container(
              height: 150,
              color: Colors.green[50],
              child: const Center(child: Text('차트/그래프 영역')),
            ),
            const SizedBox(height: 16),
            // 토글 예시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // const를 제거합니다.
              children: [
                const Text('자동 급수'),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('조명 제어'),
                Switch(value: false, onChanged: (_) {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
