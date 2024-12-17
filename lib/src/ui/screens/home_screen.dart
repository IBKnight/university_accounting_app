import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Домашний экран')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'first_lab');
              },
              child: Text('Перейти на FirstLabScreen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'second_lab');
              },
              child: Text('Перейти на SecondLabScreen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'third_lab');
              },
              child: Text('Перейти на ThirdLabScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
