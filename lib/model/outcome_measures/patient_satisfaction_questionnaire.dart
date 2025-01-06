import 'dart:convert';

import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import '../question.dart';
import 'outcome_measure.dart';

class Psq extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    String score;
    final numValidResponses = questionCollection
        .getQuestionsForScoreGroup(0)
        .where((e) => e.value != null)
        .toList()
        .length;
    if (numValidResponses == 0) {
      score = 'N/A';
    } else {
      final double sum =
          questionCollection.getQuestionsForScoreGroup(0).fold(0, (p, element) {
        try {
          QuestionWithRadialResponse q = element as QuestionWithRadialResponse;
          return q.value == null
              ? p
              : p + ((q.options.length - 1 - q.value) / (q.options.length - 1));
        } catch (e) {
          QuestionWithRadialCheckBoxResponse q =
              element as QuestionWithRadialCheckBoxResponse;
          return q.value == null
              ? p
              : p + ((q.options.length - 1 - q.value) / (q.options.length - 1));
        }
      });

      score = ((sum.toDouble() / numValidResponses) * 100).toStringAsFixed(1);
    }
    return {'score': score};
  }

  Psq({required super.id, super.data});

  factory Psq.fromJson(Map<String, dynamic> data) {
    Psq psq = Psq(id: ksPsq);
    psq.populateWithJson(data);
    return psq;
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
  String? get templateId => ksPsqTemplateId;

  @override
  Psq clone() {
    Psq psq = Psq(id: ksPsq, data: coreDataToJson());
    return psq;
  }
}
