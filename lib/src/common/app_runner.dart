import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:university_accounting_app/data/labs_api.dart';
// import 'package:university_accounting_app/data/mock_api.dart';
import 'package:university_accounting_app/src/app.dart';
import 'package:university_accounting_app/src/common/app_di_container.dart';
import 'package:university_accounting_app/src/common/app_inh.dart';

final class AppRunner {
  const AppRunner();

  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    binding.deferFirstFrame();

    try {
      const baseUrl = 'http://localhost:8000/api/v1';

      final dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10), // Таймаут на подключение
        receiveTimeout:
            const Duration(seconds: 10), // Таймаут на получение данных
        headers: {
          'Content-Type': 'application/json',
        },
      ));

      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          log('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          return handler.next(error);
        },
      ));

      final labsApi = LabsApi(dio: dio);
      // final labsApi = MockApiService();

      final dependencies = AppDiContainer(
        dio: dio,
        labsApi: labsApi,
      );

      runApp(
        AppInh(
          appDiContainer: dependencies,
          child: const App(),
        ),
      );
    } catch (e, stackTrace) {
      log('Initialization failed error: $e, stackTrace: $stackTrace');
    } finally {
      binding.allowFirstFrame();
    }
  }
}
