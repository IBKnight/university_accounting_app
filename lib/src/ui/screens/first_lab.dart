import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university_accounting_app/data/models/first_lab_model.dart';
import 'package:university_accounting_app/src/common/app_inh.dart';

class FirstLabScreen extends StatefulWidget {
  const FirstLabScreen({super.key});

  @override
  State<FirstLabScreen> createState() => _FirstLabScreenState();
}

class _FirstLabScreenState extends State<FirstLabScreen> {
  final TextEditingController termController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  Future<List<FirstLabModel>>?
      _futureReport; // Хранит запрос на получение отчета

  /// Метод для получения отчета о посещаемости
  void handleFetchAttendanceReport() {
    final term = termController.text;
    final startDate = startDateController.text;
    final endDate = endDateController.text;

    if (term.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    setState(() {
      _futureReport =
          AppInh.of(context)?.appDiContainer.labsApi.getAttendanceReport(
                term: term,
                startDate: startDate,
                endDate: endDate,
              );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Отчет о посещаемости')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: termController,
              decoration: InputDecoration(
                  labelText: 'Термин (например, "Осенний семестр")'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: startDateController,
              decoration:
                  InputDecoration(labelText: 'Дата начала (ГГГГ-ММ-ДД)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Только цифры
                DateInputFormatter(), // Кастомный формат даты ГГГГ-ММ-ДД
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: endDateController,
              decoration:
                  InputDecoration(labelText: 'Дата окончания (ГГГГ-ММ-ДД)'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Только цифры
                DateInputFormatter(), // Кастомный формат даты ГГГГ-ММ-ДД
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleFetchAttendanceReport,
              child: Text('Получить отчет о посещаемости'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<FirstLabModel>>(
                future: _futureReport,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error} ${snapshot.stackTrace}'));
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(child: Text('Данные не найдены'));
                  } else if (snapshot.hasData) {
                    final reports = snapshot.data!;
                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(report.name),
                            subtitle: Text('Группа: ${report.group}'),
                            trailing:
                                Text('Посещаемость: ${report.attendanceRate}%'),
                            onTap: () {
                              // Открыть детальную информацию о студенте
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Информация о студенте'),
                                  content: Text(
                                    'Имя: ${report.name}\n'
                                    'Группа: ${report.group}\n'
                                    'Курс: ${report.course}\n'
                                    'Кафедра: ${report.department}\n'
                                    'Email: ${report.email}\n'
                                    'Дата рождения: ${report.birth}\n'
                                    'Посещаемость: ${report.attendanceRate}%',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Закрыть'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text('Нажмите кнопку, чтобы получить отчет'));
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

/// Кастомный форматтер для ввода даты ГГГГ-ММ-ДД
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Удаляем все символы, кроме цифр
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Ограничиваем длину текста до 8 символов (ГГГГММДД)
    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // Добавляем "-" после 4-го и 6-го символа
      if (i == 3 || i == 5) {
        buffer.write('-');
      }
    }

    final formattedText = buffer.toString();

    // Считаем новую позицию курсора
    int selectionIndex = newValue.selection.baseOffset;

    if (selectionIndex > formattedText.length) {
      selectionIndex = formattedText.length;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
