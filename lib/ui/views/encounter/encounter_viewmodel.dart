import 'dart:async';

import 'package:biot/app/app.dialogs.dart';
import 'package:biot/app/app.router.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import '../../../app/app.locator.dart';
import '../../../model/demo_globals.dart';
import '../../../model/patient.dart';
import '../../../model/peripheral_device.dart';
import '../../../model/encounter.dart';

class EncounterViewModel extends BaseViewModel with OIDialog {
  final _apiService = locator<BiotService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  final Patient patient;
  final ValueNotifier<List<Encounter>> encounters;

  bool isLoading = false;

  EncounterViewModel({required this.patient, required this.encounters}) {
    encounters.value = patient.encounterCollection.encounters;
  }

  Future<void> onPullRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      encounters.value =
          await _apiService.getEncounters(http.Client(), patient);
    } catch (e) {
      handleHTTPError(e);
    }
  }

  Future<void> addUsageEncounter(PeripheralDevice usageEncounter) async {
    try {
      Encounter? newUsageEncounter = await _apiService
          .addUsageEncounter(http.Client(), usageEncounter: usageEncounter);

      navigateToSensorSummaryView(newUsageEncounter!);
    } catch (e) {
      handleHTTPError(e);
    }
  }

  Future<void> addMeasurements() async {
    int interval = 6;
    int totalSteps = 0;
    // TODO: Consider timezone! Convert to UTC.
    DateTime time = DateTime(2023, 06, 10, 00, 00, 00);

    for (var i = 0; i < 28; i++) {
      totalSteps =
          await _apiService.addMeasurement(http.Client(), time, totalSteps);
      time = time.add(Duration(hours: interval));
    }
  }

  void showConfirmDeleteDialog(Encounter encounter) async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.confirmAlert,
        title: 'Are you sure you wish to delete this encounter?',
        data: encounter,
        mainButtonTitle: 'Cancel',
        secondaryButtonTitle: 'Delete');

    if (response != null && response.confirmed) {
      if (!isDemo) {
        try {
          await _apiService.deleteEncounter(http.Client(), encounter);
        } catch (e) {
          handleHTTPError(e);
        }
      }
      // Remove from the list
      encounters.value = encounters.value.where((s) => s != encounter).toList();
      patient.encounters!
          .removeWhere((element) => element.entityId == encounter.entityId);

      notifyListeners();
    }
  }

  void navigateToSummaryView(Encounter encounter) {
    _navigationService.navigateToSummaryView(
        encounter: encounter, isNewAdded: true);
  }

  void navigateToSensorSummaryView(Encounter encounter) {
    _navigationService.navigateTo(Routes.sensorSummaryView,
        id: 0, arguments: encounter);
  }
}
