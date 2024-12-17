import 'package:flutter/material.dart';
import 'package:university_accounting_app/src/common/app_di_container.dart';

class AppInh extends InheritedWidget {
  const AppInh({
    required this.appDiContainer,
    required super.child,
    super.key,
  });

  final AppDiContainer appDiContainer;

  static AppInh? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppInh>();
  }

  @override
  bool updateShouldNotify(AppInh oldWidget) {
    return false;
  }
}
