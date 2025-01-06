import 'dart:math';

import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

class OpusSwds extends OutcomeMeasure {
  static const int minDeviceScore = 11;
  static const int minServiceScore = 10;
  double? _deviceScore;
  double? _serviceScore;

  double get deviceScore => _deviceScore ?? double.parse(totalScore['score_0']);

  double get serviceScore =>
      _serviceScore ?? double.parse(totalScore['score_1']);
  late String rawData;

  OpusSwds({required super.id, super.data});

  @override
  Map<String, dynamic> get totalScore {
    String score_0;
    String score_1;
    num sum_0 = max(
        questionCollection.getQuestionsForScoreGroup(0).fold(0, (p, e) {
          return p + (5 - e.value);
        }),
        minDeviceScore);
    score_0 = (info.scoreLookupTable![0]["$sum_0"]).toString();
    num sum_1 = max(
        questionCollection.getQuestionsForScoreGroup(1).fold(0, (p, e) {
          return p + (5 - e.value);
        }),
        minServiceScore);
    score_1 = (info.scoreLookupTable![1]["$sum_1"]).toString();
    return {'score_0': score_0, 'score_1': score_1};
  }

  factory OpusSwds.fromJson(Map<String, dynamic> data) {
    OpusSwds opusSwds = OpusSwds(id: ksOpusSwds);
    opusSwds.populateWithJson(data);
    return opusSwds;
  }

  @override
  double calculateScore() {
    rawValue = deviceScore;

    // score is already 100 point base
    return deviceScore;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(date: outcomeMeasureCreatedTime!, dataList: [
      ChartData(label: 'Devices', value: _deviceScore),
      ChartData(label: 'Services', value: _serviceScore)
    ]);
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
  void populateWithJson(Map<String, dynamic> json) {
    _deviceScore = json['${id}_device_score'].toDouble();
    _serviceScore = json['${id}_service_score'].toDouble();
    index = json['${id}_order'];
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _deviceScore!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    numOfGraph = 2;
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_device_score": deviceScore,
      "${id}_service_score": serviceScore,
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString
    };
    return body;
  }

  @override
  String? get templateId => ksOpusSwdsTemplateId;

  @override
  OpusSwds clone() {
    OpusSwds opusSwds = OpusSwds(id: ksOpusSwds, data: coreDataToJson());
    return opusSwds;
  }
}
