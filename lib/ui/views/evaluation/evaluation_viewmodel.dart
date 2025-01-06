import 'package:biot/mixin/dialog_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../constants/app_strings.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/encounter.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/patient.dart';
import '../../../services/database_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/outcome_measure_selection_service.dart';

class EvaluationViewModel extends BaseViewModel with OIDialog {
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();
  final _dialogService = locator<DialogService>();
  final _outcomeMeasureSelectionService =
      locator<OutcomeMeasureSelectionService>();
  final _logger =
      locator<LoggerService>().getLogger((EvaluationViewModel).toString());

  int currentOutcomeIdx = 0;

  List<OutcomeMeasure> get outcomeMeasures {
    List<OutcomeMeasure> sortedOutcomeMeasures =
        _outcomeMeasureSelectionService.selectedOutcomeMeasures;

    List<OutcomeMeasure> clinicianNeeded = sortedOutcomeMeasures
        .where((element) => element.isAssistantNeeded)
        .toList();

    sortedOutcomeMeasures.removeWhere((element) => element.isAssistantNeeded);
    sortedOutcomeMeasures.insertAll(0, clinicianNeeded);

    int psfsIndex =
        sortedOutcomeMeasures.indexWhere((element) => element.id == ksPsfs);
    if (psfsIndex != -1) {
      OutcomeMeasure psfs = sortedOutcomeMeasures.removeAt(psfsIndex);
      sortedOutcomeMeasures.insert(0, psfs);
    }

    return sortedOutcomeMeasures;
  }

  OutcomeMeasure get currentOutcomeMeasure =>
      outcomeMeasures[currentOutcomeIdx];
  late Encounter encounter;

  Patient? get currentPatient => _localdbService.currentPatient?.value;

  EvaluationViewModel({required this.encounter}) {
    _logger.d('');
  }

  void initState() async {
    setBusy(true);

    _logger.d(outcomeMeasures.map((e) => e.id).toList());

    for (var outcomeMeasure in outcomeMeasures) {
      await outcomeMeasure.build();
    }
    setBusy(false);
  }

  void stopTts() {}

  String getCurrentOutcomeName() {
    if (Device.get().isTablet) {
      switch (currentOutcomeMeasure.id) {
        case ksPsfs:
          return LocaleKeys.psfs.tr();
        case ksDash:
          return LocaleKeys.dash.tr();
        case ksScs:
          return LocaleKeys.scs.tr();
        case ksTmwt:
          return LocaleKeys.tenMWT.tr();
        case ksFaam:
          return LocaleKeys.faam.tr();
        case ksTug:
          return LocaleKeys.tug.tr();
        case ksPromispi:
          return LocaleKeys.promispi.tr();
        case ksPmq:
          return LocaleKeys.pmq.tr();
        default:
          return currentOutcomeMeasure.name;
      }
    } else {
      return currentOutcomeMeasure.shortName;
    }
  }

  void nextOutcome() async {
    if (currentOutcomeIdx < outcomeMeasures.length - 1) {
      _logger.d('next');

      currentOutcomeIdx++;
      notifyListeners();
    } else {
      _logger.d('finished evaluation');

      for (OutcomeMeasure outcomeMeasure in outcomeMeasures) {
        encounter.addOutcomeMeasure(outcomeMeasure);
      }

      navigateToSummary();
    }
  }

  void showIncompleteDialog() async {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Incomplete',
      description: 'Please complete the evaluation.',
      barrierDismissible: true,
    );
  }

  void navigateToSummary() {
    _navigationService.replaceWithSummaryView(
        encounter: encounter, isNewAdded: true);
  }

  void navigateToInfo() {
    _navigationService.navigateTo(Routes.outcomeMeasureInfoView,
        arguments: currentOutcomeMeasure);
  }
}
