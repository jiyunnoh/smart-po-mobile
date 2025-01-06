import 'package:biot/constants/app_strings.dart';
import 'package:biot/constants/enum.dart';
import 'package:biot/model/outcome_measures/fall_history.dart';
import 'package:biot/model/outcome_measures/opus_satisfaction_with_devices_and_services.dart';
import 'package:biot/model/outcome_measures/orthotic_mobility_score.dart';
import 'package:biot/model/outcome_measures/patient_mobility_questionnaire.dart';
import 'package:biot/model/outcome_measures/patient_satisfaction_questionnaire.dart';
import 'package:biot/model/outcome_measures/patient_specific_functional_scale.dart';
import 'package:biot/model/outcome_measures/promis_pain_interference.dart';
import 'package:biot/model/outcome_measures/prosthesis_evaluation_questionnaire.dart';
import 'package:biot/model/outcome_measures/six_minute_walk_test.dart';
import 'package:biot/model/outcome_measures/socket_comfort_score.dart';
import 'package:biot/model/outcome_measures/tapes_r.dart';
import 'package:biot/model/outcome_measures/ten_meter_walk_test.dart';
import 'package:biot/model/outcome_measures/timed_up_and_go.dart';
import 'package:biot/model/outcome_measures/two_minute_walk_test.dart';
import 'package:biot/model/outcome_measures/upper_extremity_functional_index.dart';
import 'package:biot/model/patient.dart';
import 'package:biot/services/outcome_measure_load_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../app/app.locator.dart';
import '../../services/cloud_service.dart';
import '../chart_data.dart';
import '../outcome_measure_info.dart';
import '../question_collection.dart';
import '../utility.dart';
import 'disabilities_arm_shoulder_hand.dart';
import 'eq_5d_5l.dart';
import 'foot_ankle_ability_measure.dart';
import 'four_square_step_test.dart';
import 'lower_extremity_functional_scale.dart';
import 'numeric_pain_rating_scale.dart';
import 'opus_health_quality_of_life.dart';
import 'opus_lower_extremity_functional_scale.dart';

abstract class OutcomeMeasure {
  final _outcomeMeasureLoadService = locator<OutcomeMeasureLoadService>();

  ///Fields from outcome measure template json file
  // this is the outcome measure prefix id and must match prefix id used in the cloud environment
  late String id;
  late String _name;
  late String _shortName;
  late OutcomeMeasureInfo info;
  late DomainType domainType;
  int estTimeToComplete = 0;
  bool isAssistantNeeded = false;
  List<dynamic>? tags;
  late List<dynamic> supportedLocale;
  String? familyName;
  String? familyShortName;
  bool isActive = false;

  ///Fields from cloud backend
  String? entityId;

  String? get templateId;

  String? patientId;
  String? encounterId;
  int? index;

  String get rawName => _name;

  String get rawShortName => _shortName;

  String get name =>
      familyShortName == null ? _name : '$familyShortName-$_name';

  String get shortName =>
      familyShortName == null ? _shortName : '$familyShortName-$_shortName';
  //rawValue is for score comparison in the Insights view. Need to rename in the future.
  late double rawValue;
  List<Map<String, String>>? summaryDataToBeModified;
  bool isPopulated = false;
  int numOfGraph = 1;
  bool isSelected = false;
  late QuestionCollection questionCollection;
  Map<String, dynamic>? data;
  String? outcomeMeasureCreatedTimeString;

  DateTime? get outcomeMeasureCreatedTime =>
      (outcomeMeasureCreatedTimeString != null)
          ? DateTime.parse(outcomeMeasureCreatedTimeString!).toLocal()
          : null;

  String get chartYAxisTitle =>
      '${info.yAxisLabel} ${(info.yAxisUnit == null) ? '' : '(${info.yAxisUnit})'}';

  // String size should be between 1 and 32.
  String currentTime =
      '${DateFormat.yMd().format(DateTime.now())}_${DateFormat.Hms().format(DateTime.now())}';

