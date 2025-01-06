import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/encounter.dart';
import 'package:biot/model/utility.dart';
import '../constants/enum.dart';
import 'domain.dart';
import 'outcome_measures/outcome_measure.dart';

abstract class Comparison<T> {
  double? scoreChange;
  ChangeDirection? changeDirection;

  T newer;
  T older;

  Comparison(this.newer, this.older) {
    _compareScore(newer, older);
  }

  _compareScore(T newer, T older);
}

class EncounterComparison extends Comparison<Encounter> {
  List<DomainComparison> domainComparisons = [];

  // Get a list of improved domain comparison from above domain comparison list.
  Map<String, List<DomainComparison>> get improvedDomainComparisons => {
        ksImproved: domainComparisons
            .where((element) =>
                element.changeDirection == ChangeDirection.positive)
            .toList()
      };

  // Get a list of declined domain comparison from above domain comparison list.
  Map<String, List<DomainComparison>> get declinedDomainComparisons => {
        ksDeclined: domainComparisons
            .where((element) =>
                element.changeDirection == ChangeDirection.negative)
            .toList()
      };

  // Get a list of stable domain comparison from above domain comparison list.
  Map<String, List<DomainComparison>> get stableDomainComparisons => {
        ksStable: domainComparisons
            .where(
                (element) => element.changeDirection == ChangeDirection.stable)
            .toList()
      };

  EncounterComparison(super.newer, super.older);

  @override
  _compareScore(Encounter newer, Encounter older) {
    (double, ChangeDirection) comparison = Utility.compareScore(
        newer.unweightedTotalScore!.round().toDouble(),
        older.unweightedTotalScore!.round().toDouble());
    scoreChange = comparison.$1;
    changeDirection = comparison.$2;

    for (Domain newerDomain in newer.domains) {
      Domain olderDomain = older.domains
          .firstWhere((element) => element.type == newerDomain.type);

      DomainComparison domainComparison =
          DomainComparison(newerDomain, olderDomain);

      domainComparisons.add(domainComparison);
    }
  }
}

class DomainComparison extends Comparison<Domain> {
  DomainType get domainType => newer.type;
  List<OutcomeMeasureComparison> outcomeMeasureComparisons = [];

  String get header => domainType.header;

  String get improvementSummary => domainType.improvementSummary;

  String get declineSummary => domainType.declineSummary;

  String stableSummary = 'stable summary';

  bool hasSigPos = false;

  bool hasSigNeg = false;

  DomainComparison(super.newer, super.older);

  @override
  _compareScore(Domain newer, Domain older) {
    (double, ChangeDirection) comparison = Utility.compareScore(
        newer.score!.round().toDouble(), older.score!.round().toDouble());
    scoreChange = comparison.$1;
    changeDirection = comparison.$2;

    for (OutcomeMeasure latestOutcomeMeasure in newer.outcomeMeasures) {
      OutcomeMeasure priorOutcomeMeasure = older.outcomeMeasures
          .firstWhere((element) => element.name == latestOutcomeMeasure.name);

      OutcomeMeasureComparison outcomeMeasureComparison =
          OutcomeMeasureComparison(latestOutcomeMeasure, priorOutcomeMeasure);

      outcomeMeasureComparisons.add(outcomeMeasureComparison);
    }

    hasSigPos = outcomeMeasureComparisons.any((element) =>
        element.rawScoreChangeDirection == ChangeDirection.sigPositive);

    hasSigNeg = outcomeMeasureComparisons.any((element) =>
        element.rawScoreChangeDirection == ChangeDirection.sigNegative);
  }
}

class OutcomeMeasureComparison extends Comparison<OutcomeMeasure> {
  double? rawScoreChange;
  ChangeDirection? rawScoreChangeDirection;

  OutcomeMeasureComparison(super.newer, super.older);

  @override
  _compareScore(OutcomeMeasure newer, OutcomeMeasure older) {
    (double, ChangeDirection) normalizedScoreComparison;
    (double, ChangeDirection) rawScoreComparison;

    // When outcome measure has sig diff values
    if (newer.info.sigDiffNegative != null &&
        newer.info.sigDiffPositive != null) {
      normalizedScoreComparison = Utility.compareScore(
          newer.calculateScore().roundToDouble(),
          older.calculateScore().roundToDouble(),
          negScoreDiffThreshold: older.normalizeSigDiffNegative()!,
          posScoreDiffThreshold: older.normalizeSigDiffPositive()!,
          isSigDiff: true,
          shouldReverse: newer.info.shouldReverse);
      rawScoreComparison = Utility.compareScore(newer.rawValue, older.rawValue,
          negScoreDiffThreshold: older.info.sigDiffNegative!,
          posScoreDiffThreshold: older.info.sigDiffPositive!,
          isSigDiff: true,
          shouldReverse: newer.info.shouldReverse);
    } else {
      normalizedScoreComparison = Utility.compareScore(
          newer.calculateScore().roundToDouble(),
          older.calculateScore().roundToDouble(),
          shouldReverse: newer.info.shouldReverse);
      rawScoreComparison = Utility.compareScore(newer.rawValue, older.rawValue,
          shouldReverse: newer.info.shouldReverse);
    }

    scoreChange = normalizedScoreComparison.$1;
    changeDirection = normalizedScoreComparison.$2;
    rawScoreChange = rawScoreComparison.$1;
    rawScoreChangeDirection = rawScoreComparison.$2;
  }
}
