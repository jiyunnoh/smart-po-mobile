import 'package:stacked/stacked.dart';

import '../../../model/outcome_measures/outcome_measure.dart';

class OutcomeMeasureSelectEditDialogModel extends BaseViewModel {
  List<OutcomeMeasure> outcomeMeasures;
  OutcomeMeasureSelectEditDialogModel(this.outcomeMeasures);

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final OutcomeMeasure om = outcomeMeasures.removeAt(oldIndex);
    outcomeMeasures.insert(newIndex, om);
    notifyListeners();
  }

  void onRemove(int index) {
    outcomeMeasures.removeAt(index);
    notifyListeners();
  }
}
