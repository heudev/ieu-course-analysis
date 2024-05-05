import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/features/enrolled_department/models/course.dart';

class Department {
  final String departmentName;
  final List<Course> courses;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String email;
  final String uid;
  final String photoURL;
  final String name;
  final String facultyName;
  final String docId;

  Department({
    required this.departmentName,
    required this.courses,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.uid,
    required this.photoURL,
    required this.name,
    required this.facultyName,
    required this.docId,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    var courseList = json['courses'] as List;
    List<Course> courses =
        courseList.map((course) => Course.fromJson(course)).toList();

    return Department(
      departmentName: json['departmentName'],
      courses: courses,
      createdAt: (json['createdAt'] as Timestamp?) ?? Timestamp.now(),
      updatedAt: (json['updatedAt'] as Timestamp?) ?? Timestamp.now(),
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
      photoURL: json['photoURL'] ?? '',
      name: json['name'] ?? '',
      facultyName: json['facultyName'] ?? '',
      docId: json['docId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'departmentName': departmentName,
      'facultyName': facultyName,
      'courses': courses.map((course) => course.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'email': email,
      'uid': uid,
      'photoURL': photoURL,
      'name': name,
    };
  }
}
