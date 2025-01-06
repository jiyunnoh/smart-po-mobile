import 'package:biot/model/comparison.dart';
import 'package:biot/ui/widgets/sig_diff_indication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/images.dart';
import '../../model/chart_data.dart';
import '../common/ui_helpers.dart';
import '../views/trend/trend_viewmodel.dart';

class TrendLineChart extends ViewModelWidget<TrendViewModel> {
  final DomainComparison? domainComparison;
  final List<TimeSeriesChartData> data;

  const TrendLineChart(this.data, {this.domainComparison, super.key});

  @override
  Widget build(BuildContext context, TrendViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (domainComparison != null)
                  ? domainComparison!.newer.type.displayName
                  : 'Total Score',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (domainComparison == null &&
                    viewModel.totalScoreChangeDirectionFromTrendView != null &&
                    viewModel.totalScoreForTrendView != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.asset(
                        viewModel.totalScoreForTrendView! > 0
                            ? singleArrowUpIcon
                            : singleArrowDownIcon,
                        color: viewModel.totalScoreForTrendView == 0
                            ? Colors.transparent
                            : viewModel
                                .totalScoreChangeDirectionFromTrendView?.color,
                        scale: 2.5,
                      )),
                if (domainComparison != null &&
                    domainComparison!.changeDirection != null &&
                    domainComparison!.scoreChange != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.asset(
                        domainComparison!.scoreChange! > 0
                            ? singleArrowUpIcon
                            : singleArrowDownIcon,
                        color: domainComparison!.scoreChange == 0
                            ? Colors.transparent
                            : domainComparison!.changeDirection?.color,
                        scale: 2.5,
                      )),
                if (domainComparison == null)
                  Text(
                      viewModel.totalScoreForTrendView!
                          .round()
                          .abs()
                          .toString(),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: viewModel
                                      .totalScoreChangeDirectionFromTrendView !=
                                  null
                              ? viewModel
                                  .totalScoreChangeDirectionFromTrendView!.color
                              : Colors.black)),
                if (domainComparison != null)
                  Text(domainComparison!.scoreChange!.abs().round().toString(),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: domainComparison!.changeDirection != null
                              ? domainComparison!.changeDirection?.color
                              : Colors.black)),
                if (domainComparison != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SigDiffIndication(domainComparison!),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.encounters.length > 1 ? 'Since last visit' : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  viewModel.encounters.length > 1
                      ? '${(viewModel.currentPatient!.encounterCollection.lastEncounter!.encounterCreatedTime!.difference(viewModel.encounters[1].encounterCreatedTime!).inDays / 30).round().toString()}mo ago'
                      : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
        verticalSpaceSmall,
        // line graph
        SfCartesianChart(
          legend: Legend(
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap),
          primaryXAxis: DateTimeAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            minimum: viewModel.currentPatient!.encounterCollection
                .firstEncounterFormattedTime,
            maximum: viewModel.currentPatient!.encounterCollection
                .lastEncounter!.encounterCreatedTime,
            dateFormat: DateFormat('MM/dd\nyyyy'),
          ),
          primaryYAxis: NumericAxis(
              labelFormat: '{value}',
              axisLine: const AxisLine(width: 0),
              minimum: 0,
              maximum: 100,
              interval: 20,
              majorTickLines: const MajorTickLines(color: Colors.transparent)),
          series: viewModel.getTrendLineSeries(data,
              domainComparison: domainComparison),
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
        // launch point to outcome measure trend view only in domain comparison
        if (domainComparison != null)
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => viewModel
                  .navigateToOmDetailView(domainComparison!.domainType),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black)),
              child: const Text(
                'See Outcome Measures',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
      ],
    );
  }
}
