import 'package:courseanalysis/features/enrolled_department/models/course.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:courseanalysis/features/enrolled_department/controllers/calculations.dart';

class AcademicProgressScreen extends StatelessWidget {
  final List<Course> courses;

  const AcademicProgressScreen({super.key, required this.courses});

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
    CourseAnalysisFacade analysisFacade = CourseAnalysisFacade(courses);
    int successfulCourses = analysisFacade.calculateSuccessfulCourses();
    int failedCourses = analysisFacade.calculateFailedCourses();
    int takingCourses = analysisFacade.calculateTakingCourses();
    Object gpa = analysisFacade.calculateGPA();
    Map<String, Object> totalECTS = analysisFacade.calculateTotalECTS();
    Map<String, Object> completedCourses =
        analysisFacade.calculateCompletedCourses();
    List<Map<String, Object>> calculateSemesterGPAs =
        analysisFacade.calculateSemesterGPAs();

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
                  center: Text(successfulCourses.toString()),
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
                  center: Text(failedCourses.toString()),
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
                  center: Text(takingCourses.toString()),
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
                  center: Text(gpa.toString()),
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
                  percent: totalECTS['ratio'] as double,
                  center: Text(
                      "${totalECTS['takenECTS']}/${totalECTS['totalECTS']}"),
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
                  percent: completedCourses["ratio"] as double,
                  center: Text(
                      "${completedCourses["completedCourses"]}/${completedCourses['totalCourses']}"),
                  progressColor: Colors.purple,
                  animation: true,
                  footer: const Text("Completed"),
                ),
              ],
            ),
          ),
          const Center(
            child: Text("Semester GPA's", style: TextStyle(fontSize: 20.0)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Container(
            padding: const EdgeInsets.all(.0),
            child: Wrap(
              alignment: WrapAlignment.center, // Ortala
              runSpacing: 2.0,
              children: <Widget>[
                for (int i = 0; i < calculateSemesterGPAs.length; i += 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 4.0,
                          percent: 1,
                          center:
                              Text(calculateSemesterGPAs[i]['gpa'].toString()),
                          progressColor: Colors.blue,
                          animation: true,
                          footer: Text(calculateSemesterGPAs[i]['semester']
                              .toString()
                              .replaceAll("Semester", "")),
                        ),
                      ),
                      if (i + 1 < calculateSemesterGPAs.length)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                      Flexible(
                        child: CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 4.0,
                          percent: 1,
                          center: Text(
                              calculateSemesterGPAs[i + 1]['gpa'].toString()),
                          progressColor: Colors.blue,
                          animation: true,
                          footer: Text(calculateSemesterGPAs[i + 1]['semester']
                              .toString()
                              .replaceAll("Semester", "")),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
