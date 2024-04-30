import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:courseanalysis/utils/calculations.dart';

class AcademicProgressScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const AcademicProgressScreen({super.key, required this.data});

/* 
"departments": [
      {
        "department": "Department of Aerospace Engineering",
        "courses": [
          { "code": "ENG 101", "prerequisites": null, "name": "Academic Skills in English I", "ects": 3, "grade": "", "semester": "1. Year Fall Semester", "checked": false, "taking": false },
          { "code": "FENG 101", "prerequisites": null, "name": "Fundamentals of Engineering Culture", "ects": 4, "grade": "", "semester": "1. Year Fall Semester", "checked": false, "taking": false },

        }
      ]
 */

  @override
  Widget build(BuildContext context) {
    print(calculateTotalECTS(data));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Academic Progress"),
      ),
      body: Center(
        child: ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: 1,
                  center: Text(calculateSuccessfulCourses(data).toString()),
                  progressColor: Colors.green,
                  animation: true,
                  footer: const Text("Success"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: 1,
                  center: Text(calculateFailedCourses(data).toString()),
                  progressColor: Colors.red,
                  animation: true,
                  footer: const Text("Fail"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: 1,
                  center: Text(calculateTakingCourses(data).toString()),
                  progressColor: Colors.orange,
                  animation: true,
                  footer: const Text("Enrolled"),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: 1,
                  center: Text(calculateGPA(data).toString()),
                  progressColor: Colors.blue,
                  animation: true,
                  footer: const Text("CGPA"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: calculateTotalECTS(data)['ratio'] as double,
                  center: Text(
                      "${calculateTotalECTS(data)['takenECTS']}/${calculateTotalECTS(data)['totalECTS']}"),
                  progressColor: Colors.purple,
                  animation: true,
                  footer: const Text("ECTS"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: 0.2,
                  center: const Text("6/46"),
                  progressColor: Colors.purple,
                  animation: true,
                  footer: const Text("Completed"),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 4.0,
                  percent: 1,
                  center: const Text("3.60"),
                  progressColor: Colors.blue,
                  animation: true,
                  footer: const Text("1. Year Fall"),
                ),
                const SizedBox(width: 20.0), // Added SizedBox for spacing
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 4.0,
                  percent: 1,
                  center: const Text("3.70"),
                  progressColor: Colors.blue,
                  animation: true,
                  footer: const Text("1. Year Spring"),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
