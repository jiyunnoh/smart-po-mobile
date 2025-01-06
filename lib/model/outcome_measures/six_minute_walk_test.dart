import 'dart:convert';
import 'dart:math';

import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';
import '../question.dart';

class Sminwt extends OutcomeMeasure {
  double? _distance;

  double get distance => _distance ?? double.parse(totalScore['distance']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    double distance = questionCollection.getQuestionById('${id}_1')!.value;
    return {
      'distance': distance.toStringAsFixed(2),
    };
  }

  Sminwt({required super.id, super.data});

  @override
  double calculateScore() {
    rawValue = distance;

    // Normalize
    double result = (min<double>(distance, info.maxYValue) - info.minYValue) *
        100 /
        (info.maxYValue - info.minYValue);
    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(
        date: outcomeMeasureCreatedTime!,
        dataList: [ChartData(label: 'Distance', value: distance)]);
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _distance = json['${id}_distance'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _distance!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": ksSminwtTemplateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_distance": distance,
      "${id}_patient": {"id": patient.entityId},
      "${id}_order": index,
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  factory Sminwt.fromJson(Map<String, dynamic> data) {
    Sminwt sminwt = Sminwt(id: ksSminwt);
    sminwt.populateWithJson(data);
    return sminwt;
  }

  @override
  Map<String, dynamic> exportResponses(String locale) {
    Map<String, dynamic> responses = {};
    Question q1 = questionCollection.getQuestionById('sminwt_1')!;
    Question q2 = questionCollection.getQuestionById('sminwt_2')!;
    if (q1.value != null) {
      responses.addAll(q1.exportResponse!);
    }
    responses.addAll({
      'sminwt_2':
          q2.value == null ? LocaleKeys.noneReported.tr() : '${q2.value}'
    });
    return responses;
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
  String? get templateId => ksSminwtTemplateId;

  @override
  Sminwt clone() {
    Sminwt sminwt = Sminwt(id: ksSminwt, data: coreDataToJson());
    return sminwt;
  }
}
