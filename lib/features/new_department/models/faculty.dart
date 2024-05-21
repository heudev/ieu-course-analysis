import 'package:json_annotation/json_annotation.dart';
import 'department.dart';

part 'faculty.g.dart';

@JsonSerializable()
class Faculty {
  final String facultyName;
  final List<Department> departments;

  Faculty({required this.facultyName, required this.departments});

  factory Faculty.fromJson(Map<String, dynamic> json) =>
      _$FacultyFromJson(json);

  Map<String, dynamic> toJson() => _$FacultyToJson(this);
}
