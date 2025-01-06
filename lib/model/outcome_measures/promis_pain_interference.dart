import 'dart:convert';

import '../../constants/app_strings.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class Promispi extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    num sum = questionCollection.questions.fold(0, (p, e) {
      return e.value == null ? p : p + e.value + 1;
    });

    double score = info.scoreLookupTable!.first["$sum"] ?? 999;
    return {'score': '$score'};
  }

  Promispi({required super.id, super.data});

  factory Promispi.fromJson(Map<String, dynamic> data) {
    Promispi promispi = Promispi(id: ksPromispi);
    promispi.populateWithJson(data);
    return promispi;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
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
  double calculateScore() {
    rawValue = score;

    double result;
    //Flip
    result = info.maxYValue - score + info.minYValue;

    //Normalize
    result =
        (result - info.minYValue) * 100 / (info.maxYValue - info.minYValue);

    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(
        date: outcomeMeasureCreatedTime!,
        dataList: [ChartData(label: 'Value', value: score)]);
  }

  @override
  double? normalizeSigDiffPositive() {
    return info.sigDiffPositive! * 100 / (info.maxYValue - info.minYValue);
  }

  @override
  double? normalizeSigDiffNegative() {
    return info.sigDiffNegative! * 100 / (info.maxYValue - info.minYValue);
  }

  @override
  String? get templateId => ksPromispiTemplateId;

  @override
  Promispi clone() {
    Promispi promispi = Promispi(id: ksPromispi, data: coreDataToJson());
    return promispi;
  }
}
