import '../../constants/app_strings.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class Nprs extends OutcomeMeasure {
  double? _score;

  double get score => _score ?? double.parse(totalScore['score']);
  late String rawData;

  @override
  Map<String, dynamic> get totalScore {
    String score;
    if (questionCollection.skippedQuestionsForScoreGroup(0) == 0) {
      double sum = (questionCollection.questions.fold(0, (p, e) {
        return p + e.value;
      }));
      score = (sum / questionCollection.totalQuestions).toStringAsFixed(1);
    } else {
      score = 'N/A';
    }
    return {'score': score};
  }

  Nprs({required super.id, super.data});

  factory Nprs.fromJson(Map<String, dynamic> data) {
    Nprs nprs = Nprs(id: ksNprs);
    nprs.populateWithJson(data);
    return nprs;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    _score = json['${id}_score'].toDouble();
    index = json['${id}_order'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = _score!;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    String patientName =
        '${patient.lastName[0]}${patient.firstName[0]}'.toLowerCase();

    Map<String, dynamic> body = {
      "_name": "${patientName}_${id}_$currentTime",
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
  double calculateScore() {
    rawValue = score;

    double result;
    //Flip
    result = info.maxYValue - score + info.minYValue;

    //Normalize
    result =
        (result - info.minYValue) * 100 / (info.maxYValue - info.minYValue);
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
  String? get templateId => ksNprsTemplateId;

  @override
  Nprs clone() {
    Nprs nprs = Nprs(id: ksNprs, data: coreDataToJson());
    return nprs;
  }
}
