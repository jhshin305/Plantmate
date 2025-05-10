class Plant {
  int? id;
  final String name;
  final String variety;        // 품종
  final DateTime plantedDate;
  final double? temperature;   // 초기값(센서로 대체 가능)
  final double? brightness;    // 조명 밝기
  final double? humidity;      // 습도
  final double? tankLevel;     // 수통 잔량
  final double? trayHeight;    // 물받이 높이

  Plant({
    this.id,
    required this.name,
    required this.variety,
    required this.plantedDate,
    this.temperature,
    this.brightness,
    this.humidity,
    this.tankLevel,
    this.trayHeight,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'variety': variety,
        'planted_date': plantedDate.toIso8601String(),
        'temperature': temperature,
        'brightness': brightness,
        'humidity': humidity,
        'tank_level': tankLevel,
        'tray_height': trayHeight,
      };

  factory Plant.fromMap(Map<String, dynamic> m) => Plant(
        id: m['id'] as int?,
        name: m['name'] as String,
        variety: m['variety'] as String,
        plantedDate: DateTime.parse(m['planted_date'] as String),
        temperature: m['temperature'] as double?,
        brightness: m['brightness'] as double?,
        humidity: m['humidity'] as double?,
        tankLevel: m['tank_level'] as double?,
        trayHeight: m['tray_height'] as double?,
      );
}
