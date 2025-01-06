import 'dart:convert';

import '../../constants/app_strings.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class TapesR extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['tapes_r_34']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    num psychosocial = 999;
    num activity = 999;
    num satisfaction = 999;
    num generalSatisfaction = 999;

    //Score for Psychosocial Adjustment (score group 0 and 1)
    num generalAdjSum =
        questionCollection.getQuestionsForScoreGroup(0).fold(0, (p, e) {
      return e.value == null || e.value == 4 ? p : p + e.value + 1;
    });

    num adjToLimitSum =
        questionCollection.getQuestionsForScoreGroup(1).fold(0, (p, e) {
      return e.value == null || e.value == 4 ? p : p + (4 - e.value);
    });

    // number of valid responses in first 15 questions.
    int numValidResponsesForScoreGroup0 = questionCollection
        .getQuestionsForScoreGroup(0)
        .where((e) => e.value != null && e.value != 4)
        .toList()
        .length;
    int numValidResponsesForScoreGroup1 = questionCollection
        .getQuestionsForScoreGroup(1)
        .where((e) => e.value != null && e.value != 4)
        .toList()
        .length;
    if (numValidResponsesForScoreGroup0 + numValidResponsesForScoreGroup1 !=
        0) {
      psychosocial = (generalAdjSum + adjToLimitSum) /
          (numValidResponsesForScoreGroup0 + numValidResponsesForScoreGroup1);
    }

    //Score for Activity Restriction (score group 2)
    num activitySum =
        questionCollection.getQuestionsForScoreGroup(2).fold(0, (p, e) {
      return e.value == null || e.value == 3 ? p : p + (2 - e.value);
    });
    int numValidResponses = questionCollection
        .getQuestionsForScoreGroup(2)
        .where((e) => e.value != null && e.value != 3)
        .toList()
        .length;
    if (numValidResponses != 0) {
      activity = activitySum / numValidResponses;
    }

    //Score for Aesthetic Satisfaction (score group 3)
    num satisfactionSum =
        questionCollection.getQuestionsForScoreGroup(3).fold(0, (p, e) {
      return e.value == null ? p : p + e.value + 1;
    });
    numValidResponses = questionCollection
        .getQuestionsForScoreGroup(3)
        .where((e) => e.value != null)
        .toList()
        .length;
    if (numValidResponses != 0) {
      satisfaction = satisfactionSum / numValidResponses;
    }

    generalSatisfaction =
        questionCollection.getQuestionById('tapes_r_34')!.value ?? 999;
    return {
      'score1': psychosocial == 999
          ? psychosocial.toString()
          : psychosocial.toStringAsFixed(1),
      'score2':
          activity == 999 ? activity.toString() : activity.toStringAsFixed(1),
      'score3': satisfaction == 999
          ? satisfaction.toString()
          : satisfaction.toStringAsFixed(1),
      'tapes_r_34': generalSatisfaction == 999
          ? generalSatisfaction.toString()
          : generalSatisfaction.toStringAsFixed(0)
    };
  }

  TapesR({required super.id, super.data});

  factory TapesR.fromJson(Map<String, dynamic> data) {
    TapesR tapesR = TapesR(id: ksTapesR);
    tapesR.populateWithJson(data);
    return tapesR;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _score = (json['${id}_score'] as int).toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _score!.toDouble();
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": ksTapesRTemplateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_score": score.toInt(),
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
    responses.addAll(totalScore);
    return responses;
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
  String? get templateId => ksTapesRTemplateId;

  @override
  TapesR clone() {
    TapesR tapesR = TapesR(id: ksTapesR, data: coreDataToJson());
    return tapesR;
  }
}
