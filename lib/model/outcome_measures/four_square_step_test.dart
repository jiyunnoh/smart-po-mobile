import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

class Fsst extends OutcomeMeasure {
  late double score;
  late String rawData;

  @override
  Map<String, String> get totalScore {
    Duration trial1Time =
        questionCollection.getQuestionById('${id}_1')!.value as Duration;
    Duration trial2Time =
        questionCollection.getQuestionById('${id}_2')!.value as Duration;
    Duration fastest = trial1Time <= trial2Time ? trial1Time : trial2Time;
    return {'${id}_sec': (fastest.inMilliseconds / 1000).toStringAsFixed(2)};
  }

  Fsst({required super.id, super.data});

  factory Fsst.fromJson(Map<String, dynamic> data) {
    Fsst fsst = Fsst(id: ksFsst);
    return fsst;
  }

  @override
  bool canProceed() {
    if (questionCollection.getQuestionById('fsst_1')!.value ==
            const Duration() ||
        questionCollection.getQuestionById('fsst_2')!.value ==
            const Duration()) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Map<String, dynamic> exportResponses(String locale) {
    Map<String, dynamic> responses = {};
    bool? didRepeat = questionCollection.getQuestionById('${id}_3')?.value;
    String? assistedDeviceUsed =
        questionCollection.getQuestionById('${id}_4')?.value as String?;
    bool? didFaceForward = questionCollection.getQuestionById('${id}_5')?.value;
    responses.addAll(totalScore);
    if (didRepeat != null) {
      didRepeat
          ? responses.addAll({'${id}_3_0': 'Yes'})
          : responses.addAll({'${id}_3_1': 'Yes'});
    }
    responses.addAll(
        {'${id}_4': assistedDeviceUsed ?? LocaleKeys.noneReported.tr()});
    if (didFaceForward != null) {
      didFaceForward
          ? responses.addAll({'${id}_5_0': 'Yes'})
          : responses.addAll({'${id}_5_1': 'Yes'});
    }
    return responses;
  }

  @override
  double calculateScore() {
    // TODO: implement normalizeScore
    throw UnimplementedError();
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    // TODO: implement outcomeMeasureChartData
    throw UnimplementedError();
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    // TODO: implement populateWithJson
  }

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement templateId
  String? get templateId => ksTminwtTemplateId;

  @override
  OutcomeMeasure clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }
}
