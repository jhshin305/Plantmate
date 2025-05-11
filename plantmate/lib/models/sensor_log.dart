class SensorLog {
  final int? id;
  final int plantId;
  final DateTime timestamp;
  final double temperature;
  final double brightness;
  final double humidity;

  SensorLog({
    this.id,
    required this.plantId,
    required this.timestamp,
    required this.temperature,
    required this.brightness,
    required this.humidity,
  });

  factory SensorLog.fromMap(Map<String, dynamic> m) => SensorLog(
    id: m['id'] as int?,
    plantId: m['plant_id'] as int,
    timestamp: DateTime.parse(m['timestamp'] as String),
    temperature: m['temperature'] as double,
    brightness: m['brightness'] as double,
    humidity: m['humidity'] as double,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'plant_id': plantId,
    'timestamp': timestamp.toIso8601String(),
    'temperature': temperature,
    'brightness': brightness,
    'humidity': humidity,
  };
}
