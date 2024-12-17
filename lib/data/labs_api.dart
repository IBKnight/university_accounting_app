import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:university_accounting_app/data/api.dart';
import 'package:university_accounting_app/data/models/first_lab_model.dart';
import 'package:university_accounting_app/data/models/second_lab_model.dart';
import 'package:university_accounting_app/data/models/third_lab_model.dart';

final class LabsApi implements Api {
  final Dio _dio;

  LabsApi({required Dio dio}) : _dio = dio;

  @override
  Future<List<String>> getGroups() async {
    try {
      final response = await _dio.get('/groups');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }

  @override
  Future<List<FirstLabModel>> getAttendanceReport({
    required String term,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.get('/attendance-report', queryParameters: {
        'term': term,
        'startDate': startDate,
        'endDate': endDate,
      });
      return List<Map<String, Object?>>.from(response.data)
          .map((value) => FirstLabModel.fromJson(value))
          .toList();
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }

  @override
  Future<List<SecondLabModel>> getCourseReport(int year, int semester) async {
    try {
      final response = await _dio.get('/course-report',
          queryParameters: {'year': year, 'sem': semester});
      return List<Map<String, Object?>>.from(response.data)
          .map((value) => SecondLabModel.fromJson(value))
          .toList();
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }

  @override
  Future<ThirdLabModel?> getGroupReport(String group) async {
    try {
      final response =
          await _dio.get('/group-report', queryParameters: {'group': group});
      return ThirdLabModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Обработка ошибок
  void _handleError(DioException error) {
    if (error.response != null) {
      // Ошибки от сервера
      log('Server Error [${error.response?.statusCode}]: ${error.response?.data}');
      switch (error.response?.statusCode) {
        case 400:
          log('Ошибка 400: Неверный запрос');
          break;
        case 401:
          log('Ошибка 401: Неавторизован');
          break;
        case 403:
          log('Ошибка 403: Доступ запрещен');
          break;
        case 404:
          log('Ошибка 404: Ресурс не найден');
          break;
        case 500:
          log('Ошибка 500: Внутренняя ошибка сервера');
          break;
        default:
          log('Неизвестная ошибка сервера: ${error.response?.statusCode}');
      }
    } else {
      // Ошибки сети (например, отсутствие подключения)
      log('Ошибка сети: ${error.message}');
    }
  }
}
