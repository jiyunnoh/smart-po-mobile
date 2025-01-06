import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import '../../constants/app_strings.dart';
import '../../generated/locale_keys.g.dart';
import '../chart_data.dart';
import '../question.dart';
import 'outcome_measure.dart';

class Tug extends OutcomeMeasure {
  double? _elapsedTime;

  double get elapsedTime {
    if (_elapsedTime != null) {
      return _elapsedTime!;
    } else {
      Duration? elapsedTime =
          questionCollection.getQuestionById('${id}_1')?.value;
      if (elapsedTime != null) {
        return elapsedTime.inMilliseconds.toDouble() / 1000;
      } else {
        return 999;
      }
    }
  }

  late String rawData;

  @override
  Map<String, dynamic> get totalScore =>
      {'elapsedTime': elapsedTime.toStringAsFixed(2)};

  Tug({required super.id, super.data});

  factory Tug.fromJson(Map<String, dynamic> data) {
    Tug tug = Tug(id: ksTug);
    tug.populateWithJson(data);
    return tug;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _elapsedTime = json['${id}_elapsed_time'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _elapsedTime!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_elapsed_time": elapsedTime,
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  @override
  bool canProceed() {
    if (questionCollection.getQuestionById('tug_1')!.value == null) {
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
  double calculateScore() {
    rawValue = elapsedTime;

    double result;
    double elapsedTimeInSec = elapsedTime;

    //Flip
    result = info.maxYValue -
        elapsedTimeInSec.clamp(info.minYValue, info.maxYValue) +
        info.minYValue;

    //Normalize
    result =
        (result - info.minYValue) * 100 / (info.maxYValue - info.minYValue);

    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(
        date: outcomeMeasureCreatedTime!,
        dataList: [ChartData(label: 'Value', value: elapsedTime)]);
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
  String? get templateId => ksTugTemplateId;

  @override
  Tug clone() {
    Tug tug = Tug(id: ksTug, data: coreDataToJson());
    return tug;
  }
}