  bool get isComplete => questionCollection.isComplete;

  final _apiService = locator<BiotService>();

  OutcomeMeasure({required this.id, this.data}) {
    if (data != null) {
      _name = data!['name'];
      _shortName = data!['shortName'];
      tags = data!['tags'] ?? [];
      familyName = data!['familyName'];
      familyShortName = data!['familyShortName'];
      domainType = DomainType.fromType(data!['domainType']);
      estTimeToComplete = int.parse(data!['estimatedTime']);
      isAssistantNeeded =
          bool.parse(data!['isAssistantNeeded'], caseSensitive: false);
      supportedLocale = data![kSupportedLocales] ?? ['en'];
      isActive = data!['isActive'];
    } else {
      copyOutcomeMeasureTemplateData();
    }
  }

  void copyOutcomeMeasureTemplateData() {
    OutcomeMeasure template =
        _outcomeMeasureLoadService.allOutcomeMeasures.getOutcomeMeasureById(id);
    _name = template.rawName;
    _shortName = template.rawShortName;
    tags = template.tags;
    familyName = template.familyName;
    familyShortName = template.familyShortName;
    domainType = template.domainType;
    estTimeToComplete = template.estTimeToComplete;
    isAssistantNeeded = template.isAssistantNeeded;
    supportedLocale = template.supportedLocale;
  }

  Map<String, dynamic> coreDataToJson() {
    return {
      'name': _name,
      'shortName': _shortName,
      'tags': tags,
      'familyName': familyName,
      'familyShortName': familyShortName,
      'domainType': domainType.type,
      'estimatedTime': estTimeToComplete.toString(),
      'isAssistantNeeded': isAssistantNeeded.toString(),
      kSupportedLocales: supportedLocale,
      'isActive': isActive
    };
  }

  double calculateScore();

  // By default, outcome measure can proceed to the next outcome measure in queue if all questions have been answered.
  // override this with custom rule suited for each outcome measure
  bool canProceed() {
    return isComplete;
  }

  double? normalizeSigDiffPositive() {
    return null;
  }

  double? normalizeSigDiffNegative() {
    return null;
  }

  Future<void> build({bool shouldLocalize = false}) async {
    await buildInfo();
    await buildQuestions(shouldLocalize: shouldLocalize);
  }

  Future buildInfo() async {
    try {
      var info = await _outcomeMeasureLoadService.getOutcomeInfo('${id}_info');
      this.info = OutcomeMeasureInfo.fromJson(id, info);

      return true;
    } catch (e) {
      return Exception('Building info failed for outcome measure with id:$id');
    }
  }

  Future<void> buildQuestions({bool shouldLocalize = false}) async {
    try {
      var rawQuestions = await _outcomeMeasureLoadService
          .getOutcomeQuestions('${id}_questions');
      if (shouldLocalize) {
        questionCollection.localizeWith(rawQuestions);
      } else {
        questionCollection = QuestionCollection.fromJson(rawQuestions);
      }
      questionCollection.groupHeaders = info.groupHeaders;
    } catch (e) {
      Exception('Building questions failed for outcome measure with id:$id');
    }
  }

  Future populate() async {
    if (!isPopulated) {
      return _apiService.getOutcomeMeasure(http.Client(), this);
    }
  }

  void populateWithJson(Map<String, dynamic> json);

  TimeSeriesChartData outcomeMeasureChartData();

  String getSummaryScoreTitle(int index) {
    String summaryScoreTitle = info.summaryScore![index];
    return summaryScoreTitle;
  }

