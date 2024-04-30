import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/screens/academic_progress.dart';
import 'package:flutter/material.dart';

/* 
"departments": [
      {
        "department": "Department of Aerospace Engineering",
        "courses": [
          { "code": "ENG 101", "prerequisites": null, "name": "Academic Skills in English I", "ects": "3", "grade": "", "semester": "1. Year Fall Semester", "checked": false, "taking": false },
          { "code": "FENG 101", "prerequisites": null, "name": "Fundamentals of Engineering Culture", "ects": "4", "grade": "", "semester": "1. Year Fall Semester", "checked": false, "taking": false },

        }
      ]
 */

class CoursesScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const CoursesScreen({super.key, required this.data});

  @override
  State<CoursesScreen> createState() => _CoursesScreen();
}

class _CoursesScreen extends State<CoursesScreen> {
  late List<Map<String, dynamic>> courses;

  @override
  void initState() {
    super.initState();
    courses = List<Map<String, dynamic>>.from(widget.data['courses']);
  }

  Future<void> updateCourseOrder() async {
    widget.data['courses'] = courses;
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(widget.data['docId'])
        .update({'courses': courses});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.data['department'].replaceAll('Department of', '')}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AcademicProgressScreen(data: widget.data),
                ),
              );
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> course = courses[index];

          /* List<String> emptyArray = [];
          if (!emptyArray.contains(course['id'])) {
            emptyArray.add(course['id']);
          }
          print(emptyArray); */

          return ListTile(
            key: Key(course['id']), // Provide a unique key for reordering
            title: Text(course['name']),

            subtitle: Text('Code: ${course['code']}'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Center(
                                child: Text(
                                  'Update Course Information',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextFormField(
                                initialValue: course['name'],
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                onChanged: (value) {
                                  setState(() {
                                    course['name'] = value;
                                  });
                                },
                              ),
                              TextFormField(
                                initialValue: course['code'],
                                decoration:
                                    const InputDecoration(labelText: 'Code'),
                                onChanged: (value) {
                                  setState(() {
                                    course['code'] = value;
                                  });
                                },
                              ),
                              TextFormField(
                                initialValue: course['ects'].toString(),
                                decoration:
                                    const InputDecoration(labelText: 'ECTS'),
                                onChanged: (value) {
                                  setState(() {
                                    course['ects'] = value;
                                  });
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: course['semester'],
                                decoration: const InputDecoration(
                                  labelText: 'Semester',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: '1. Year Fall Semester',
                                    child: Text('1. Year Fall Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '1. Year Spring Semester',
                                    child: Text('1. Year Spring Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '2. Year Fall Semester',
                                    child: Text('2. Year Fall Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '3. Year Fall Semester',
                                    child: Text('3. Year Fall Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '3. Year Spring Semester',
                                    child: Text('3. Year Spring Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '4. Year Fall Semester',
                                    child: Text('4. Year Fall Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '4. Year Spring Semester',
                                    child: Text('4. Year Spring Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '5. Year Fall Semester',
                                    child: Text('5. Year Fall Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '5. Year Spring Semester',
                                    child: Text('5. Year Spring Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '6. Year Fall Semester',
                                    child: Text('6. Year Fall Semester'),
                                  ),
                                  DropdownMenuItem(
                                    value: '6. Year Spring Semester',
                                    child: Text('6. Year Spring Semester'),
                                  ),
                                  // Add more semesters as needed
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    course['semester'] = value;
                                  });
                                },
                              ),

                              DropdownButtonFormField<String>(
                                value:
                                    null, // Set the initial value to match one of the DropdownMenuItem values
                                decoration: const InputDecoration(
                                  labelText: 'Grade',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'AA',
                                    child: Text('AA'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BA',
                                    child: Text('BA'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BB',
                                    child: Text('BB'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'CB',
                                    child: Text('CB'),
                                  ),
                                  DropdownMenuItem(
                                    value: "CC",
                                    child: Text('CC'),
                                  ),
                                  DropdownMenuItem(
                                    value: "DC",
                                    child: Text('DC'),
                                  ),
                                  DropdownMenuItem(
                                    value: "DD",
                                    child: Text('DD'),
                                  ),
                                  DropdownMenuItem(
                                    value: "FD",
                                    child: Text('FD'),
                                  ),
                                  DropdownMenuItem(
                                    value: "FF",
                                    child: Text('FF'),
                                  ),
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text('null'),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    course['grade'] = value;
                                  });
                                },
                              ),

                              // Prerequisites
                              TextFormField(
                                initialValue: course['prerequisites'] ?? '',
                                decoration: const InputDecoration(
                                    labelText: 'Prerequisites'),
                                onChanged: (value) {
                                  setState(() {
                                    course['prerequisites'] = value;
                                  });
                                },
                              ),

                              // Add other form fields here
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () async {
                                  updateCourseOrder();
                                  Navigator.pop(context);
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final Map<String, dynamic> course = courses.removeAt(oldIndex);
            courses.insert(newIndex, course);
          });
          updateCourseOrder();
        },
      ),
    );
  }
}
