// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Department _$DepartmentFromJson(Map<String, dynamic> json) => Department(
      departmentName: json['departmentName'] as String,
      facultyName: json['facultyName'] as String,
      courses: (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] as Map<String, dynamic>,
      docId: json['docId'] as String,
    );

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'departmentName': instance.departmentName,
      'facultyName': instance.facultyName,
      'courses': instance.courses,
      'user': instance.user,
      'docId': instance.docId,
    };
