import 'package:flutter/material.dart';
import 'package:university_accounting_app/src/ui/screens/first_lab.dart';
import 'package:university_accounting_app/src/ui/screens/home_screen.dart';
import 'package:university_accounting_app/src/ui/screens/second_lab.dart';
import 'package:university_accounting_app/src/ui/screens/third_lab.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/first_lab': (context) => FirstLabScreen(),
        '/second_lab': (context) => SecondLabScreen(),
        '/third_lab': (context) => ThirdLabScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'first_lab':
            return MaterialPageRoute(builder: (context) => FirstLabScreen());
          case 'second_lab':
            return MaterialPageRoute(builder: (context) => SecondLabScreen());
          case 'third_lab':
            return MaterialPageRoute(builder: (context) => ThirdLabScreen());
          default:
            return MaterialPageRoute(builder: (context) => HomeScreen());
        }
      },
      title: 'University Accounting',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
