import 'dart:async';

import 'package:biot/app/app.locator.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/encounter.dart';
import 'package:biot/services/cloud_service.dart';
import 'package:biot/ui/views/complete/complete_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../model/demo_globals.dart';
import '../../../model/patient.dart';
import '../../../services/database_service.dart';
import '../../../services/logger_service.dart';
import 'package:http/http.dart' as http;

class SummaryViewModel extends FutureViewModel with OIDialog {
  final _apiService = locator<BiotService>();
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();
  final _logger =
      locator<LoggerService>().getLogger((SummaryViewModel).toString());

  bool shouldDrawGraph = false;

  Patient get currentPatient => _localdbService.currentPatient!.value;

  bool get isAnonymous => _localdbService.currentPatient == null;

  BuildContext context;

  final Encounter encounter;
  final bool isNewAdded;
  ValueNotifier<bool> isLoginLoading = ValueNotifier(false);

  SummaryViewModel(
      {required this.encounter,
      required this.isNewAdded,
      required this.context});

  @override
  Future<List<OutcomeMeasure>> futureToRun() {
    if (isNewAdded) {
      return Future.value(encounter.outcomeMeasures);
    } else {
      return _apiService.getOutcomeMeasures(encounter);
    }
  }

  @override
  Future<void> onData(data) async {
    setBusy(true);
    if (!isNewAdded) {
      // Sort by completion order
      List<OutcomeMeasure> outcomeMeasures = data;
      outcomeMeasures.sort((a, b) => a.index!.compareTo(b.index!));
      encounter.outcomeMeasures = outcomeMeasures;
    }

    setBusy(false);
    notifyListeners();
  }

  Future onSubmit() async {
    _logger.d('');
    try {
      showBusyDialog();

      encounter.encounterCreatedTimeString =
          DateTime.now().toUtc().toIso8601String();

      for (OutcomeMeasure om in encounter.outcomeMeasures!) {
        om.outcomeMeasureCreatedTimeString =
            encounter.encounterCreatedTimeString;
      }

      currentPatient.outcomeMeasureIds = encounter.outcomeMeasureIds;

      encounter.calculateScore();

      if (isDemo) {
        encounter.entityId =
            '${currentPatient.fullName}_${encounter.encounterCreatedTime}';
        encounter.isPopulated = true;
      } else {
        await _apiService.addEncounter(
            http.Client(), encounter, currentPatient);
      }

      currentPatient.encounters ??= [];
      currentPatient.encounters!.insert(0, encounter);

      closeBusyDialog();

      navigateToCompleteView();
    } catch (e) {
      closeBusyDialog();

      handleHTTPError(e);
    }
  }

  Future<void> navigateToCompleteView() async {
    await _navigationService.replaceWithTransition(CompleteView(encounter));
  }
}
