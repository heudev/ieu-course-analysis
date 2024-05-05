import 'dart:convert';
import 'package:courseanalysis/features/new_department/models/faculty.dart';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<Faculty>> fetchFaculties() async {
    String jsonStr =
        await rootBundle.loadString('assets/data/departments.json');
    List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Faculty.fromJson(json)).toList();
  }
}
