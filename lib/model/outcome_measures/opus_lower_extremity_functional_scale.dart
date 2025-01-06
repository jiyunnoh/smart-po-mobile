import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

class OpusLefs extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  OpusLefs({required super.id, super.data});

  @override
  Map<String, dynamic> get totalScore {
    String score;
    num sum = questionCollection.getQuestionsForScoreGroup(0).fold(0, (p, e) {
      return p + (4 - e.value);
    });
    score = info.scoreLookupTable!.first["$sum"].toString();
    return {'score': score};
  }

  factory OpusLefs.fromJson(Map<String, dynamic> data) {
    OpusLefs opusLefs = OpusLefs(id: ksOpusLefs);
    opusLefs.populateWithJson(data);
    return opusLefs;
  }

  @override
  double calculateScore() {
    rawValue = score;

    // score is already 100 point base
    return score;
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
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    index = json['${id}_order'];
    patientId = json['${id}_patient']['id'];
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
      "_templateId": templateId,
      "_ownerOrganization": {"id": ownerOrganizationId},
      "${id}_score": score,
      "${id}_order": index,
      "${id}_patient": {"id": patient.entityId},
      "${id}_created_time": outcomeMeasureCreatedTimeString
    };
    return body;
  }

  @override
  String? get templateId => ksOpusLefsTemplateId;

  @override
  OutcomeMeasure clone() {
    OpusLefs opusLefs = OpusLefs(id: ksOpusLefs, data: coreDataToJson());
    return opusLefs;
  }
}
