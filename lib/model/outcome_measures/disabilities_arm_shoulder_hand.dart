import 'package:biot/model/chart_data.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';

import '../../constants/app_strings.dart';

class Dash extends OutcomeMeasure {
  late double score;
  late String rawData;

  Dash({required super.id, super.data});

  @override
  Map<String, String> get totalScore {
    String mainScore;
    String workScore;
    String sportsScore;
    //Main Score
    if (questionCollection.skippedQuestionsForScoreGroup(0) > 3) {
      mainScore = 'N/A';
    } else {
      num sum = questionCollection.getQuestionsForScoreGroup(0).fold(0, (p, e) {
        return e.value == null ? p : p + e.value + 1;
      });
      final numValidResponses = questionCollection
          .getQuestionsForScoreGroup(0)
          .where((e) => e.value != null)
          .toList()
          .length;
      print('$sum, $numValidResponses');
      mainScore =
          (((sum.toDouble() / numValidResponses) - 1) * 25).toStringAsFixed(1);
    }
    //Work Score
    if (questionCollection.skippedQuestionsForScoreGroup(1) > 0) {
      workScore = 'N/A';
    } else {
      num sum = questionCollection.getQuestionsForScoreGroup(1).fold(0, (p, e) {
        return e.value == null ? p : p + e.value + 1;
      });
      final numValidResponses =
          questionCollection.getQuestionsForScoreGroup(1).length;
      print('$sum, $numValidResponses');
      workScore =
          (((sum.toDouble() / numValidResponses) - 1) * 25).toStringAsFixed(1);
    }
    //Sports/Instrument Score
    if (questionCollection.skippedQuestionsForScoreGroup(2) > 0) {
      print("${questionCollection.skippedQuestionsForScoreGroup(2)}");
      sportsScore = 'N/A';
    } else {
      num sum = questionCollection.getQuestionsForScoreGroup(2).fold(0, (p, e) {
        return e.value == null ? p : p + e.value + 1;
      });
      final numValidResponses =
          questionCollection.getQuestionsForScoreGroup(2).length;
      print('$sum, $numValidResponses');
      sportsScore =
          (((sum.toDouble() / numValidResponses) - 1) * 25).toStringAsFixed(1);
    }
    print('$mainScore , $workScore, $sportsScore');
    return {'score_1': mainScore, 'score_2': workScore, 'score_3': sportsScore};
  }

  factory Dash.fromJson(Map<String, dynamic> data) {
    Dash dash = Dash(id: ksDash);
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
