import 'dart:convert';
import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/patient.dart';
import 'package:biot/model/question.dart';
import '../../constants/enum.dart';
import 'outcome_measure.dart';

class PeqUt extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    double score;
    if (questionCollection.skippedQuestionsForScoreGroup(0) <
        (questionCollection.totalQuestions / 2).round()) {
      num sum = (questionCollection.questions.fold(0, (p, e) {
        return p + e.value;
      }));
      score = (sum / questionCollection.totalQuestions);
    } else {
      score = 999;
    }
    return {'score': score.toStringAsFixed(1)};
  }

  PeqUt({required super.id, super.data});

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
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _score!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": ksPeqUtTemplateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_score": score,
      "${id}_patient": {"id": patient.entityId},
      "${id}_order": index,
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  factory PeqUt.fromJson(Map<String, dynamic> data) {
    PeqUt peqUt = PeqUt(id: ksPeqUt);
    peqUt.populateWithJson(data);
    return peqUt;
  }

  @override
  PeqUt clone() {
    PeqUt peqUt = PeqUt(id: ksPeqUt, data: coreDataToJson());
    return peqUt;
  }

  @override
  String? get templateId => ksPeqUtTemplateId;
}

class PeqRl extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  PeqRl({required super.id, super.data});

  @override
  Map<String, dynamic> get totalScore {
    double score;
    if (questionCollection.skippedQuestionsForScoreGroup(0) <
        (questionCollection.totalQuestions / 2).round()) {
      num sum = 0;
      for (var question in questionCollection.questions) {
        if (question.type == QuestionType.vas) {
          sum += question.value;
        } else {
          QuestionWithVasCheckboxResponse q =
              question as QuestionWithVasCheckboxResponse;
          sum += (q.isChecked ? 100 : q.value);
        }
      }
      score = (sum / questionCollection.totalQuestions);
    } else {
      score = 999;
    }
    return {'score': score.toStringAsFixed(1)};
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
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _score!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": ksPeqRlTemplateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_score": score,
      "${id}_patient": {"id": patient.entityId},
      "${id}_order": index,
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  factory PeqRl.fromJson(Map<String, dynamic> data) {
    PeqRl peqRl = PeqRl(id: ksPeqRl);
    peqRl.populateWithJson(data);
    return peqRl;
  }

  @override
  String? get templateId => ksPeqRlTemplateId;

  @override
  PeqRl clone() {
    PeqRl peqRl = PeqRl(id: ksPeqRl, data: coreDataToJson());
    return peqRl;
  }
}
