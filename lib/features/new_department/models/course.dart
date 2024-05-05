class Course {
  final String code;
  final String? prerequisites;
  final String name;
  final int ects;
  final String grade;
  final String semester;
  final bool checked;
  final bool taking;

  Course({
    required this.code,
    required this.prerequisites,
    required this.name,
    required this.ects,
    required this.grade,
    required this.semester,
    required this.checked,
    required this.taking,
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
    };
  }
}
