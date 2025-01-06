import 'package:biot/mixin/dialog_mixin.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../model/encounter.dart';
import '../../../model/patient.dart';
import '../../../model/view_arguments.dart';
import '../../common/constants.dart';
import '../add_patient/add_patient_view.dart';

class PatientAppBarViewModel extends BaseViewModel with OIDialog {
  final _navigationService = locator<NavigationService>();

  void navigateToAddPatientView({bool isEdit = false, Patient? patient}) {
    _navigationService.navigateToView(
        AddPatientView(isEdit: isEdit, patient: patient),
        fullscreenDialog: true);
  }

  void navigateToHomeTab() {
    BottomNavigationBar bar = bottomNavKey.currentWidget as BottomNavigationBar;
    bar.onTap!(1);
  }

  Future<void> navigateToEncounterView(
      Patient patient, ValueNotifier<List<Encounter>> encounters) async {
    await _navigationService.navigateTo(
        PatientViewNavigatorRoutes.encounterView,
        id: 0,
        arguments:
            EncounterViewArguments(patient: patient, encounters: encounters));

    notifyListeners();
  }
}
