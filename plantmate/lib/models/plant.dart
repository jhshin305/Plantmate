class Plant {
  int? id;
  final String name;
  final DateTime plantedDate;

  Plant({
    this.id,
    required this.name,
    required this.plantedDate,
  });

  // DB에 저장할 Map 형태
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'planted_date': plantedDate.toIso8601String(),
      };

  // DB에서 꺼낸 Map을 Plant 객체로 변환
  factory Plant.fromMap(Map<String, dynamic> m) => Plant(
        id: m['id'] as int?,
        name: m['name'],
        plantedDate: DateTime.parse(m['planted_date']),
      );
}
