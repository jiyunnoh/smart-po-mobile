import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

class Oms extends OutcomeMeasure {
  late double score;
  late String rawData;

  Oms({required super.id, super.data});

  factory Oms.fromJson(Map<String, dynamic> data) {
    Oms oms = Oms(id: ksOms);
    return oms;
  }

  @override
  double calculateScore() {
    // TODO: implement normalizeScore
    throw UnimplementedError();
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    // TODO: implement outcomeMeasureChartData
    throw UnimplementedError();
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    // TODO: implement populateWithJson
  }

  @override
  List<Map<String, String>> summary() {
    // TODO: implement summary
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement templateId
  String? get templateId => ksTmwtTemplateId;

  @override
  OutcomeMeasure clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }
}
