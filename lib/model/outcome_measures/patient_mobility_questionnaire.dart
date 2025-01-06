import 'dart:convert';

import '../../constants/app_strings.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class Pmq extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    num sum = questionCollection.questions.fold(0, (p, e) {
      return e.value == null ? p : p + e.value;
    });
    var score = info.scoreLookupTable?.first["$sum"];
    return {'score': '$score'};
  }

  Pmq({required super.id, super.data});

  factory Pmq.fromJson(Map<String, dynamic> data) {
    Pmq pmq = Pmq(id: ksPmq);
    pmq.populateWithJson(data);
    return pmq;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    summaryDataToBeModified = summary();
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
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
      "${id}_raw_data": json.encode(questionCollection.toJson())
    };

    return body;
  }

  @override
  List<Map<String, String>> summary() {
    List<Map<String, String>> summary = [];
    summary.add({'key': ksTotalScore, 'value': _score.toString()});
    return summary;
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
  String? get templateId => ksPmqTemplateId;

  @override
  Pmq clone() {
    Pmq pmq = Pmq(id: ksPmq, data: coreDataToJson());
    return pmq;
  }
}
