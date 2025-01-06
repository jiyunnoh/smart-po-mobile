import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

class Faam extends OutcomeMeasure {
  late double score;
  late String rawData;

  Faam({required super.id, super.data});

  @override
  Map<String, String> get totalScore {
    String score1;
    String score2;
    if (questionCollection.skippedQuestionsForScoreGroup(0) > 1) {
      score1 = 'N/A';
    } else {
      num sum = questionCollection.getQuestionsForScoreGroup(0).fold(0, (p, e) {
        return e.value == null || e.value == 5 ? p : p + 4 - e.value;
      });
      final numValidResponses = questionCollection
          .getQuestionsForScoreGroup(0)
          .where((e) => e.value != null && e.value != 5)
          .toList()
          .length;
      print('$sum, $numValidResponses');
      score1 =
          (sum.toDouble() / (4 * numValidResponses) * 100).toStringAsFixed(1);
    }
    if (questionCollection.skippedQuestionsForScoreGroup(1) > 1) {
      score2 = 'N/A';
    } else {
      num sum = questionCollection.getQuestionsForScoreGroup(1).fold(0, (p, e) {
        return e.value == null || e.value == 5 ? p : p + 4 - e.value;
      });
      final numValidResponses = questionCollection
          .getQuestionsForScoreGroup(1)
          .where((e) => e.value != null && e.value != 5)
          .toList()
          .length;
      score2 =
          (sum.toDouble() / (4 * numValidResponses) * 100).toStringAsFixed(1);
    }
    return {'score_1': score1, 'score_2': score2};
  }

  factory Faam.fromJson(Map<String, dynamic> data) {
    Faam dash = Faam(id: ksDash);
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
