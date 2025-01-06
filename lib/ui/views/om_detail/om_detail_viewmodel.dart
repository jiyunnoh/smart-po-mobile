import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/model/comparison.dart';
import 'package:biot/model/outcome_measures/progait.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/app.locator.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/enum.dart';
import '../../../model/chart_data.dart';
import '../../../model/demo_globals.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/patient.dart';
import '../../../model/encounter.dart';
import '../../../services/cloud_service.dart';
import '../../../services/database_service.dart';
import 'package:http/http.dart' as http;

import '../../../services/logger_service.dart';
import '../../common/constants.dart';

class OmDetailViewModel extends FutureViewModel with OIDialog {
  final _localdbService = locator<DatabaseService>();
  final _apiService = locator<BiotService>();

  final DomainType domainType;
  final List<OutcomeMeasure> outcomeMeasures;

  List<OutcomeMeasureComparison> outcomeMeasureComparisonList = [];

  late OutcomeMeasure fromLastEncounter;
  late OutcomeMeasure fromSecondToLastEncounter;

  Patient? get currentPatient => _localdbService.currentPatient?.value;

  List<Encounter> get encounters =>
      currentPatient!.encounterCollection.encounters;

  DomainComparison? get domainComparison => currentPatient?.encounterCollection
      .compareEncounterForAnalytics(forTrendView: true)
      ?.domainComparisons
      .firstWhere((element) => element.newer.type == domainType);

  Map<String, List<TimeSeriesChartData>> outcomeMeasureChartDataListMap = {};
  Map<String, List<TimeSeriesChartData>> outcomeMeasureChartSigDiffMap = {};

  // TODO: How about each outcome measure having this flag?
  List<bool> isSigDiffAvailable = [];
  List<bool> isSigDiffOn = [];

  final _logger =
      locator<LoggerService>().getLogger((OmDetailViewModel).toString());

  OmDetailViewModel({required this.domainType, required this.outcomeMeasures});

  @override
  Future futureToRun() async {
    _logger.d('');

    List<List<OutcomeMeasure>> result = [];

    for (OutcomeMeasure outcomeMeasure in outcomeMeasures) {
      if (outcomeMeasure.id == ksProgait) {
        List<ProGait> temp = [];
        for (int i = 0; i < encounters.length; i++) {
          proGaitList[encounters.length - i - 1].buildInfo();
          temp.insert(0, proGaitList[encounters.length - i - 1]);
        }
        result.add(temp);
      } else {
        result.add(await getOutcomeMeasureHistory(outcomeMeasure));
      }

      if (outcomeMeasure.info.sigDiffNegative != null) {
        isSigDiffAvailable.add(true);
        isSigDiffOn.add(true);
      } else {
        if (outcomeMeasure.id == ksProgait) {
          isSigDiffAvailable.insert(0, false);
          isSigDiffOn.insert(0, false);
        } else {
          isSigDiffAvailable.add(false);
          isSigDiffOn.add(false);
        }
      }
    }
    // TODO: improve performance
    _logger.d('done future to run om detail view');
    return result;
  }

  @override
  Future<void> onData(data) async {
    for (List<OutcomeMeasure> omHistoryFromData in data) {
      for (int i = 0; i < omHistoryFromData.length; i++) {
      proGaitList[i].outcomeMeasureCreatedTimeString =
          omHistoryFromData[i].outcomeMeasureCreatedTime!.toIso8601String();
      }

      List<OutcomeMeasure> outcomeMeasureHistory = isDemo
          ? omHistoryFromData.reversed.toList()
          : omHistoryFromData;
      List<TimeSeriesChartData> sigDiffChartDataList = [];

      await outcomeMeasureHistory.first.buildInfo();
      for (int i = 0; i < outcomeMeasureHistory.length; i++) {
        outcomeMeasureChartDataListMap[outcomeMeasureHistory.first.rawName] ??= [];
        outcomeMeasureChartDataListMap[outcomeMeasureHistory.first.rawName] = outcomeMeasureHistory
            .map((outcomeMeasure) => outcomeMeasure.outcomeMeasureChartData())
            .toList();

        //only add outcome measure with sig diff values
        if (outcomeMeasureHistory.first.info.sigDiffNegative != null &&
            outcomeMeasureHistory.first.info.sigDiffPositive != null) {
          if (i < outcomeMeasureHistory.length - 1) {
            OutcomeMeasure priorData = outcomeMeasureHistory[i];
            await priorData.buildInfo();

            OutcomeMeasure nextData = outcomeMeasureHistory[i + 1];
            await nextData.buildInfo();

            double negThreshold =
                priorData.rawValue - priorData.info.sigDiffNegative!;
            double posThreshold =
                priorData.rawValue + priorData.info.sigDiffPositive!;
            Color color = Colors.black;
            if (nextData.rawValue < negThreshold) {
              color = priorData.info.shouldReverse ? Colors.green : Colors.red;
            } else if (nextData.rawValue > posThreshold) {
              color = priorData.info.shouldReverse ? Colors.red : Colors.green;
            } else {
              color = Colors.black;
            }
            sigDiffChartDataList.add(TimeSeriesChartData(
                date: nextData.outcomeMeasureCreatedTime!,
                dataList: [ChartData(value: priorData.rawValue)],
                color: color));
          }
        }
      }
      outcomeMeasureChartSigDiffMap[outcomeMeasureHistory.first.rawName] = sigDiffChartDataList;

      fromLastEncounter = outcomeMeasureHistory.last;
      await fromLastEncounter.buildInfo();

      fromSecondToLastEncounter = outcomeMeasureHistory.elementAt(
          outcomeMeasureChartDataListMap[outcomeMeasureHistory.first.rawName]!.length - 2);
      await fromSecondToLastEncounter.buildInfo();

      OutcomeMeasureComparison outcomeMeasureComparison =
          OutcomeMeasureComparison(
              fromLastEncounter, fromSecondToLastEncounter);

      if (fromLastEncounter.id == ksProgait) {
        outcomeMeasureComparisonList.insert(0, outcomeMeasureComparison);
      } else {
        outcomeMeasureComparisonList.add(outcomeMeasureComparison);
      }
    }
  }

