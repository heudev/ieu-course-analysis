import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/features/new_department/models/department.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        "user": {
          "email": FirebaseAuth.instance.currentUser!.email,
          "name": FirebaseAuth.instance.currentUser!.displayName,
          "photoURL": FirebaseAuth.instance.currentUser!.photoURL,
          "uid": FirebaseAuth.instance.currentUser!.uid,
        },
      };

      final DocumentReference docRef =
          await FirebaseFirestore.instance.collection('departments').add(data);
      print('Added Data with ID: ${docRef.id}');

      await Future.delayed(const Duration(seconds: 1));

      return docRef.id;
    } catch (e) {
      print('Error adding data to Firestore: $e');
      throw e;
    }
  }
}
