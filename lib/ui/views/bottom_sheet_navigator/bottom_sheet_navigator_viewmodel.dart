import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/outcome_measure_load_service.dart';

class BottomSheetNavigatorViewModel extends BaseViewModel {
  final _outcomeMeasureLoadService = locator<OutcomeMeasureLoadService>();

  bool get isCollectionEditing =>
      _outcomeMeasureLoadService.defaultOutcomeMeasureCollections
          .any((element) => element.isEditing);
}