  // Graph Series should be in viewModel, not in OutcomeMeasure class. Graph Series should have list of outcome measures data point. (om history)
  List<ChartSeries<TimeSeriesChartData, DateTime>> getOmHistoryGraph(
      OutcomeMeasure outcomeMeasure, int index) {
    List<ChartSeries<TimeSeriesChartData, DateTime>> lines = [];
    List<TimeSeriesChartData> chartDataList =
        outcomeMeasureChartDataListMap[outcomeMeasure.rawName]!;

    // Draw outcome measure trend history line
    for (int i = 0; i < outcomeMeasure.numOfGraph; i++) {
      if (outcomeMeasure.id == ksProgait) {
        lines.add(LineSeries<TimeSeriesChartData, DateTime>(
            isVisible: true,
            animationDuration: 0,
            dataSource: chartDataList,
            width: 2,
            color: chartDataList[0].dataList[i].label == 'M/L'
                ? domainType.color
                : chartDataList[0].dataList[i].label == 'A/P'
                    ? Colors.orange
                    : Colors.purple,
            name: chartDataList[0].dataList[i].label,
            xValueMapper: (TimeSeriesChartData data, _) => data.date,
            yValueMapper: (TimeSeriesChartData data, _) =>
                data.dataList[i].value,
            yAxisName: chartDataList[0].dataList[i].label == 'Temporal Symmetry'
                ? 'secondaryYAxis'
                : 'primaryYAxis',
            markerSettings: const MarkerSettings(isVisible: true)));
      } else {
        lines.add(LineSeries<TimeSeriesChartData, DateTime>(
            isVisible: (i == 0)
                ? true
                : (isSigDiffOn[index])
                    ? false
                    : true,
            animationDuration: 0,
            dataSource: chartDataList,
            dashArray: (i == 1) ? [5, 5] : [0, 0],
            width: 2,
            color: domainType.color,
            name: chartDataList[0].dataList[i].label,
            xValueMapper: (TimeSeriesChartData data, _) => data.date,
            yValueMapper: (TimeSeriesChartData data, _) =>
                data.dataList[i].value,
            markerSettings: const MarkerSettings(isVisible: true)));
      }
    }

    // Draw outcome measure sig diff graph
    if (isSigDiffOn[index] &&
        outcomeMeasure.info.sigDiffPositive != null &&
        outcomeMeasure.info.sigDiffNegative != null) {
      lines.add(ErrorBarSeries<TimeSeriesChartData, DateTime>(
        animationDuration: 0,
        dataSource: outcomeMeasureChartSigDiffMap[outcomeMeasure.rawName]!,
        xValueMapper: (TimeSeriesChartData data, _) => data.date,
        yValueMapper: (TimeSeriesChartData data, _) => data.dataList[0].value,
        pointColorMapper: (TimeSeriesChartData data, _) => data.color,
        width: 1.5,
        type: ErrorBarType.custom,
        verticalPositiveErrorValue: outcomeMeasure.info.sigDiffPositive,
        verticalNegativeErrorValue: outcomeMeasure.info.sigDiffNegative,
        capLength: 10,
      ));

      lines.add(ScatterSeries<TimeSeriesChartData, DateTime>(
          animationDuration: 0,
          dataSource: outcomeMeasureChartSigDiffMap[outcomeMeasure.rawName]!,
          xValueMapper: (TimeSeriesChartData data, _) => data.date,
          yValueMapper: (TimeSeriesChartData data, _) => data.dataList[0].value,
          pointColorMapper: (TimeSeriesChartData data, _) => data.color,
          markerSettings: const MarkerSettings(height: 6, width: 6),
          enableTooltip: false,
          isVisibleInLegend: false));
    }

    return lines;
  }

  Future<List<OutcomeMeasure>> getOutcomeMeasureHistory(
      OutcomeMeasure outcomeMeasure) async {
    List<OutcomeMeasure> outcomeMeasures = [];

    if (isDemo) {
      return currentPatient!.encounters!
          .expand((encounter) => encounter.outcomeMeasures!)
          .where((om) => om.id == outcomeMeasure.id)
          .toList();
    } else {
      try {
        outcomeMeasures = await _apiService.getOutcomeMeasureHistory(
            http.Client(), currentPatient!, outcomeMeasure);

        outcomeMeasures.sort((a, b) => a.outcomeMeasureCreatedTime!
            .compareTo(b.outcomeMeasureCreatedTime!));
        return outcomeMeasures;
      } catch (e) {
        handleHTTPError(e);
        rethrow;
      }
    }
  }

  void onToggleSigDif(bool value, int index) {
    isSigDiffOn[index] = value;
    notifyListeners();
  }
}
