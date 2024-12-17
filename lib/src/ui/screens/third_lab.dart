import 'package:flutter/material.dart';
import 'package:university_accounting_app/data/models/third_lab_model.dart';
import 'package:university_accounting_app/src/common/app_inh.dart';

class ThirdLabScreen extends StatefulWidget {
  const ThirdLabScreen({super.key});

  @override
  State<ThirdLabScreen> createState() => _ThirdLabScreenState();
}

class _ThirdLabScreenState extends State<ThirdLabScreen> {
  String? selectedGroup;
  Future<List<String>>? _futureGroups;
  Future<ThirdLabModel?>? _futureReport;

  /// Обработка нажатия на кнопку "Получить отчет по группе"
  void onFetchReportPressed() async {
    if (selectedGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите группу')),
      );
      return;
    }

    _futureReport = AppInh.of(context)
        ?.appDiContainer
        .labsApi
        .getGroupReport(selectedGroup!);

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _futureGroups = AppInh.of(context)?.appDiContainer.labsApi.getGroups();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отчет по группе')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите группу:',
              style: TextStyle(fontSize: 16),
            ),
            FutureBuilder<List<String>>(
              future: _futureGroups,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final groups = snapshot.data!;
                  return DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGroup,
                    items: groups.map((group) {
                      return DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value;
                      });
                    },
                  );
                } else {
                  return const Center(
                      child: Text('Не удалось загрузить группы'));
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onFetchReportPressed,
              child: const Text('Получить отчет по группе'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _futureReport == null
                  ? const Center(
                      child: Text(
                          'Выберите группу и нажмите "Получить отчет по группе"'))
                  : FutureBuilder<ThirdLabModel?>(
                      future: _futureReport,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Ошибка: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final reportData = snapshot.data!;
                          if (reportData.students.isEmpty) {
                            return const Center(
                              child: Text('Отчет по этой группе пуст'),
                            );
                          }
                          return ListView.builder(
                            itemCount: reportData.students.length,
                            itemBuilder: (context, index) {
                              final student = reportData.students[index];
                              return StudentCard(student: student);
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

class StudentCard extends StatelessWidget {
  final StudentInfo student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.school, color: Colors.orangeAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Группа: ${student.group}, Курс: ${student.course}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: student.disciplines
                  .map((discipline) => DisciplineCard(discipline: discipline))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DisciplineCard extends StatelessWidget {
  final DisciplineReport discipline;

  const DisciplineCard({super.key, required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(discipline.name),
        subtitle: Text(discipline.description),
        trailing: Text(
            'Плановые: ${discipline.plannedHours}, Отработано: ${discipline.attendedHours}'),
      ),
    );
  }
}
