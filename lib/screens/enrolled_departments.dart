import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/screens/courses.dart';
import 'package:courseanalysis/screens/faculties.dart';
import 'package:courseanalysis/screens/profile.dart';
import 'package:flutter/material.dart';

class EnrolledDepartments extends StatelessWidget {
  const EnrolledDepartments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Departments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('departments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Map<String, dynamic>> data = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
            docData['docId'] = doc.id;
            return docData;
          }).toList();

          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == data.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Faculties(),
                        ),
                      );
                    },
                    child: const Text('Add new department'),
                  ),
                );
              }

              Map<String, dynamic> department = data[index];

              return Dismissible(
                key: Key(department['docId']),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text(
                            "Are you sure you want to delete this department?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  // Delete the department from Firestore
                  FirebaseFirestore.instance
                      .collection('departments')
                      .doc(department['docId'])
                      .delete();
                },
                child: ListTile(
                  title: Text(department['department']),
                  subtitle: Text(department['faculty']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursesScreen(data: department),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
