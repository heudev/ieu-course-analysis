import 'package:courseanalysis/features/enrolled_department/models/course.dart';

class CourseAnalysisFacade {
  final List<Course> courses;

  CourseAnalysisFacade(this.courses);

  int calculateSuccessfulCourses() {
    int successfulCourses = 0;
    for (var course in courses) {
      if (course.taking) {
        continue;
      }
      var grade = course.grade;
      if (['AA', 'BA', 'BB', 'CB', 'CC', 'DC', 'DD'].contains(grade)) {
        successfulCourses++;
      }
    }
    return successfulCourses;
  }

  int calculateFailedCourses() {
    int failedCourses = 0;
    for (var course in courses) {
      if (course.taking) {
        continue;
      }
      var grade = course.grade;
      if (['FD', 'FF'].contains(grade)) {
        failedCourses++;
      }
    }
    return failedCourses;
  }

  int calculateTakingCourses() {
    int takingCourses = 0;
    for (var course in courses) {
      var taking = course.taking;
      if (taking == true) {
        takingCourses++;
      }
    }
    return takingCourses;
  }

  Object calculateGPA() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      var grade = course.grade;
      int ects = course.ects;

      if (grade != "") {
        var gradePoints = calculateGradePoints(grade);
        totalGradePoints += gradePoints * ects;
        totalCredits += ects;
      }
    }

    if (totalCredits == 0) {
      return 0.0;
    } else {
      return (totalGradePoints / totalCredits).toStringAsFixed(2);
    }
  }

  double calculateGradePoints(var grade) {
    switch (grade) {
      case 'AA':
        return 4.0;
      case 'BA':
        return 3.5;
      case 'BB':
        return 3.0;
      case 'CB':
        return 2.5;
      case 'CC':
        return 2.0;
      case 'DC':
        return 1.5;
      case 'DD':
        return 1.0;
      case 'FD':
        return 0.5;
      case 'FF':
        return 0.0;
      default:
        return 0.0;
    }
  }

  Map<String, Object> calculateTotalECTS() {
    double totalECTS = 0;
    double completedECTS = 0;
    for (var course in courses) {
      var grade = course.grade;
      var ects = course.ects;
      totalECTS += ects;
      if (grade != "" && grade != 'FD' && grade != 'FF') {
        if (grade.isNotEmpty) {
          completedECTS += ects;
        }
      }
    }
    double ratio = completedECTS / totalECTS;
    return {
      'takenECTS':
          completedECTS % 1 != 0 ? completedECTS : completedECTS.toInt(),
      'totalECTS': totalECTS % 1 != 0 ? totalECTS : totalECTS.toInt(),
      'ratio': ratio,
    };
  }

  Map<String, Object> calculateCompletedCourses() {
    int highGradeCourses = 0;
    for (var course in courses) {
      var grade = course.grade;
      if (calculateGradePoints(grade) >= calculateGradePoints('DD')) {
        highGradeCourses++;
      }
    }
    double ratio = highGradeCourses / courses.length;
    return {
      'completedCourses': highGradeCourses,
      'totalCourses': courses.length,
      'ratio': ratio,
    };
  }

  List<Map<String, Object>> calculateSemesterGPAs() {
    List<String> semesters = [];
    for (var course in courses) {
      if (!semesters.contains(course.semester)) {
        semesters.add(course.semester);
      }
    }

    List<Map<String, Object>> semesterGPAs = [];
    for (var semester in semesters) {
      double totalGradePoints = 0;
      int totalCredits = 0;
      int passedCourses = 0;
      int totalCourses = 0;
      int totalECTS = 0;

      for (var course in courses) {
        if (course.semester == semester) {
          totalCourses++;
          var grade = course.grade;
          int ects = course.ects;
          totalECTS += ects;

          if (grade != "") {
            var gradePoints = calculateGradePoints(grade);
            totalGradePoints += gradePoints * ects;
            totalCredits += ects;
            if (grade != 'F' && grade != 'FF') {
              passedCourses++;
            }
          }
        }
      }

      semesterGPAs.add({
        'semester': semester.split("Semester")[0],
        'gpa': totalCredits == 0
            ? 0.0.toStringAsFixed(2)
            : (totalGradePoints / totalCredits).toStringAsFixed(2),
        'completed': '$passedCourses/$totalCourses',
        'totalECTS': totalECTS.toString()
      });
    }

    semesterGPAs.sort(
        (a, b) => (a['semester'] as String).compareTo(b['semester'] as String));

    return semesterGPAs;
  }
}
