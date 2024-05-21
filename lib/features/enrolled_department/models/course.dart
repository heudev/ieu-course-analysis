import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  String code;
  String prerequisites;
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

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
