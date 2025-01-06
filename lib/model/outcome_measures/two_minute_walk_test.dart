import 'dart:convert';
import 'dart:math';

import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';
import '../question.dart';

class Tminwt extends OutcomeMeasure {
  double? _distance;

  double get distance => _distance ?? double.parse(totalScore['distance']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    num? distance = questionCollection.getQuestionById('${id}_1')?.value;
    if (distance != null) {
      return {
        'distance': distance.toStringAsFixed(2),
      };
    } else {
      return {
        'distance': "999.99",
      };
    }
  }

  Tminwt({required super.id, super.data});

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
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_distance": distance,
      "${id}_patient": {"id": patient.entityId},
      "${id}_order": index,
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  factory Tminwt.fromJson(Map<String, dynamic> data) {
    Tminwt tminwt = Tminwt(id: ksTminwt);
    tminwt.populateWithJson(data);
    return tminwt;
  }

  @override
  bool canProceed() {
    if (questionCollection.getQuestionById('tminwt_1')!.value == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Map<String, dynamic> exportResponses(String locale) {
    Map<String, dynamic> responses = {};
    Question q1 = questionCollection.getQuestionById('${id}_1')!;
    Question q2 = questionCollection.getQuestionById('${id}_2')!;
    if (q1.value != null) {
      responses.addAll(q1.exportResponse!);
    }
    responses.addAll({
      '${id}_2': q2.value == null ? LocaleKeys.noneReported.tr() : '${q2.value}'
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
  String? get templateId => ksTminwtTemplateId;

  @override
  Tminwt clone() {
    Tminwt tminwt = Tminwt(id: ksTminwt, data: coreDataToJson());
    return tminwt;
  }
}
