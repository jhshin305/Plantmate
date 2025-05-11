class AlertLog {
  final int? id;
  final int plantId;
  final DateTime timestamp;
  final String alertType;
  final String message;

  AlertLog({
    this.id,
    required this.plantId,
    required this.timestamp,
    required this.alertType,
    required this.message,
  });

  factory AlertLog.fromMap(Map<String, dynamic> m) => AlertLog(
    id: m['id'] as int?,
    plantId: m['plant_id'] as int,
    timestamp: DateTime.parse(m['timestamp'] as String),
    alertType: m['alert_type'] as String,
    message: m['message'] as String,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'plant_id': plantId,
    'timestamp': timestamp.toIso8601String(),
    'alert_type': alertType,
    'message': message,
  };
}
