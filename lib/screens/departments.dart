import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Departments extends StatefulWidget {
  final String faculty;
  final List<Map<String, dynamic>> departments;

  Departments({required this.faculty, required this.departments});

  @override
  _Departments createState() => _Departments();
}

class _Departments extends State<Departments> {
  final Map<int, bool> _isSuccessMap = {};

  void addDataToFirestore(Map<String, dynamic> department, int index) async {
    setState(() {
      _isSuccessMap[index] = false;
    });

    try {
      /* const uuid = Uuid();
       final List<Map> coursesWithIds = courses.map((course) {
        final String courseId = uuid.v4();
        return {
          ...course,
          'id': courseId,
        };
      }).toList(); */

      final List<dynamic> courses = department['courses'];
      final data = {
        "department": department['department'],
        "faculty": widget.faculty,
        "courses": courses,
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

      setState(() {
        _isSuccessMap[index] = true;
      });
    } catch (e) {
      print('Error adding data to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding data to Firestore: $e'),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.faculty),
      ),
      body: ListView.builder(
        itemCount: widget.departments.length,
        itemBuilder: (context, index) {
          var department = widget.departments[index];
          return ListTile(
              title: Text(department['department']),
              trailing: _isSuccessMap[index] == true
                  ? const Padding(
                      padding: EdgeInsets.only(right: 11.0),
                      child: Icon(Icons.check_circle, color: Colors.green),
                    )
                  : _isSuccessMap[index] == false
                      ? const Padding(
                          padding: EdgeInsets.only(right: 13.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            addDataToFirestore(department, index);
                          },
                          icon: const Icon(Icons.add_to_photos_rounded),
                        ));
        },
      ),
    );
  }
}
