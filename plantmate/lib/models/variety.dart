class VarietyDefault {
  final String variety;
  final double tempMin, tempMax;
  final double brightMin, brightMax;
  final double humMin, humMax;
  final int waterCycleDays;

  VarietyDefault({
    required this.variety,
    required this.tempMin,
    required this.tempMax,
    required this.brightMin,
    required this.brightMax,
    required this.humMin,
    required this.humMax,
    required this.waterCycleDays,
  });

  factory VarietyDefault.fromMap(Map<String, dynamic> m) => VarietyDefault(
    variety: m['variety'],
    tempMin: m['temp_min'],
    tempMax: m['temp_max'],
    brightMin: m['bright_min'],
    brightMax: m['bright_max'],
    humMin: m['hum_min'],
    humMax: m['hum_max'],
    waterCycleDays: m['water_cycle_days'],
  );
}
