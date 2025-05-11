class ActuatorLog {
  final int? id;
  final int plantId;
  final DateTime timestamp;
  final String action;

  ActuatorLog({
    this.id,
    required this.plantId,
    required this.timestamp,
    required this.action,
  });

  factory ActuatorLog.fromMap(Map<String, dynamic> m) => ActuatorLog(
    id: m['id'] as int?,
    plantId: m['plant_id'] as int,
    timestamp: DateTime.parse(m['timestamp'] as String),
    action: m['action'] as String,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'plant_id': plantId,
    'timestamp': timestamp.toIso8601String(),
    'action': action,
  };
}