import 'package:async/async.dart';
import 'package:biot/constants/app_strings.dart';
import 'package:biot/constants/enum.dart';
import 'package:biot/model/domain.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/patient.dart';
import 'package:biot/model/peripheral_device.dart';
import 'package:biot/model/utility.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../app/app.locator.dart';
import '../services/logger_service.dart';
import '../ui/common/constants.dart';
import 'chart_data.dart';
import 'condition.dart';
import 'domain_weight_distribution.dart';
import 'kLevel.dart';
import 'package:collection/collection.dart';

part 'encounter.g.dart';

@HiveType(typeId: 1)
class Encounter extends HiveObject {
  final _logger = locator<LoggerService>().getLogger((Encounter).toString());

  @HiveField(0)
  String? entityId;

  @HiveField(1)
  String? name;

  //TODO: can be deleted.
  @HiveField(2)
  String? creationTimeString;

  @HiveField(3)
  List<OutcomeMeasure>? outcomeMeasures;

  //TODO: can be deleted.
  @HiveField(4)
  String? domainWeightDistId;

  @HiveField(5)
  DomainWeightDistribution? domainWeightDist;

  // TODO: change num to double
  // TODO: is it nullable?
  @HiveField(6)
  num? unweightedTotalScore;

  @HiveField(7)
  double? get weightedTotalScore =>
      _weightedTotalScore ?? calculateWeightedTotalScore(domainWeightDist);

  double? _weightedTotalScore;

  set weightedTotalScore(double? value) {
    _weightedTotalScore = value;
  }

  //TODO: can be deleted.
  @HiveField(8)
  String? conditionId;

  @HiveField(9)
  Condition? condition;

  //TODO: can be deleted.
  @HiveField(10)
  String? kLevelId;

  @HiveField(11)
  KLevel? kLevel;

  String? domainScoresId;

  //UTC timezone
  @HiveField(14)
  String? encounterCreatedTimeString;

  //Local timezone
  DateTime? get encounterCreatedTime => (encounterCreatedTimeString != null)
      ? DateTime.parse(encounterCreatedTimeString!).toLocal()
      : null;

  final EncounterType? type;

  List<Domain> get domains {
    var domainList = domainsMap.entries.map((e) => e.value).toList();
    domainList.sort((a, b) => a.type.index.compareTo(b.type.index));
    return domainList;
  }

  Map<DomainType, Domain> domainsMap = {};

  bool isPopulated = false;

  List<PeripheralDevice>? peripheralDevices;

  List<String> get outcomeMeasureIds =>
      outcomeMeasures!.map((elem) => elem.id).toList();

  // Prep circular chart data by looping through domains
  List<CircularChartData> getEncounterCircularData() {
    List<CircularChartData> data = [];

    for (var i = 0; i < domains.length; i++) {
      data.add(CircularChartData.fromDomain(domains[i], this));
    }

    return data;
  }

  // Prep outcome measures chart data by looping through domains[index].outcomeMeasures
  List<CircularChartData> getOutcomeMeasureCircularData(int index,
      {bool transparentColor = false}) {
    List<CircularChartData> data = [];
    if (index != -1) {
      int numOfOutcomeMeasures = domains[index].outcomeMeasures.length;
      for (int i = 0; i < numOfOutcomeMeasures; i++) {
        data.add(CircularChartData(
            domains[index].type.displayName,
            transparentColor
                ? Colors.transparent
                : i == 0
                    ? domains[index].type.color
                    : lighten(domains[index].type.color,
                        (i / (numOfOutcomeMeasures) * 100).toInt()),
            radius: (doughnutRadius - innerDoughnutRadius) *
                    domains[index].outcomeMeasures[i].calculateScore() /
                    doughnutRadius +
                innerDoughnutRadius,
            unweightedY: getEncounterCircularData()[index].unweightedY /
                numOfOutcomeMeasures,
            weightedY: getEncounterCircularData()[index].weightedY /
                numOfOutcomeMeasures,
            numOfOutcomeMeasures: domains[index].outcomeMeasures.length));
      }
    }

    return data;
  }

  // Map all outcome measures in encounter by domain type
  Map<DomainType, List<OutcomeMeasure>> get outcomeMeasuresByDomains {
    Map<DomainType, List<OutcomeMeasure>> domains = {};
    if (outcomeMeasures == null) return domains;
    for (OutcomeMeasure outcomeMeasure in outcomeMeasures!) {
      if (domains[outcomeMeasure.domainType] == null) {
        domains[outcomeMeasure.domainType] = [outcomeMeasure];
      } else {
        domains[outcomeMeasure.domainType]!.add(outcomeMeasure);
      }
    }
    return domains;
  }

  // Unique name is required
  String generateUniqueEntityInstanceNameWithPatient(
      Patient patient, String entity) {
    DateTime now = DateTime.now();
    String currentTime =
        '${DateFormat('yyyyMMdd').format(now)}_${DateFormat('HHmmss').format(now)}';
    String uniqueName =
        '${patient.lastName[0]}${patient.firstName[0]}_${entity}_$currentTime'
            .toLowerCase();
    return uniqueName;
  }

  Encounter(
      {this.entityId,
      this.name,
      this.outcomeMeasures,
      this.domainWeightDistId,
      this.domainWeightDist,
      this.domainScoresId,
      this.kLevelId,
      this.kLevel,
      this.conditionId,
      this.condition,
      this.type,
      this.unweightedTotalScore,
      this.encounterCreatedTimeString,
      this.peripheralDevices,
      this.creationTimeString}) {
    outcomeMeasures ??= [];
  }