  // Compare two outcome measures
  (double scoreChange, ChangeDirection scoreDiff) compareScoreAgainstPrev(
      OutcomeMeasure outcomeMeasureToCompare) {
    if (outcomeMeasureToCompare.info.sigDiffNegative != null &&
        outcomeMeasureToCompare.info.sigDiffPositive != null) {
      return Utility.compareScore(calculateScore().roundToDouble(),
          outcomeMeasureToCompare.calculateScore().roundToDouble(),
          negScoreDiffThreshold:
              outcomeMeasureToCompare.normalizeSigDiffNegative()!,
          posScoreDiffThreshold:
              outcomeMeasureToCompare.normalizeSigDiffPositive()!,
          isSigDiff: true);
    } else {
      return Utility.compareScore(calculateScore().roundToDouble(),
          outcomeMeasureToCompare.calculateScore().roundToDouble());
    }
  }

  OutcomeMeasure clone();

  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index);

  factory OutcomeMeasure.withId(String id, [Map<String, dynamic>? data]) {
    switch (id) {
      case ksTmwt:
        return Tmwt(id: id, data: data);
      case ksPmq:
        return Pmq(id: id, data: data);
      case ksPromispi:
        return Promispi(id: id, data: data);
      case ksFh:
        return Fh(id: id, data: data);
      case ksScs:
        return Scs(id: id, data: data);
      case ksPsfs:
        return Psfs(id: id, data: data);
      case ksNprs:
        return Nprs(id: id, data: data);
      case ksTug:
        return Tug(id: id, data: data);
      case ksEq5d5l:
        return Eq5d(id: id, data: data);
      case ksPeqPain:
        return Tmwt(id: id, data: data);
      case ksPeqSatisfaction:
        return Tmwt(id: id, data: data);
      case ksPeqSocialBurden:
        return Tmwt(id: id, data: data);
      case ksTminwt:
        return Tminwt(id: id, data: data);
      case ksSminwt:
        return Sminwt(id: id, data: data);
      case ksFsst:
        return Fsst(id: id, data: data);
      case ksOms:
        return Oms(id: id, data: data);
      case ksDash:
        return Dash(id: id, data: data);
      case ksLefs:
        return Lefs(id: id, data: data);
      case ksFaam:
        return Faam(id: id, data: data);
      case ksUefi:
        return Uefi(id: id, data: data);
      case ksOpusLefs:
        return OpusLefs(id: id, data: data);
      case ksOpusHq:
        return OpusHq(id: id, data: data);
      case ksOpusSwds:
        return OpusSwds(id: id, data: data);
      case ksPeqUt:
        return PeqUt(id: id, data: data);
      case ksPeqRl:
        return PeqRl(id: id, data: data);
      case 'opus_uefs':
        return Tmwt(id: id, data: data);
      case ksPsq:
        return Psq(id: id, data: data);
      case 'tapes_r':
        return TapesR(id: id, data: data);
      default:
        return Tmwt(id: id, data: data);
    }
  }

  factory OutcomeMeasure.fromJson(Map<String, dynamic> data) {
    if (data[ksTemplate]['name'] == ksTmwt) {
      return Tmwt.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPmq) {
      return Pmq.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPromispi) {
      return Promispi.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksScs) {
      return Scs.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPsfs) {
      return Psfs.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksNprs) {
      return Nprs.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksTug) {
      return Tug.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksEq5d5l) {
      return Eq5d.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPeqPain) {
      return PeqPain.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPeqSatisfaction) {
      return PeqSatisfaction.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPeqSocialBurden) {
      return PeqSocialBurden.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksFh) {
      return Fh.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPeqUt) {
      return PeqUt.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPeqRl) {
      return PeqRl.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksTminwt) {
      return Tminwt.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksSminwt) {
      return Sminwt.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksTapesR) {
      return TapesR.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksPsq) {
      return Psq.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksOpusLefs) {
      return OpusLefs.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksOpusSwds) {
      return OpusSwds.fromJson(data);
    }
    if (data[ksTemplate]['name'] == ksOpusHq) {
      return OpusHq.fromJson(data);
    }

    throw UnimplementedError();
  }

  factory OutcomeMeasure.fromTemplateJson(Map<String, dynamic> data) {
    return OutcomeMeasure.withId(data['id'], data);
  }

  // Override hashCode and operator== for proper comparison.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OutcomeMeasure && other.id == id;
  }

  @override
  int get hashCode => name.hashCode;

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
  Map<String, dynamic> get totalScore => {};

  @override
  String toString() {
    return 'id: $id, templateId: $templateId';
  }
}

