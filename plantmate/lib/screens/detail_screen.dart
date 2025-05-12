import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    // final plantName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌿 PlantMate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.pushNamed(context, '/alerts'),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ]
      ),
      // appBar: AppBar(title: Text('$plantName 상세 정보')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(plantName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: lineChartWidget(),
            ),
            // 차트 자리
            // Container(
            //   height: 150,
            //   color: Colors.green[50],
            //   child: const Center(child: Text('차트/그래프 영역')),
            // ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('적정 온도'),
                        const Text('20°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('현재 온도'),
                        const Text('18.5°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('설정 온도'),
                        const Text('20°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ]
                ),
              )
            )
          ],
        ),
      ),
    );
  }
  Widget addPaddingToChart(Widget chart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: chart,
    );
  }
  Widget lineChartWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: CustomPaint(
        size: Size(double.infinity, 200),
        painter: LineChartPainter(),
      ),
    );
  }
}
    // Custom painter for the line chart
    class LineChartPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

      final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.4),
      ];

      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(path, paint);

      // Draw X-axis (time)
      final xAxisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

      canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      xAxisPaint,
      );

      final xAxisTextStyle = TextStyle(color: Colors.black, fontSize: 12);
      final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      );


      // Draw Y-axis (temperature)
      canvas.drawLine(
      Offset(0, 0),
      Offset(0, size.height),
      xAxisPaint,
      );

      final yAxisLabels = ['40°C', '30°C', '20°C', '10°C', '0°C'];
      for (int i = 0; i < yAxisLabels.length; i++) {
      textPainter.text = TextSpan(text: yAxisLabels[i], style: xAxisTextStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 4, size.height * i / (yAxisLabels.length - 1) - textPainter.height / 2),
      );
      }
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
      return false;
    }
    }
