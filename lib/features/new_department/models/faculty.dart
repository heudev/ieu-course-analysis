import 'package:courseanalysis/features/new_department/models/department.dart';

class Faculty {
  final String facultyName;
  final List<Department> departments;

  Faculty({required this.facultyName, required this.departments});

  factory Faculty.fromJson(Map<String, dynamic> json) {
    var departmentList = json['departments'] as List;
    List<Department> departments =
        departmentList.map((dept) => Department.fromJson(dept)).toList();

    return Faculty(facultyName: json['facultyName'], departments: departments);
  }
}