class PeqPain extends OutcomeMeasure {
  late double score;
  late String rawData;

  PeqPain({required super.id, super.data});

  factory PeqPain.fromJson(Map<String, dynamic> data) {
    PeqPain peqPain = PeqPain(id: ksPeqPain);

    return peqPain;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    score = json['${id}_score'].toDouble();
    index = json['${id}_order'];
    summaryDataToBeModified = summary();
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = score;
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
      "${id}_created_time": outcomeMeasureCreatedTimeString
    };

    return body;
  }

  @override
  List<Map<String, String>> summary() {
    List<Map<String, String>> summary = [];
    summary.add({'key': ksTotalScore, 'value': score.toString()});
    return summary;
  }

  @override
  double calculateScore() {
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
  String? get templateId => ksPeqPainTemplateId;

  @override
  PeqPain clone() {
    PeqPain peqPain = PeqPain(id: ksPeqPain, data: coreDataToJson());
    return peqPain;
  }
}

class PeqSatisfaction extends OutcomeMeasure {
  late double score;
  late String rawData;

  PeqSatisfaction({required super.id, super.data});

  factory PeqSatisfaction.fromJson(Map<String, dynamic> data) {
    PeqSatisfaction peqSatisfaction = PeqSatisfaction(id: ksPeqSatisfaction);

    return peqSatisfaction;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    score = json['${id}_score'].toDouble();
    index = json['${id}_order'];
    summaryDataToBeModified = summary();
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = score;
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
      "${id}_created_time": outcomeMeasureCreatedTimeString
    };

    return body;
  }

  @override
  List<Map<String, String>> summary() {
    List<Map<String, String>> summary = [];
    summary.add({'key': ksTotalScore, 'value': score.toString()});
    return summary;
  }

  @override
  double calculateScore() {
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
  String? get templateId => ksPeqSatisfactionTemplateId;

  @override
  PeqSatisfaction clone() {
    PeqSatisfaction peqSatisfaction =
        PeqSatisfaction(id: ksPeqSatisfaction, data: coreDataToJson());
    return peqSatisfaction;
  }
}

class PeqSocialBurden extends OutcomeMeasure {
  late double score;
  late String rawData;

  PeqSocialBurden({required super.id, super.data});

  factory PeqSocialBurden.fromJson(Map<String, dynamic> data) {
    PeqSocialBurden peqSocialBurden = PeqSocialBurden(id: ksPeqSocialBurden);
    return peqSocialBurden;
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    score = json['${id}_score'].toDouble();
    index = json['${id}_order'];
    summaryDataToBeModified = summary();
    patientId = json['${id}_patient']['id'];
    encounterId = json['_referencers']?['${id}_smartpo']['referrer']['id'];
    rawValue = score;
    outcomeMeasureCreatedTimeString = json['${id}_created_time'];
    isPopulated = true;
  }

  @override
  Map<String, dynamic> toJson(ownerOrganizationId, patient, index) {
    String patientName =
        '${patient.lastName[0]}${patient.firstName[0]}'.toLowerCase();

    Map<String, dynamic> body = {
      "_name": "${patientName}_peq_sb_$currentTime",
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
  List<Map<String, String>> summary() {
    List<Map<String, String>> summary = [];
    summary.add({'key': ksTotalScore, 'value': score.toString()});
    return summary;
  }

  @override
  double calculateScore() {
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
  String? get templateId => ksPeqSocialBurdenTemplateId;

  @override
  PeqSocialBurden clone() {
    PeqSocialBurden peqSocialBurden =
        PeqSocialBurden(id: ksPeqSocialBurden, data: coreDataToJson());
    return peqSocialBurden;
  }
}
