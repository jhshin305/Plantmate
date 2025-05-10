import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> _plants = const ['알로에', '스투키', '몬스테라'];

  @override
  Widget build(BuildContext context) {
    final count = _plants.length + 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌿 PlantMate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: count,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 4 / 5,
          ),
          itemBuilder: (ctx, i) {
            if (i == _plants.length) {
              return _AddCard(onTap: () => Navigator.pushNamed(ctx, '/add'));
            }
            return _PlantCard(
              name: _plants[i],
              days: (i + 1) * 3,
              onTap: () => Navigator.pushNamed(ctx, '/detail', arguments: _plants[i]),
            );
          },
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String name;
  final int days;
  final VoidCallback onTap;
  const _PlantCard({required this.name, required this.days, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.local_florist, size: 48, color: Colors.green[700])),
              const Spacer(),
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('$days일차', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: const Center(child: Icon(Icons.add, size: 48, color: Colors.grey)),
      ),
    );
  }
}
