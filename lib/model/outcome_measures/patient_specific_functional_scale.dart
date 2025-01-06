import 'dart:convert';

import 'package:biot/model/outcome_measures/outcome_measure.dart';

import '../../constants/app_strings.dart';
import '../chart_data.dart';
import '../question.dart';

class Psfs extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  int get _totalValidAnswers {
    int total = 0;
    if (questionCollection.numOfAnsweredQuestions != 0) {
      for (Question question in questionCollection.questions) {
        QuestionWithDiscreteScaleTextResponse q =
            question as QuestionWithDiscreteScaleTextResponse;
        if (q.value != null && q.textResponse != '') {
          total += 1;
        }
      }
    }
    return total;
  }

  @override
  Map<String, dynamic> get totalScore {
    String score;
    double sum = questionCollection.questions.fold(0, (p, e) {
      QuestionWithDiscreteScaleTextResponse q =
          e as QuestionWithDiscreteScaleTextResponse;
      if (q.value != null && q.textResponse != '') {
        return p + q.value;
      } else {
        return p;
      }
    });
    score = (sum / _totalValidAnswers).toStringAsFixed(1);
    return {'score': score};
  }

  Psfs({required super.id, super.data});

  factory Psfs.fromJson(Map<String, dynamic> data) {
    Psfs psfs = Psfs(id: ksPsfs);
    psfs.populateWithJson(data);
    return psfs;
  }

  @override
  Psfs clone() {
    Psfs psfs = Psfs(id: ksPsfs, data: coreDataToJson());
    return psfs;
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
      "${id}_raw_data": json.encode(exportResponses('en')),
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString
    };
    return body;
  }

  @override
  bool canProceed() {
    return isComplete || _totalValidAnswers > 0;
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
  double? normalizeSigDiffPositive() {
    return info.sigDiffPositive! * 100 / (info.maxYValue - info.minYValue);
  }

  @override
  double? normalizeSigDiffNegative() {
    return info.sigDiffNegative! * 100 / (info.maxYValue - info.minYValue);
  }

  @override
  String? get templateId => ksPsfsTemplateId;

  (String, double) get firstQuestionResponse {
    QuestionWithDiscreteScaleTextResponse q = questionCollection.questions[0]
        as QuestionWithDiscreteScaleTextResponse;
    return (q.textResponse, q.value);
  }
}
