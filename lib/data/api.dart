import 'package:university_accounting_app/data/models/first_lab_model.dart';
import 'package:university_accounting_app/data/models/second_lab_model.dart';
import 'package:university_accounting_app/data/models/third_lab_model.dart';

abstract interface class Api {
  /// Получение списка групп
  Future<List<String>> getGroups();

  /// Получение отчета о посещаемости
  Future<List<FirstLabModel>> getAttendanceReport(
      {required String term,
      required String startDate,
      required String endDate});

  /// Получение отчета по курсу
  Future<List<SecondLabModel>> getCourseReport(int year, int semester);

  /// Получение отчета по группе
  Future<ThirdLabModel?> getGroupReport(String group);
}
