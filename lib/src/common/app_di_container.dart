import 'package:dio/dio.dart';
import 'package:university_accounting_app/data/api.dart';

final class AppDiContainer {
  final Dio dio;

  final Api labsApi;

  const AppDiContainer({
    required this.dio,
    required this.labsApi,
  });
}
