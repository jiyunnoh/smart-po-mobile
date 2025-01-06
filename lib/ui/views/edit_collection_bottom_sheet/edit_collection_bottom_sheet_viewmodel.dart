import 'package:biot/app/app.router.dart';
import 'package:biot/model/outcome_measure_collection.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/services/outcome_measure_selection_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../services/outcome_measure_load_service.dart';

class EditCollectionBottomSheetViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _outcomeMeasureLoadService = locator<OutcomeMeasureLoadService>();
  final _outcomeMeasureSelectionService =
      locator<OutcomeMeasureSelectionService>();

  OutcomeMeasureCollection get outcomeMeasureCollection =>
      _outcomeMeasureLoadService.defaultOutcomeMeasureCollections
          .singleWhere((element) => element.isEditing);

  List<OutcomeMeasure> get tempOutcomeMeasuresFromCollection =>
      outcomeMeasureCollection.tempOutcomeMeasures;

  void removeOutcomeMeasureFromCollection(OutcomeMeasure outcomeMeasure) {
    outcomeMeasureCollection.removeOutcomeMeasure(outcomeMeasure);
    notifyListeners();
  }

  void save() {
    outcomeMeasureCollection.save();

    _navigationService.back();
  }

  Future<void> navigateToAddOutcomeMeasureBottomSheetView() async {
    await _navigationService.navigateTo(
        BottomSheetNavigatorViewRoutes.addOutcomeMeasureBottomSheetView,
        arguments: outcomeMeasureCollection,
        id: 3);

    notifyListeners();
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
