import 'package:json_annotation/json_annotation.dart';
import 'package:courseanalysis/features/enrolled_department/models/course.dart';

part 'department.g.dart';

@JsonSerializable()
class Department {
  final String departmentName;
  final String facultyName;
  final List<Course> courses;
  final Map<String, dynamic> user;
  final String docId;

  Department({
    required this.departmentName,
    required this.facultyName,
    required this.courses,
    required this.user,
    required this.docId,
  });

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}
