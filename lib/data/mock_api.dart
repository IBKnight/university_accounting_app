import 'package:university_accounting_app/data/api.dart';
import 'package:university_accounting_app/data/models/first_lab_model.dart';
import 'package:university_accounting_app/data/models/second_lab_model.dart';
import 'package:university_accounting_app/data/models/third_lab_model.dart';

class MockApiService implements Api {
  @override
  Future<List<String>> getGroups() async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Задержка для имитации запроса
    return ['БСБО-01-21', 'БСБО-02-21', 'БСБО-03-21'];
  }

  @override
  Future<List<FirstLabModel>> getAttendanceReport({
    required String term,
    required String startDate,
    required String endDate,
  }) async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Задержка для имитации запроса
    return [
      {
        "student_id": "123",
        "name": "Иван Бондарев",
        "group": "БСБО-02-21",
        "course": 3,
        "department": "Информатика",
        "email": "ivan@gmail.com",
        "birth": "2002-04-15",
        "attendance_rate": 95,
        "reporting_period": "$startDate - $endDate",
        "matched_term": term
      },
      {
        "student_id": "124",
        "name": "Алексей Иванов",
        "group": "БСБО-02-21",
        "course": 3,
        "department": "Информатика",
        "email": "alexey@gmail.com",
        "birth": "2002-05-20",
        "attendance_rate": 88,
        "reporting_period": "$startDate - $endDate",
        "matched_term": term
      }
    ].map((value) => FirstLabModel.fromJson(value)).toList();
  }

  @override
  Future<List<SecondLabModel>> getCourseReport(int year, int semester) async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Задержка для имитации запроса
    return [
      {
        "discipline_name": "Математика",
        "discipline_description": "Высшая математика",
        "lectures": [
          {
            "topic": "Линейная алгебра",
            "type": "лекция",
            "date": "2024-09-10",
            "student_count": 25,
            "tech_equipments": ["Проектор", "Компьютер"]
          },
          {
            "topic": "Дифференциальное исчисление",
            "type": "лекция",
            "date": "2024-09-17",
            "student_count": 22,
            "tech_equipments": ["Проектор"]
          }
        ]
      },
      {
        "discipline_name": "Информатика",
        "discipline_description": "Основы программирования",
        "lectures": [
          {
            "topic": "Введение в алгоритмы",
            "type": "практика",
            "date": "2024-09-12",
            "student_count": 20,
            "tech_equipments": ["Компьютеры"]
          }
        ]
      }
    ].map((value) => SecondLabModel.fromJson(value)).toList();
  }

  @override
  Future<ThirdLabModel> getGroupReport(String group) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ThirdLabModel.fromJson({
      "group_name": group,
      "students": [
        {
          "student_id": "123",
          "name": "Иван Бондарев",
          "group": group,
          "course": 3,
          "email": "ivan@gmail.com",
          "birth": "2002-04-15",
          "disciplines": [
            {
              "name": "Математика",
              "description": "Курс по математике",
              "planned_hours": 40,
              "attended_hours": 38
            },
            {
              "name": "Физика",
              "description": "Курс по физике",
              "planned_hours": 40,
              "attended_hours": 35
            }
          ]
        },
        {
          "student_id": "124",
          "name": "Алексей Иванов",
          "group": group,
          "course": 3,
          "email": "alexey@gmail.com",
          "birth": "2002-05-20",
          "disciplines": [
            {
              "name": "Математика",
              "description": "Курс по математике",
              "planned_hours": 40,
              "attended_hours": 40
            }
          ]
        }
      ]
    });
  }
}
