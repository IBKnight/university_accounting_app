class ThirdLabModel {
  final String groupName;
  final List<StudentInfo> students;

  ThirdLabModel({
    required this.groupName,
    required this.students,
  });

  factory ThirdLabModel.fromJson(Map<String, dynamic> json) => ThirdLabModel(
        groupName: json["group_name"],
        students: List<StudentInfo>.from(json["students"].map((x) => StudentInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "group_name": groupName,
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
      };
}

class StudentInfo {
  final String studentId;
  final String name;
  final String group;
  final int course;
  final String email;
  final String birth;
  final List<DisciplineReport> disciplines;

  StudentInfo({
    required this.studentId,
    required this.name,
    required this.group,
    required this.course,
    required this.email,
    required this.birth,
    required this.disciplines,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
        studentId: json["student_id"],
        name: json["name"],
        group: json["group"],
        course: json["course"],
        email: json["email"],
        birth: json["birth"],
        disciplines: List<DisciplineReport>.from(
            json["disciplines"].map((x) => DisciplineReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "name": name,
        "group": group,
        "course": course,
        "email": email,
        "birth": birth,
        "disciplines": List<dynamic>.from(disciplines.map((x) => x.toJson())),
      };
}

class DisciplineReport {
  final String name;
  final String description;
  final int plannedHours;
  final int attendedHours;

  DisciplineReport({
    required this.name,
    required this.description,
    required this.plannedHours,
    required this.attendedHours,
  });

  factory DisciplineReport.fromJson(Map<String, dynamic> json) => DisciplineReport(
        name: json["name"],
        description: json["description"],
        plannedHours: json["planned_hours"],
        attendedHours: json["attended_hours"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "planned_hours": plannedHours,
        "attended_hours": attendedHours,
      };
}