  factory Encounter.fromJson(Map<String, dynamic> data) {
    DomainWeightDistribution? domainWeightDist;
    String? domainScoresId;
    Condition? condition;
    KLevel? kLevel;
    num? totalScore;
    String? encounterCreatedTimeString;
    List<String> outcomeMeasureIds;

    if (data['${ksDomainWeightDistribution}_smartpo'] != null) {
      domainWeightDist = DomainWeightDistribution(
          entityId: data['${ksDomainWeightDistribution}_smartpo']['id']);
    }

    if (data['${ksCondition}_smartpo'] != null) {
      condition = Condition(entityId: data['${ksCondition}_smartpo']['id']);
    }

    if (data['${ksDomainScores}_smartpo'] != null) {
      domainScoresId = data['${ksDomainScores}_smartpo']['id'];
    }

    if (data['${ksKLevel}_smartpo'] != null) {
      kLevel = KLevel(entityId: data['${ksKLevel}_smartpo']['id']);
    }

    if (data['total_score_smartpo'] != null) {
      totalScore = data['total_score_smartpo'];
    }

    if (data['encounter_created_time_smartpo'] != null) {
      encounterCreatedTimeString = data['encounter_created_time_smartpo'];
    }

    Encounter encounter = Encounter(
        entityId: data['_id'],
        name: data['_name'],
        domainWeightDist: domainWeightDist,
        domainScoresId: domainScoresId,
        condition: condition,
        kLevel: kLevel,
        type: EncounterType.outcomeMeasure,
        unweightedTotalScore: totalScore,
        encounterCreatedTimeString: encounterCreatedTimeString);

    outcomeMeasureIds = data['outcome_measures'].split(', ');
    for (String id in outcomeMeasureIds) {
      OutcomeMeasure outcomeMeasure = OutcomeMeasure.withId(id);
      outcomeMeasure.entityId = data['${id}_smartpo']['id'];
      outcomeMeasure.outcomeMeasureCreatedTimeString =
          encounterCreatedTimeString;
      encounter.addOutcomeMeasure(outcomeMeasure);
    }

    return encounter;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> body = {
      "_templateId": ksSmartpoEncounterTemplateId,
      "encounter_created_time_smartpo": encounterCreatedTimeString,
      "total_score_smartpo": unweightedTotalScore,
      "domain_scores_smartpo": {"id": domainScoresId},
      "outcome_measures": outcomeMeasureIds.join(', ')
    };

    return body;
  }

  Future populate({Patient? patient}) async {
    _logger.d('populating encounter');
    if (isPopulated) return Future.value(true);

    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(domainWeightDist!.populate());
    for (OutcomeMeasure om in outcomeMeasures!) {
      if (!om.isPopulated) {
        futureGroup.add(om.populate());
        futureGroup.add(om.buildInfo());
      }
    }

    futureGroup.close();
    return futureGroup.future.whenComplete(() => isPopulated = true);
  }

  Future populateDomainScores(Map<String, dynamic> json) async {
    _logger.d('populating domain scores');

    domainsMap.forEach((key, value) {
      String domainName = key.name;
      value.score = json['${domainName}_domain_score'];
    });

    _logger.d('successfully populated domain scores');
  }

  // Calculate following scores:
  // each outcome measure score
  // each domain total score
  // unweighted total score
  // weighted total score
  void calculateScore() {
    // Calculate each domain total score by calculating its outcome measures' scores
    domainsMap.forEach((key, value) {
      value.calculateScore();
    });

    // Calculate unweighted total score
    unweightedTotalScore = calculateUnweightedTotalScore();

    //  Calculate weighted total score
    weightedTotalScore = calculateWeightedTotalScore(domainWeightDist);
  }

  void addOutcomeMeasure(OutcomeMeasure om) {
    outcomeMeasures?.add(om);

    // Add outcome measure to its respective domain
    if (domainsMap[om.domainType] == null) {
      domainsMap[om.domainType] = Domain.withType(om.domainType);
    }

    if (om.id == ksProgait) {
      domainsMap[om.domainType]!.outcomeMeasures.insert(0, om);
    } else {
      domainsMap[om.domainType]!.outcomeMeasures.add(om);
    }
  }

  void removeOutcomeMeasure(OutcomeMeasure om) {
    outcomeMeasures?.removeWhere((element) => element.name == om.name);

    // Remove domain if its outcome measure list is empty
    if (domainsMap[om.domainType]!.outcomeMeasures.isEmpty) {
      domainsMap.remove(om.domainType);
    }
  }

  OutcomeMeasure? outcomeMeasureById(String id) {
    return outcomeMeasures?.firstWhereOrNull((element) => element.id == id);
  }

  double calculateUnweightedTotalScore() {
    double total = 0;
    domainsMap.forEach((key, value) {
      total += value.score!;
    });
    total /= domainsMap.length;

    return total;
  }

  double calculateWeightedTotalScore(
      DomainWeightDistribution? domainWeightDist) {
    double total = 0;

    if (domainWeightDist != null) {
      domainsMap.forEach((key, value) {
        total +=
            value.score! * domainWeightDist.getDomainWeightValue(key) / 100;
      });
    }

    return total;
  }

  (double scoreChange, ChangeDirection scoreDiff)
      compareUnweightedTotalScoreAgainstPrev(Encounter encounterToCompare) {
    return Utility.compareScore(unweightedTotalScore!.round().toDouble(),
        encounterToCompare.unweightedTotalScore!.round().toDouble());
  }

  Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }
}
