import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courseanalysis/features/enrolled_department/academic_progress.dart';
import 'package:courseanalysis/features/enrolled_department/models/course.dart';
import 'package:courseanalysis/features/enrolled_department/models/department.dart';
import 'package:courseanalysis/features/enrolled_department/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

  final FirestoreService courseService = FirestoreService();

  Color getGradeColor(String grade, bool taking) {
    final succesfulGrades = ['AA', 'BA', 'BB', 'CB', 'CC', 'DC', 'DD'];
    final failedGrades = ['FD', 'FF'];
    if (taking) {
      return Colors.orange.shade200;
    }
    if (succesfulGrades.contains(grade)) {
      return Colors.green.shade200;
    } else if (failedGrades.contains(grade)) {
      return Colors.red.shade200;
    } else {
      return Colors.white;
    }
  }

  void addNewCourse() {
    Course newCourse = Course(
      id: const Uuid().v4(),
      name: 'New Course',
      code: 'NEW101',
      ects: 0,
      semester: '1. Year Fall Semester',
      grade: '',
      taking: false,
      prerequisites: '',
      checked: false,
    );

    setState(() {
      courses.insert(0, newCourse);
    });

    courseService.updateCourses(widget.department.docId, courses);
  }

  void orderCourses() {
    courses.sort((a, b) => a.semester.compareTo(b.semester));
    courseService.updateCourses(widget.department.docId, courses);
    setState(() {});
  }

  Future<String> getMostCommonGrade(String courseCode) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('departments').get();

      Map<String, int> gradeCounts = {};
      for (var doc in snapshot.docs) {
        List<dynamic> courses = doc['courses'];
        for (var course in courses) {
          if (course['code'] == courseCode && course['grade'] != '') {
            String grade = course['grade'];
            gradeCounts[grade] = (gradeCounts[grade] ?? 0) + 1;
          }
        }
      }

      String mostCommonGrade = '';
      int maxCount = 0;
      gradeCounts.forEach((grade, count) {
        if (count > maxCount) {
          maxCount = count;
          mostCommonGrade = grade;
        }
      });

      return mostCommonGrade.isNotEmpty
          ? mostCommonGrade
          : 'No grades available';
    } catch (e) {
      print('Error getting most common grade: $e');
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.department.departmentName.replaceAll('Department of', '')),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: orderCourses,
          ),
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: addNewCourse,
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          Course course = courses[index];

          return Dismissible(
              key: Key(course.id),
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
                          "Are you sure you want to delete this course?"),
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
              onDismissed: (direction) async {
                setState(() {
                  courses.removeWhere((coursex) => coursex.id == course.id);
                });
                await courseService.updateCourses(
                    widget.department.docId, courses);
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: course.semester.contains('Fall')
                      ? Colors.blue
                      : Colors.red,
                  child: Text(
                    course.ects.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                tileColor: getGradeColor(course.grade, course.taking),
                key: Key(course.id),
                title: Text(course.name),
                subtitle: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.purple,
                      child: Text(
                        (course.semester)[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(" ${course.code}"),
                  ],
                ),
                trailing: course.grade == '' && course.taking
                    ? const Icon(Icons.hourglass_empty)
                    : Text(course.grade,
                        style: const TextStyle(fontSize: 18.0)),
                onTap: () async {
                  final mostCommonGrade = await getMostCommonGrade(course.code);
                  await showModalBottomSheet(
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
                                    decoration: const InputDecoration(
                                        labelText: 'Name'),
                                    onChanged: (value) {
                                      setState(() {
                                        course.name = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: course.code,
                                    decoration: const InputDecoration(
                                        labelText: 'Code'),
                                    onChanged: (value) {
                                      setState(() {
                                        course.code = value;
                                      });
                                    },
                                  ),
                                  DropdownButtonFormField<int>(
                                    value: course.ects,
                                    decoration: const InputDecoration(
                                      labelText: 'ECTS',
                                    ),
                                    items: List.generate(121, (index) => index)
                                        .map((int value) =>
                                            DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value.toString()),
                                            ))
                                        .toList(),
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        course.ects = newValue!;
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
                                        value: '2. Year Spring Semester',
                                        child: Text('2. Year Spring Semester'),
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
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        course.semester = value!;
                                      });
                                    },
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: course.grade,
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
                                        value: "",
                                        child: Text('Not Graded Yet'),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      setState(() {
                                        course.grade = value!;
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Most Common Grade:',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        mostCommonGrade,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  DropdownButtonFormField<bool>(
                                    value: course.taking,
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
                                    initialValue: course.prerequisites,
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
                                    child: const SizedBox(
                                      width: double.infinity,
                                      child: Text('Update',
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                  setState(() {});
                },
              ));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AcademicProgressScreen(courses: courses),
            ),
          );
        },
        tooltip: 'Academic Progress',
        child: const Icon(Icons.insert_chart_rounded),
      ),
    );
  }
}
