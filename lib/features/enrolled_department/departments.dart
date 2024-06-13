import 'package:courseanalysis/features/auth/profile.dart';
import 'package:courseanalysis/features/enrolled_department/courses.dart';
import 'package:courseanalysis/features/enrolled_department/models/department.dart';
import 'package:courseanalysis/features/enrolled_department/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:courseanalysis/features/new_department/faculties.dart';

class EnrolledDepartments extends StatelessWidget {
  final FirestoreService departmentService = FirestoreService();

  EnrolledDepartments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Departments'),
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
      body: StreamBuilder<List<Department>>(
        stream: departmentService.getDepartmentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Department> departments = snapshot.data ?? [];

          return ListView.builder(
            itemCount: departments.length + 1,
            itemBuilder: (context, index) {
              if (index == departments.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FacultyScreen(),
                        ),
                      );
                    },
                    child: const Text('Add new department'),
                  ),
                );
              }

              Department department = departments[index];

              return Dismissible(
                key: Key(department.docId),
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
                  departmentService.deleteDepartment(department.docId);
                },
                child: ListTile(
                  title: Text(department.departmentName),
                  subtitle: Text(department.facultyName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CoursesScreen(department: department),
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
