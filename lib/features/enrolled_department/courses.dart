import 'package:courseanalysis/features/enrolled_department/academic_progress.dart';
import 'package:courseanalysis/features/enrolled_department/models/course.dart';
import 'package:courseanalysis/features/enrolled_department/models/department.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateCourses(String departmentId, List<Course> courses) async {
    List<Map<String, Object>> courseJsonList =
        courses.map((course) => course.toJson()).toList();
    await _firestore
        .collection('departments')
        .doc(departmentId)
        .update({'courses': courseJsonList});
  }
}

class CoursesScreen extends StatefulWidget {
  final Department department;

  const CoursesScreen({super.key, required this.department});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> courses;

  @override
  void initState() {
    super.initState();
    courses = widget.department.courses;
  }

  final CourseService courseService = CourseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.department.departmentName.replaceAll('Department of', '')),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AcademicProgressScreen(courses: courses),
                ),
              );
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          Course course = courses[index];

          return ListTile(
            tileColor: course.taking ? Colors.green[100] : null,
            key: Key(course.id),
            title: Text(course.name),
            subtitle: Text('Code: ${course.code}'),
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
                                initialValue: course.name,
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                onChanged: (value) {
                                  setState(() {
                                    course.name = value;
                                  });
                                },
                              ),
                              TextFormField(
                                initialValue: course.code,
                                decoration:
                                    const InputDecoration(labelText: 'Code'),
                                onChanged: (value) {
                                  setState(() {
                                    course.code = value;
                                  });
                                },
                              ),
                              TextFormField(
                                initialValue: course.ects.toString(),
                                decoration:
                                    const InputDecoration(labelText: 'ECTS'),
                                onChanged: (value) {
                                  setState(() {
                                    course.ects = value as int;
                                  });
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: course.semester,
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
                                    course.semester = value!;
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
                                    course.grade = value!;
                                  });
                                },
                              ),
                              DropdownButtonFormField<bool>(
                                value: false,
                                decoration: const InputDecoration(
                                  labelText: 'Enrolling the course',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text('Yes'),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text('No'),
                                  ),
                                ],
                                onChanged: (bool? value) {
                                  setState(() {
                                    course.taking = value!;
                                  });
                                },
                              ),
                              TextFormField(
                                initialValue: course.prerequisites ?? '',
                                decoration: const InputDecoration(
                                    labelText: 'Prerequisites'),
                                onChanged: (value) {
                                  setState(() {
                                    course.prerequisites = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () async {
                                  await courseService.updateCourses(
                                      widget.department.docId, courses);
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
            final Course course = courses.removeAt(oldIndex);
            courses.insert(newIndex, course);
          });
          courseService.updateCourses(widget.department.docId, courses);
        },
      ),
    );
  }
}
