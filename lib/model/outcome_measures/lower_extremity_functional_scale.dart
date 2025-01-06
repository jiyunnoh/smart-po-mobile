import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

class Lefs extends OutcomeMeasure {
  late double score;
  late String rawData;

  Lefs({required super.id, super.data});

  @override
  Map<String, String> get totalScore {
    String score;
    if (questionCollection.skippedQuestionsForScoreGroup(0) == 0) {
      num sum = questionCollection.questions.fold(0, (p, e) {
        return e.value == null ? p : p + e.value;
      });
      score = sum.toString();
    } else {
      score = 'N/A';
    }
    return {'score': score};
  }

  factory Lefs.fromJson(Map<String, dynamic> data) {
    Lefs dash = Lefs(id: ksDash);
    return dash;
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
  List<Map<String, String>> summary() {
    // TODO: implement summary
    throw UnimplementedError();
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
