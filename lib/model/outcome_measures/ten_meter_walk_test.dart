import 'dart:convert';
import 'dart:ui';

import 'package:biot/services/app_locale_service.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../app/app.locator.dart';
import '../../constants/app_strings.dart';
import '../../generated/locale_keys.g.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class Tmwt extends OutcomeMeasure {
  double? _comfortableSpeed;
  double? _maximumSpeed;

  double get comfortableSpeed =>
      _comfortableSpeed ?? double.parse(totalScore['${id}_comfort']);

  double get maximumSpeed =>
      _maximumSpeed ?? double.parse(totalScore['${id}_max']);
  late String rawData;

  final _localeService = locator<AppLocaleService>();

  @override
  Map<String, dynamic> get totalScore {
    int actualDistanceTimed =
        int.parse(questionCollection.getQuestionById('${id}_7')!.value);
    Duration comfTrial1Time =
        questionCollection.getQuestionById('${id}_1')!.value as Duration;
    Duration comfTrial2Time =
        questionCollection.getQuestionById('${id}_2')!.value as Duration;
    Duration maxTrial1Time =
        questionCollection.getQuestionById('${id}_3')!.value as Duration;
    Duration maxTrial2Time =
        questionCollection.getQuestionById('${id}_4')!.value as Duration;
    double avgComfTrialTime =
        (comfTrial1Time.inMilliseconds + comfTrial2Time.inMilliseconds) / 2000;
    double avgMaxTrialTime =
        (maxTrial1Time.inMilliseconds + maxTrial2Time.inMilliseconds) / 2000;
    double comfTrialSpeed = actualDistanceTimed / avgComfTrialTime;
    double maxTrialSpeed = actualDistanceTimed / avgMaxTrialTime;
    String assistanceLevel =
        questionCollection.getQuestionById('${id}_6')!.value as String;
    if (assistanceLevel == "Total assistance") {
      comfTrialSpeed = 0.0;
      maxTrialSpeed = 0.0;
    }
    return {
      '${id}_comfort': comfTrialSpeed.toStringAsFixed(2),
      '${id}_max': maxTrialSpeed.toStringAsFixed(2)
    };
  }

  Tmwt({required super.id, super.data});

  factory Tmwt.fromJson(Map<String, dynamic> data) {
    Tmwt tmwt = Tmwt(id: ksTmwt);
    tmwt.populateWithJson(data);
    return tmwt;
  }

  @override
  populateWithJson(Map<String, dynamic> json) {
    _comfortableSpeed = json['comfortable_speed'].toDouble();
    _maximumSpeed = json['maximum_speed'].toDouble();
    rawData = json['${id}_raw_data'];
    index = json['${id}_order'];
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _comfortableSpeed!;
    numOfGraph = 2;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    Map<String, dynamic> body = {
      "_name": "${patient.initial}_${id}_$currentTime",
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "comfortable_speed": comfortableSpeed,
      "maximum_speed": maximumSpeed,
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString,
      "${id}_raw_data": json.encode(exportResponses('en'))
    };
    return body;
  }

  @override
  bool canProceed() {
    if (questionCollection
                .getQuestionById('tmwt_1')!
                .value ==
            const Duration() ||
        questionCollection
                .getQuestionById('tmwt_2')!
                .value ==
            const Duration() ||
        questionCollection
                .getQuestionById('tmwt_3')!
                .value ==
            const Duration() ||
        questionCollection.getQuestionById('tmwt_4')!.value ==
            const Duration() ||
        questionCollection.getQuestionById('tmwt_6')!.value == null ||
        questionCollection.getQuestionById('tmwt_7')!.value == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Map<String, dynamic> exportResponses(String locale) {
    Map<String, dynamic> responses = {};
    String? assistedDeviceUsed =
        questionCollection.getQuestionById('${id}_5')?.value as String?;
    String assistanceLevel =
        questionCollection.getQuestionById('${id}_6')!.value as String;
    assistanceLevel = _localeService.tr(Locale(locale), assistanceLevel);
    String actualDistanceTimed =
        questionCollection.getQuestionById('${id}_7')!.value as String;
    responses.addAll(
        {'${id}_5': assistedDeviceUsed ?? LocaleKeys.noneReported.tr()});
    responses.addAll({"${id}_6": assistanceLevel});
    responses.addAll({"${id}_7": actualDistanceTimed});
    responses.addAll(totalScore);
    return responses;
  }

  @override
  double calculateScore() {
    rawValue = comfortableSpeed;

    double result;

    // Normalize
    result = (comfortableSpeed.clamp(info.minYValue, info.maxYValue) -
            info.minYValue) *
        100 /
        (info.maxYValue - info.minYValue);

    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(date: outcomeMeasureCreatedTime!, dataList: [
      ChartData(label: 'Comfortable', value: comfortableSpeed),
      ChartData(label: 'Maximum', value: maximumSpeed)
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
  String? get templateId => ksTmwtTemplateId;

  @override
  Tmwt clone() {
    Tmwt tmwt = Tmwt(id: ksTmwt, data: coreDataToJson());
    return tmwt;
  }
}
