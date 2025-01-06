import 'package:biot/app/app.router.dart';
import 'package:biot/model/patient.dart';
import 'package:biot/ui/views/patient/patient_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biot/app/app.locator.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

void main() {
  PatientViewModel _getModel() => PatientViewModel();

  group('PatientViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    group('futureToRun -', () {
      test('Should return a list of Patient', () async {
        final model = _getModel();
        when(model.futureToRun()).thenAnswer((_) async => <Patient>[]);
        expect(model.futureToRun(), isA<List<Patient>>());
      });
    });

    // group('navigateToSessionView', () {
    //   test('Should navigate to session view', () {
    //     final navigationService = getAndRegisterNavigationService();
    //     final model = _getModel();
    //     model.navigateToSessionView();
    //     verify(navigationService.navigateTo(Routes.sessionView));
    //   });
    // });
  });
}
