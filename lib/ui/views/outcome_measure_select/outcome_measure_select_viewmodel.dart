import 'package:biot/app/app.bottomsheets.dart';
import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/outcome_measure_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../model/demo_globals.dart';
import '../../../model/encounter.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/patient.dart';
import '../../../services/database_service.dart';
import '../../../services/outcome_measure_load_service.dart';
import '../../../services/outcome_measure_selection_service.dart';
import '../evaluation/evaluation_view.dart';

class OutcomeMeasureSelectViewModel
    extends FutureViewModel<OutcomeMeasureCollection> {
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();
  final _outcomeMeasureLoadService = locator<OutcomeMeasureLoadService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _dialogService = locator<DialogService>();
  final _outcomeMeasureSelectionService =
      locator<OutcomeMeasureSelectionService>();

  Patient? get currentPatient => _localdbService.currentPatient?.value;

  List<OutcomeMeasure> get selectedIndividualOutcomeMeasures =>
      _outcomeMeasureSelectionService.individualOutcomeMeasures.value;

  List<OutcomeMeasureCollection> get selectedOutcomeMeasureCollections =>
      _outcomeMeasureSelectionService.outcomeMeasureCollections.value;

  List<OutcomeMeasure>? get preselectedOutcomeMeasures =>
      currentPatient?.encounterCollection.lastEncounter?.outcomeMeasures;

  List<OutcomeMeasure> get selectedOutcomeMeasures =>
      _outcomeMeasureSelectionService.selectedOutcomeMeasures;

  List<OutcomeMeasureCollection> get defaultOutcomeMeasureCollections =>
      _outcomeMeasureLoadService.defaultOutcomeMeasureCollections;

  int get numOfDomains =>
      _outcomeMeasureSelectionService.outcomeMeasuresMapByDomainType.length;

  int get patientTimeToComplete => selectedOutcomeMeasures.fold<int>(
      0, (previousValue, element) => previousValue + element.estTimeToComplete);

  int get assistantTimeToComplete => selectedOutcomeMeasures.fold<int>(
      0,
      (previousValue, element) => element.isAssistantNeeded
          ? previousValue + element.estTimeToComplete
          : previousValue + 0);

  int get clinicianTimeToComplete => 0;

  void onSelectOutcomeMeasureCollection(
      OutcomeMeasureCollection outcomeMeasureCollection) {
    outcomeMeasureCollection.isSelected = !outcomeMeasureCollection.isSelected;

    if (outcomeMeasureCollection.isSelected) {
      _outcomeMeasureSelectionService
          .addOutcomeMeasureCollection(outcomeMeasureCollection);
    } else {
      _outcomeMeasureSelectionService
          .removeOutcomeMeasureCollection(outcomeMeasureCollection);
    }
  }

  void onRemoveOutcomeMeasure(OutcomeMeasure outcomeMeasure) {
    outcomeMeasure.isSelected = !outcomeMeasure.isSelected;
    _outcomeMeasureSelectionService.removeOutcomeMeasure(outcomeMeasure);
  }

  Future onEditCollection(
      OutcomeMeasureCollection outcomeMeasureCollection) async {
    outcomeMeasureCollection.isEditing = true;
    outcomeMeasureCollection.tempOutcomeMeasures =
        List.of(outcomeMeasureCollection.outcomeMeasures);

    SheetResponse? response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.selectOutcomeMeasure,
      isScrollControlled: true,
      useRootNavigator: true,
    );

    // When bottom sheet is dismissed, isEditing sets to false
    if (response == null) {
      outcomeMeasureCollection.isEditing = false;
    }

    notifyListeners();
  }

  Future<void> onSelectOutcomeMeasure() async {
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.selectOutcomeMeasure,
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  void showCollectionInfoBottomSheet(
      OutcomeMeasureCollection outcomeMeasureCollection) {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.collectionInfo,
        isScrollControlled: true,
        useRootNavigator: true,
        data: outcomeMeasureCollection);
  }

  void validateStartEvaluationCriteria() {
    List<String> selectedOutcomeMeasuresIds =
        selectedOutcomeMeasures.map((e) => e.id).toList();
    List<String>? preselectedOutcomeMeasuresIds = preselectedOutcomeMeasures
        ?.where((e) => e.id != ksProgait)
        .map((e) => e.id)
        .toList();

    selectedOutcomeMeasuresIds.sort();
    preselectedOutcomeMeasuresIds?.sort();

    String dialogTitle;
    dialogTitle = currentPatient == null
        ? 'Please select a patient from the list.'
        : selectedOutcomeMeasures.isEmpty
            ? 'Please select outcome measures from the list.'
            : preselectedOutcomeMeasures != null &&
                    !listEquals(selectedOutcomeMeasuresIds,
                        preselectedOutcomeMeasuresIds)
                ? 'The current selection is different than the previously completed list.\nPlease select the same outcome measure set with the previous encounter.'
                : selectedOutcomeMeasures.any((element) => !element.isActive)
                    ? 'Some of the included outcome measures are unavailable.\nPlease retry without including them.'
                    : numOfDomains != 5
                        ? 'Please select at least one outcome measure for each domain.'
                        : '';

    if (dialogTitle.isEmpty) {
      navigateToEvaluationView();
    } else {
      _dialogService.showCustomDialog(
          variant: DialogType.confirmAlert,
          title: dialogTitle,
          mainButtonTitle: 'OK');
    }
  }

  void navigateToEvaluationView() {
    Encounter encounter = isDemo
        ? Encounter(domainWeightDist: currentPatient!.domainWeightDist)
        : Encounter();
    _navigationService.navigateWithTransition(EvaluationView(encounter));
  }

  @override
  Future<void> onData(OutcomeMeasureCollection? data) async {
    await _outcomeMeasureLoadService
        .getOutcomeMeasureCollections('default_collection');

    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_localdbService, _outcomeMeasureSelectionService];

  @override
  Future<OutcomeMeasureCollection> futureToRun() {
    return _outcomeMeasureLoadService.getAllOutcomeMeasures('outcome_measures');
  }
}
