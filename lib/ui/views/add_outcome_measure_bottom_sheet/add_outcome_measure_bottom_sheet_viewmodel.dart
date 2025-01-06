import 'package:biot/model/outcome_measure_collection.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/outcome_measure_load_service.dart';
import '../../../services/outcome_measure_selection_service.dart';

class AddOutcomeMeasureBottomSheetViewModel extends ReactiveViewModel {
  final _outcomeMeasureSelectionService =
      locator<OutcomeMeasureSelectionService>();
  final _outcomeMeasureLoadService = locator<OutcomeMeasureLoadService>();
  final _navigationService = locator<NavigationService>();

  final OutcomeMeasureCollection? outcomeMeasureCollection;

  List<OutcomeMeasure> get allOutcomeMeasures =>
      _outcomeMeasureLoadService.allOutcomeMeasures.outcomeMeasures;

  List<OutcomeMeasure> get selectedIndividualOutcomeMeasures =>
      _outcomeMeasureSelectionService.individualOutcomeMeasures.value;

  List<OutcomeMeasureCollection> get selectedOutcomeMeasureCollections =>
      _outcomeMeasureSelectionService.outcomeMeasureCollections.value;

  List<OutcomeMeasure> get selectedOutcomeMeasures =>
      _outcomeMeasureSelectionService.selectedOutcomeMeasures;

  List<OutcomeMeasure> tempOutcomeMeasures = [];

  int get numOfDomains =>
      _outcomeMeasureSelectionService.outcomeMeasuresMapByDomainType.length;

  int get patientTimeToComplete =>
      _outcomeMeasureSelectionService.patientTimeToComplete;

  int get assistantTimeToComplete =>
      _outcomeMeasureSelectionService.assistantTimeToComplete;

  int get clinicianTimeToComplete =>
      _outcomeMeasureSelectionService.clinicianTimeToComplete;

  AddOutcomeMeasureBottomSheetViewModel({this.outcomeMeasureCollection}) {
    // When adding outcome measures to collection
    if (outcomeMeasureCollection != null) {
      // Create a new list that removes elements from outcomeMeasureCollection.tempOutcomeMeasures
      tempOutcomeMeasures = allOutcomeMeasures
          .where((elementA) => !outcomeMeasureCollection!.tempOutcomeMeasures
              .any((elementB) => elementA == elementB))
          .toList();
      for (var element in tempOutcomeMeasures) {
        element.isSelected = false;
      }
    } else {
      // When selecting individual outcome measures for evaluation
      tempOutcomeMeasures.clear();
      tempOutcomeMeasures = allOutcomeMeasures
          .where((elementA) =>
              !selectedOutcomeMeasures.any((elementB) => elementA == elementB))
          .toList();
    }
  }

  void selectOutcomeMeasure(OutcomeMeasure outcomeMeasure) {
    outcomeMeasure.isSelected = !outcomeMeasure.isSelected;

    if (outcomeMeasure.isSelected) {
      outcomeMeasureCollection != null
          ? outcomeMeasureCollection!.addOutcomeMeasure(outcomeMeasure)
          : _outcomeMeasureSelectionService.addOutcomeMeasure(outcomeMeasure.clone());
    } else {
      outcomeMeasureCollection != null
          ? outcomeMeasureCollection!.removeOutcomeMeasure(outcomeMeasure)
          : _outcomeMeasureSelectionService
              .removeOutcomeMeasure(outcomeMeasure);
    }

    notifyListeners();
  }

  void save() {
    outcomeMeasureCollection!.save();

    _navigationService.back();
  }

  void navigateToInfoBottomSheetView(OutcomeMeasure outcomeMeasure) {
    _navigationService.navigateTo(
        BottomSheetNavigatorViewRoutes.outcomeMeasureInfoBottomSheetView,
        arguments: outcomeMeasure,
        id: 3);
  }

  void closeBottomSheet() {
    _navigationService.back();
  }

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_outcomeMeasureSelectionService];
}
