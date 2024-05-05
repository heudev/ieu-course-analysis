class Course {
  String code;
  String? prerequisites;
  String name;
  int ects;
  String grade;
  String semester;
  bool checked;
  bool taking;
  String id;

  Course({
    required this.code,
    required this.prerequisites,
    required this.name,
    required this.ects,
    required this.grade,
    required this.semester,
    required this.checked,
    required this.taking,
    required this.id,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'],
      prerequisites: json['prerequisites'],
      name: json['name'],
      ects: json['ects'],
      grade: json['grade'] ?? "",
      semester: json['semester'],
      checked: json['checked'],
      taking: json['taking'],
      id: json['id'],
    );
  }
  Map<String, Object> toJson() {
    return {
      'code': code,
      'prerequisites': prerequisites ?? "",
      'name': name,
      'ects': ects,
      'grade': grade,
      'semester': semester,
      'checked': checked,
      'taking': taking,
      'id': id,
    };
  }
}
