import 'package:courseanalysis/features/new_department/models/course.dart';

class Department {
  final String departmentName;
  final List<Course> courses;

  Department({required this.departmentName, required this.courses});

  factory Department.fromJson(Map<String, dynamic> json) {
    var courseList = json['courses'] as List<dynamic>;
    List<Course> courses = courseList
        .map((course) => Course.fromJson(course as Map<String, dynamic>))
        .toList();

    return Department(
        departmentName: json['departmentName'] as String, courses: courses);
  }
}
