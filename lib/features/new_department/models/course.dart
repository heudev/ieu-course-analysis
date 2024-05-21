import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
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

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
