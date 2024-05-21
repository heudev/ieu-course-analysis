import 'package:json_annotation/json_annotation.dart';
import 'course.dart';

part 'department.g.dart';

@JsonSerializable()
class Department {
  final String departmentName;
  final List<Course> courses;

  Department({required this.departmentName, required this.courses});

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}
