import 'package:courseanalysis/features/new_department/departments.dart';
import 'package:courseanalysis/features/new_department/models/faculty.dart';
import 'package:courseanalysis/features/new_department/services/data_service.dart';
import 'package:flutter/material.dart';

class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faculties')),
      body: FutureBuilder<List<Faculty>>(
        future: DataService.fetchFaculties(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Faculty> faculties = snapshot.data!;
            return ListView.builder(
              itemCount: faculties.length,
              itemBuilder: (context, index) {
                final Faculty faculty = faculties[index];
                return ListTile(
                  title: Text(faculty.facultyName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Departments(
                            departments: faculty.departments,
                            facultyName: faculty.facultyName),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
