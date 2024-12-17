class SecondLabModel {
  final String disciplineName;
  final String disciplineDescription;
  final List<LectureModel> lectures;

  SecondLabModel({
    required this.disciplineName,
    required this.disciplineDescription,
    required this.lectures,
  });

  factory SecondLabModel.fromJson(Map<String, dynamic> json) => SecondLabModel(
        disciplineName: json["discipline_name"],
        disciplineDescription: json["discipline_description"],
        lectures: List<LectureModel>.from(
          json["lectures"].map(
            (x) => LectureModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "discipline_name": disciplineName,
        "discipline_description": disciplineDescription,
        "lectures": List<dynamic>.from(
          lectures.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class LectureModel {
  final String topic;
  final String type;
  final String date;
  final int studentCount;
  final List<String> techEquipments;

  LectureModel({
    required this.topic,
    required this.type,
    required this.date,
    required this.studentCount,
    required this.techEquipments,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) => LectureModel(
        topic: json["topic"],
        type: json["type"],
        date: json["date"],
        studentCount: json["student_count"],
        techEquipments: List<String>.from(
          json["tech_equipments"].map((x) => x),
        ),
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "type": type,
        "date": date,
        "student_count": studentCount,
        "tech_equipments": List<dynamic>.from(
          techEquipments.map((x) => x),
        ),
      };
}
