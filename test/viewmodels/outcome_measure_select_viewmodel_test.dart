import 'package:flutter_test/flutter_test.dart';
import 'package:biot/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('OutcomeMeasureSelectViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
