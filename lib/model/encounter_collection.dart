import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/encounter.dart';
import '../constants/enum.dart';
import 'chart_data.dart';
import 'comparison.dart';
import 'domain.dart';

class EncounterCollection {
  // Encounters are sorted in descending order based on encounterCreatedTime.
  List<Encounter> encounters;

  EncounterCollection(this.encounters) {
    newerComparisonEncounter = lastEncounter;
    olderComparisonEncounter = secondToLastEncounter;
  }

  Encounter? get lastEncounter =>
      encounters.isNotEmpty ? encounters.first : null;

  Encounter? get secondToLastEncounter =>
      encounters.length > 1 ? encounters[1] : null;

  Encounter? get firstEncounter =>
      encounters.isNotEmpty ? encounters.last : null;

  Encounter? newerComparisonEncounter;
  Encounter? olderComparisonEncounter;

  DateTime get firstEncounterFormattedTime => DateTime(
      firstEncounter!.encounterCreatedTime!.year,
      firstEncounter!.encounterCreatedTime!.month,
      firstEncounter!.encounterCreatedTime!.day);

  // Compare two encounters
  EncounterComparison? compareEncounterForAnalytics(
      {bool forTrendView = false}) {
    // In trend view, always compare latest two encounters.
    if (forTrendView) {
      if (lastEncounter != null && secondToLastEncounter != null) {
        EncounterComparison encounterComparison =
            EncounterComparison(lastEncounter!, secondToLastEncounter!);
        return encounterComparison;
      }
    } else {
      if (newerComparisonEncounter != null &&
          olderComparisonEncounter != null) {
        EncounterComparison encounterComparison = EncounterComparison(
            newerComparisonEncounter!, olderComparisonEncounter!);
        return encounterComparison;
      }
    }
    return null;
  }

  // Get total scores by looping through encounters and prep time series data
  List<TimeSeriesChartData> getTotalScoresTrendData() {
    List<TimeSeriesChartData> data =
        encounters.map<TimeSeriesChartData>((encounter) {
      if (encounter.unweightedTotalScore != null) {
        return TimeSeriesChartData(
            date: encounter.encounterCreatedTime!,
            dataList: [
              ChartData(
                  label: "Value",
                  value: encounter.unweightedTotalScore!.roundToDouble()),
            ]);
      } else {
        return TimeSeriesChartData(
            date: encounter.encounterCreatedTime!,
            dataList: [
              ChartData(label: "Value", value: null),
            ]);
      }
    }).toList();
    return data;
  }

  // TODO: Move this to trend viewmodel, using allDomains
  // Get domain scores by looping through encounter.domains for each encounter and prep time series data
  Map<DomainType, List<TimeSeriesChartData>> getDomainScoresTrendData() {
    Map<DomainType, List<TimeSeriesChartData>> data = {};
    for (Encounter encounter in encounters) {
      for (Domain domain in encounter.domains) {
        data[domain.type] ??= [];
        data[domain.type]!.add(TimeSeriesChartData(
            date: encounter.encounterCreatedTime!,
            dataList: [
              ChartData(
                  label: domain.type.displayName,
                  value: encounter.domainsMap[domain.type]!.score!
                      .roundToDouble()),
            ]));
      }
    }
    return data;
  }

  // Get all domain types from all encounters.
  List<DomainType> get allDomainTypes {
    List<DomainType> domainTypes = [];
    for (var encounter in encounters) {
      for (var domain in encounter.domains) {
        domainTypes.add(domain.type);
      }
    }

    return domainTypes.toSet().toList();
  }

  // Get all outcome measures for input domain type.
  List<OutcomeMeasure> allOutcomeMeasuresForDomain(DomainType domainType) {
    List<OutcomeMeasure> outcomeMeasures = [];
    for (Encounter encounter in encounters) {
      if (encounter.outcomeMeasuresByDomains[domainType] != null) {
        outcomeMeasures.addAll(encounter.outcomeMeasuresByDomains[domainType]!);
      }
    }

    return outcomeMeasures.toSet().toList();
  }
}
