import 'dart:convert';

import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';

import '../../constants/app_strings.dart';

class Scs extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(exportResponses('en')['${id}_1']);
  late String rawData;

  Scs({required super.id, super.data});

  factory Scs.fromJson(Map<String, dynamic> data) {
    Scs scs = Scs(id: ksScs);
    scs.populateWithJson(data);
    return scs;
  }

  @override
  Scs clone() {
    Scs scs = Scs(id: ksScs, data: coreDataToJson());
    return scs;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    index = json['${id}_order'];
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawData = json['${id}_raw_data'];
    rawValue = _score!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_score": score,
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };

    return body;
  }

  @override
  double calculateScore() {
    rawValue = score;

    double result;
    result = (score - info.minYValue) * 100 / (info.maxYValue - info.minYValue);
    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(
        date: outcomeMeasureCreatedTime!,
        dataList: [ChartData(label: 'Value', value: score)]);
  }

  @override
  String? get templateId => ksScsTemplateId;
}
