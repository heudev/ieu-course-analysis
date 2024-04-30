int calculateSuccessfulCourses(data) {
  int successfulCourses = 0;
  for (var course in data["courses"]) {
    var grade = course['grade'];
    if (['AA', 'BA', 'BB', 'CB', 'CC', 'DC', 'DD'].contains(grade)) {
      successfulCourses++;
    }
  }
  return successfulCourses;
}

int calculateFailedCourses(data) {
  int failedCourses = 0;
  for (var course in data["courses"]) {
    var grade = course['grade'];
    if (['FD', 'FF'].contains(grade)) {
      failedCourses++;
    }
  }
  return failedCourses;
}

int calculateTakingCourses(data) {
  int takingCourses = 0;
  for (var course in data["courses"]) {
    var taking = course['taking'];
    if (taking == true) {
      takingCourses++;
    }
  }
  return takingCourses;
}

Object calculateGPA(data) {
  double totalGradePoints = 0;
  int totalCredits = 0;

  for (var course in data["courses"]) {
    var grade = course['grade'];
    int ects = course['ects'];

    if (grade != null) {
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

Map<String, Object> calculateTotalECTS(data) {
  double totalECTS = 0;
  double completedECTS = 0;
  for (var course in data["courses"]) {
    var grade = course['grade'];
    var ects = course['ects'];
    totalECTS += ects;
    if (grade != null && grade != 'FD' && grade != 'FF') {
      if (grade.isNotEmpty) {
        completedECTS += ects;
      }
    }
  }
  double ratio = completedECTS / totalECTS;
  return {
    'takenECTS': completedECTS % 1 != 0 ? completedECTS : completedECTS.toInt(),
    'totalECTS': totalECTS % 1 != 0 ? totalECTS : totalECTS.toInt(),
    'ratio': ratio,
  };
}
