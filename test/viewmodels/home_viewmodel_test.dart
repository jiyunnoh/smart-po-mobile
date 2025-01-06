import 'package:biot/app/app.dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:biot/app/app.bottomsheets.dart';
import 'package:biot/app/app.locator.dart';
import 'package:biot/constants/app_strings.dart';
import 'package:biot/ui/views/outcome_measure_select/outcome_measure_select_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  OutcomeMeasureSelectViewModel _getModel() => OutcomeMeasureSelectViewModel();

  // group('HomeViewmodelTest -', () {
  //   setUp(() => registerServices());
  //   tearDown(() => locator.reset());
  //
  //   group('isClicked -', () {
  //     test('Initial value should be false', () {
  //       final model = _getModel();
  //       expect(model.isLoading, false);
  //     });
  //     test('Is Loading value should be changed to true', () {
  //       final model = _getModel();
  //
  //       model.isClicked();
  //       expect(model.isLoading, true);
  //     });
  //   });
  //
  //   group('showLoginErrorDialog -', () {
  //     test('Should show custom dialog using infoAlert variant', () {
  //       final dialogService = getAndRegisterDialogService();
  //       final model = _getModel();
  //       model.showLoginErrorDialog();
  //       verify(dialogService.showCustomDialog(
  //         variant: DialogType.infoAlert,
  //         title: 'Login Error!',
  //         description: 'Please try again.',
  //       ));
  //     });
  //     test('Is Loading value should be false', () {
  //       final model = _getModel();
  //       model.showLoginErrorDialog();
  //       expect(model.isLoading, false);
  //     });
  //   });
  //
  //   group('login -', () {
  //     test('description', () => null);
  //   });
  // });
}
