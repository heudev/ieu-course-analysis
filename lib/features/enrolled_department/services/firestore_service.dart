import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/features/enrolled_department/models/department.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Department>> getDepartmentsStream() {
    return _firestore
        .collection('departments')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> docData = doc.data();
              docData['docId'] = doc.id;
              return Department.fromJson(docData);
            }).toList());
  }

  Future<void> deleteDepartment(String departmentId) async {
    await _firestore.collection('departments').doc(departmentId).delete();
  }

  Future<void> addDepartment(Department department) async {
    await _firestore.collection('departments').add(department.toJson());
  }
}
