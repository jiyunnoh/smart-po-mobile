import 'dart:convert';
import 'dart:math';

import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

import '../../constants/app_strings.dart';

class Fh extends OutcomeMeasure {
  double? _fallsPerWeek;
  late String rawData;

  double get fallsPerWeek {
    if (_fallsPerWeek == null) {
      int q1Value = questionCollection.getQuestionById('${id}_1')!.value;
      double q2Value = questionCollection.getQuestionById('${id}_2')!.value;

      if (q1Value == 0) {
        return q2Value / 4;
      } else {
        return q2Value / 26;
      }
    } else {
      return _fallsPerWeek!;
    }
  }

  @override
  Map<String, String> get totalScore {
    double totalFalls = questionCollection.getQuestionById('${id}_2')!.value;
    double injuriousFalls =
        questionCollection.getQuestionById('${id}_3')!.value;
    return {
      '${id}_2': totalFalls.toStringAsFixed(0),
      '${id}_3': injuriousFalls.toStringAsFixed(0)
    };
  }

  Fh({required super.id, super.data});

  factory Fh.fromJson(Map<String, dynamic> data) {
    Fh fh = Fh(id: ksFh);
    fh.populateWithJson(data);
    return fh;
  }

  @override
  Fh clone() {
    Fh fh = Fh(id: ksFh, data: coreDataToJson());
    return fh;
  }

  @override
  Map<String, dynamic> exportResponses(String locale) {
    Map<String, dynamic> responses = {};
    int q1Value = questionCollection.getQuestionById('${id}_1')!.value;
    responses.addAll({'${id}_1': '${q1Value == 0 ? "4 Weeks" : "6 Months"}}'});
    responses.addAll(totalScore);
    return responses;
  }

  @override
  double calculateScore() {
    rawValue = fallsPerWeek;

    double result;
    double minFallsPerWeek = min(fallsPerWeek, info.maxYValue);

    //Flip
    result = info.maxYValue - minFallsPerWeek + info.minYValue;

    result =
        (result - info.minYValue) * 100 / (info.maxYValue - info.minYValue);
    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(
        date: outcomeMeasureCreatedTime!,
        dataList: [ChartData(label: 'Value', value: fallsPerWeek)]);
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _fallsPerWeek = json['falls_per_week'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _fallsPerWeek!;
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
      "falls_per_week": fallsPerWeek,
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  @override
  String getSummaryScoreTitle(int index) {
    String summaryScoreTitle = info.summaryScore![index];
    if (index == 0) {
      int lastVisit = questionCollection.getQuestionById('${id}_1')?.value;
      String duration = lastVisit == 0 ? '4 Weeks' : '6 Months';
      String reportedFallsTitle =
          summaryScoreTitle.replaceAll('{duration}', duration);
      summaryScoreTitle = reportedFallsTitle;
    }
    return summaryScoreTitle;
  }

  @override
  String? get templateId => ksFhTemplateId;
}
