import 'dart:async';
import 'dart:developer';

import 'package:university_accounting_app/src/common/app_runner.dart';

void main() {
  runZonedGuarded(() => AppRunner().initializeAndRun(),
      (e, stackTrace) => log('$e, $stackTrace'));
}
