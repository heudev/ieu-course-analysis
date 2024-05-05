import 'package:courseanalysis/features/new_department/services/firestore_service.dart';
import 'package:flutter/material.dart';

class Departments extends StatefulWidget {
  final String facultyName;
  final List departments;

  const Departments(
      {super.key, required this.facultyName, required this.departments});

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  final Map<int, bool> _isSuccessMap = {};

  void addDataToFirestore(dynamic department, int index) async {
    setState(() {
      _isSuccessMap[index] = false;
    });

    try {
      await FirestoreService.addDataToFirestore(widget.facultyName, department);

      setState(() {
        _isSuccessMap[index] = true;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Department added successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
        title: Text(widget.facultyName),
      ),
      body: ListView.builder(
        itemCount: widget.departments.length,
        itemBuilder: (context, index) {
          var department = widget.departments[index];
          return ListTile(
              title: Text(department.departmentName),
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
