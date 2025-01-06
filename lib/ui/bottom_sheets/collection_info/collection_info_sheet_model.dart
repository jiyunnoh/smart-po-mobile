import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class CollectionInfoSheetModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void closeBottomSheet() {
    _navigationService.back();
  }
}
