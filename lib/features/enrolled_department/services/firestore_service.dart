import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/features/enrolled_department/models/department.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Department>> getDepartmentsStream() {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection('departments')
        .where('user.uid', isEqualTo: currentUserUid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> docData = doc.data();
              docData['docId'] = doc.id;
              return Department.fromJson(docData);
            }).toList());
  }

  Future<void> deleteDepartment(String departmentId) async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final departmentDoc =
        _firestore.collection('departments').doc(departmentId);
    final departmentSnapshot = await departmentDoc.get();
    final departmentData = departmentSnapshot.data();
    final departmentOwnerUid = departmentData?['user']['uid'];

    if (departmentOwnerUid == currentUserUid) {
      await departmentDoc.delete();
    } else {
      throw Exception('You do not have permission to delete this department.');
    }
  }

  Future<void> addDepartment(Department department) async {
    await _firestore.collection('departments').add(department.toJson());
  }
}
