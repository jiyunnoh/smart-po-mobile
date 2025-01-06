import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../model/patient.dart';
import '../../../services/database_service.dart';

class ComparisonSelectDialogModel extends BaseViewModel {
  final _localdbService = locator<DatabaseService>();

  Patient? get currentPatient => _localdbService.currentPatient?.value;

  List<bool> isSelectedEncounter = [];
  List<bool> tempIsSelectedEncounter = [];
}
