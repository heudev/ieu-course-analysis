import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

    setState(() {}); // Rebuild the widget to see the updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data['department']} Courses'),
      ),
      body: ReorderableListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> course = courses[index];

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
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Update Course Information',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
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
