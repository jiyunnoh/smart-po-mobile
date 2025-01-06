import 'package:biot/app/app.locator.dart';
import 'package:biot/services/cloud_service.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../model/peripheral_device.dart';

class SensorSummaryViewModel extends FutureViewModel {
  final _apiService = locator<BiotService>();

  final PeripheralDevice encounter;

  SensorSummaryViewModel({required this.encounter});

  @override
  Future<void> futureToRun() {
    return _apiService.getUsageSession(http.Client(),
        usageSessionId: encounter.id!);
  }

  void downloadFile() {
    _apiService.downloadFile(fileId: data.rawDataId);
  }
}
