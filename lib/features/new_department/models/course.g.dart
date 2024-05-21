// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      code: json['code'] as String,
      prerequisites: json['prerequisites'] as String?,
      name: json['name'] as String,
      ects: (json['ects'] as num).toInt(),
      grade: json['grade'] as String,
      semester: json['semester'] as String,
      checked: json['checked'] as bool,
      taking: json['taking'] as bool,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'code': instance.code,
      'prerequisites': instance.prerequisites,
      'name': instance.name,
      'ects': instance.ects,
      'grade': instance.grade,
      'semester': instance.semester,
      'checked': instance.checked,
      'taking': instance.taking,
    };
