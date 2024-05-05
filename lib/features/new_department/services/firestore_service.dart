import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/features/new_department/models/department.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  static Future<String> addDataToFirestore(
      String facultyName, Department department) async {
    try {
      final List<dynamic> courses = department.courses;
      const uuid = Uuid();
      final List<Map> coursesWithIds = courses.map((course) {
        final String courseId = uuid.v4();
        return {
          ...course.toJson(),
          'id': courseId,
        };
      }).toList();

      final data = {
        "departmentName": department.departmentName,
        "facultyName": facultyName,
        "courses": coursesWithIds,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
        "email": "",
        "name": "",
        "photoURL": "",
        "uid": "",
      };

      final DocumentReference docRef =
          await FirebaseFirestore.instance.collection('departments').add(data);
      print('Added Data with ID: ${docRef.id}');

      await Future.delayed(const Duration(seconds: 2));

      return docRef.id;
    } catch (e) {
      print('Error adding data to Firestore: $e');
      throw e;
    }
  }
}
