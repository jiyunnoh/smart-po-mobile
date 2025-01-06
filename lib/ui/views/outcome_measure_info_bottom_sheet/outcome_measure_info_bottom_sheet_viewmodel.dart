import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class OutcomeMeasureInfoBottomSheetViewModel extends FutureViewModel {
  final _navigationService = locator<NavigationService>();

  final OutcomeMeasure outcomeMeasure;

  OutcomeMeasureInfoBottomSheetViewModel({required this.outcomeMeasure});

  void closeBottomSheet() {
    _navigationService.back();
  }

  @override
  Future futureToRun() async {
    return outcomeMeasure.buildInfo();
  }
}
