class FirstLabModel {
    final String studentId;
    final String name;
    final String group;
    final int course;
    final String department;
    final String email;
    final String birth;
    final num attendanceRate;
    final String reportingPeriod;
    final String matchedTerm;

    FirstLabModel({
        required this.studentId,
        required this.name,
        required this.group,
        required this.course,
        required this.department,
        required this.email,
        required this.birth,
        required this.attendanceRate,
        required this.reportingPeriod,
        required this.matchedTerm,
    });

    factory FirstLabModel.fromJson(Map<String, dynamic> json) => FirstLabModel(
        studentId: json["student_id"],
        name: json["name"],
        group: json["group"],
        course: json["course"],
        department: json["department"],
        email: json["email"],
        birth: json["birth"],
        attendanceRate: json["attendance_rate"],
        reportingPeriod: json["reporting_period"],
        matchedTerm: json["matched_term"],
    );

    Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "name": name,
        "group": group,
        "course": course,
        "department": department,
        "email": email,
        "birth": birth,
        "attendance_rate": attendanceRate,
        "reporting_period": reportingPeriod,
        "matched_term": matchedTerm,
    };
}
