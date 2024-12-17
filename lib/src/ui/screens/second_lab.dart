import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university_accounting_app/data/models/second_lab_model.dart';
import 'package:university_accounting_app/src/common/app_inh.dart';

class SecondLabScreen extends StatefulWidget {
  const SecondLabScreen({super.key});

  @override
  State<SecondLabScreen> createState() => _SecondLabScreenState();
}

class _SecondLabScreenState extends State<SecondLabScreen> {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  Future<List<SecondLabModel>>? _futureReport;

  void onFetchReportPressed() {
    final year = yearController.text;
    final semester = semesterController.text;

    if (year.isEmpty || semester.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    setState(
      () {
        _futureReport =
            AppInh.of(context)?.appDiContainer.labsApi.getCourseReport(
                  int.parse(year),
                  int.parse(semester),
                );
      },
    );
  }

  // Функция для открытия диалога с информацией по лекциям
  void _showLecturesDialog(List<LectureModel> lectures) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Информация о лекциях",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lectures.map((lecture) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название лекции
                        Text(
                          lecture.topic,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        // Тип лекции
                        Text(
                          'Тип: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(lecture.type),
                        const SizedBox(height: 4.0),

                        // Техническое оборудование
                        Text(
                          'Техническое оборудование: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(lecture.techEquipments.join(', ')),
                        const SizedBox(height: 8.0),

                        // Дата и количество студентов
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Дата
                                Text(
                                  'Дата:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(lecture.date),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Количество студентов
                                Text(
                                  'Студентов:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${lecture.studentCount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отчет по курсу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: yearController,
              decoration: const InputDecoration(labelText: 'Год'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Только цифры
            ),
            const SizedBox(height: 10),
            TextField(
              controller: semesterController,
              decoration: const InputDecoration(labelText: 'Семестр'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Только цифры
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onFetchReportPressed,
              child: const Text('Получить отчет по курсу'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _futureReport == null
                  ? const Center(
                      child: Text(
                          'Введите данные и нажмите "Получить отчет по курсу"'))
                  : FutureBuilder<List<SecondLabModel>>(
                      future: _futureReport,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Ошибка: ${snapshot.error}, ${snapshot.stackTrace}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final reportData = snapshot.data!;
                          if (reportData.isEmpty) {
                            return const Center(
                              child: Text('Данных для этого курса не найдено'),
                            );
                          }
                          return ListView.builder(
                            itemCount: reportData.length,
                            itemBuilder: (context, index) {
                              final report = reportData[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text(
                                      'Дисциплина: ${report.disciplineName}'),
                                  subtitle: Text(
                                      'Описание: ${report.disciplineDescription}'),
                                  onTap: () {
                                    // Открываем диалог по лекциям при клике
                                    _showLecturesDialog(report.lectures);
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Неизвестная ошибка'));
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
