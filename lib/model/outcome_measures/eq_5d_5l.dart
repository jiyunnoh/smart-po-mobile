import 'dart:convert';

import '../../constants/app_strings.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class Eq5d extends OutcomeMeasure {
  double? _healthScore;

  double get healthScore => _healthScore ?? double.parse(totalScore['score2']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    num? healthScore = questionCollection.getQuestionById('${id}_6')?.value;
    var result = _assembleHealthState();
    if (healthScore != null) {
      result.addAll({'score2': healthScore.toStringAsFixed(0)});
    } else {
      result.addAll({'score2': '999'});
    }
    return result;
  }

  Eq5d({required super.id, super.data});

  factory Eq5d.fromJson(Map<String, dynamic> data) {
    Eq5d eq5d = Eq5d(id: ksEq5d5l);
    eq5d.populateWithJson(data);
    return eq5d;
  }

  @override
  Eq5d clone() {
    Eq5d eq5d = Eq5d(id: ksEq5d5l, data: coreDataToJson());
    return eq5d;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _healthScore = json['${id}_health_score'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _healthScore!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_health_score": healthScore,
      "${id}_patient": {"id": patient.entityId},
      "${id}_order": index,
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  @override
  Map<String, dynamic> exportResponses(String locale) {
    Map<String, dynamic> responses = {};
    for (var element in questionCollection.questions) {
      if (element.exportResponse != null) {
        responses.addAll(element.exportResponse!);
      }
    }
    responses.addAll(_assembleHealthState());
    return responses;
  }

  Map<String, String> _assembleHealthState() {
    String healthState =
        questionCollection.getQuestionsForScoreGroup(0).fold('', (p, e) {
      return e.value == null || p == '999'
          ? p = '999'
          : p + (e.value + 1).toString();
    });
    return {'score1': healthState};
  }

  @override
  double calculateScore() {
    rawValue = healthScore;

    double result;
    result = (healthScore - info.minYValue) *
        100 /
        (info.maxYValue - info.minYValue);
    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(
        date: outcomeMeasureCreatedTime!,
        dataList: [ChartData(label: 'Value', value: healthScore)]);
  }

  @override
  String? get templateId => ksEq5dTemplateId;
}
