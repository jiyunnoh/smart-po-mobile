import 'package:biot/constants/enum.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/ui/views/patient_app_bar/patient_app_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/images.dart';
import '../../../model/outcome_measures/progait.dart';
import '../../../model/view_arguments.dart';
import '../../common/ui_helpers.dart';
import 'om_detail_viewmodel.dart';

class OmDetailView extends StackedView<OmDetailViewModel> {
  const OmDetailView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OmDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: PatientAppBarView(viewModel.currentPatient),
      body: (viewModel.dataReady)
          ? Container(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewModel.domainType.displayName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    verticalSpaceSmall,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (viewModel.domainComparison != null)
                          for (int i = 0;
                              i <
                                  viewModel.domainComparison!
                                      .outcomeMeasureComparisons.length;
                              i++)
                            _buildTrendCard(viewModel, i)
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Column _buildTrendCard(OmDetailViewModel viewModel, int i) {
    return Column(
      children: [
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.outcomeMeasureComparisonList[i].newer.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        viewModel.outcomeMeasureComparisonList[i].newer.id ==
                                ksProgait
                            ? _buildProGaitScore(viewModel, i)
                            : Row(
                                children: [
                                  if (viewModel.outcomeMeasureComparisonList[i]
                                              .rawScoreChangeDirection !=
                                          null &&
                                      viewModel.outcomeMeasureComparisonList[i]
                                              .newer.info.sigDiffPositive !=
                                          null &&
                                      viewModel.outcomeMeasureComparisonList[i]
                                              .newer.info.sigDiffNegative !=
                                          null &&
                                      viewModel.outcomeMeasureComparisonList[i]
                                              .rawScoreChange! !=
                                          0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Image.asset(
                                        viewModel
                                                    .outcomeMeasureComparisonList[
                                                        i]
                                                    .rawScoreChangeDirection ==
                                                ChangeDirection.sigPositive
                                            ? sigDiffUpIcon
                                            : viewModel
                                                        .outcomeMeasureComparisonList[
                                                            i]
                                                        .rawScoreChangeDirection ==
                                                    ChangeDirection.sigNegative
                                                ? sigDiffDownIcon
                                                : viewModel
                                                            .outcomeMeasureComparisonList[
                                                                i]
                                                            .rawScoreChange! >
                                                        0
                                                    ? singleArrowUpIcon
                                                    : singleArrowDownIcon,
                                        color: viewModel
                                                    .outcomeMeasureComparisonList[
                                                        i]
                                                    .rawScoreChangeDirection !=
                                                null
                                            ? viewModel
                                                .outcomeMeasureComparisonList[i]
                                                .rawScoreChangeDirection!
                                                .color
                                            : Colors.black,
                                        scale: viewModel
                                                    .outcomeMeasureComparisonList[
                                                        i]
                                                    .rawScoreChangeDirection ==
                                                ChangeDirection.stable
                                            ? 2.5
                                            : 4,
                                      ),
                                    ),
                                  if (viewModel.outcomeMeasureComparisonList[i]
                                              .rawScoreChangeDirection !=
                                          null &&
                                      viewModel.outcomeMeasureComparisonList[i]
                                              .newer.info.sigDiffPositive ==
                                          null &&
                                      viewModel.outcomeMeasureComparisonList[i]
                                              .newer.info.sigDiffNegative ==
                                          null &&
                                      viewModel.outcomeMeasureComparisonList[i]
                                              .rawScoreChange! !=
                                          0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Image.asset(
                                        viewModel.outcomeMeasureComparisonList[i]
                                                    .rawScoreChange! >
                                                0
                                            ? singleArrowUpIcon
                                            : singleArrowDownIcon,
                                        color: viewModel
                                                    .outcomeMeasureComparisonList[
                                                        i]
                                                    .rawScoreChangeDirection ==
                                                ChangeDirection.negative
                                            ? Colors.red
                                            : viewModel
                                                        .outcomeMeasureComparisonList[
                                                            i]
                                                        .rawScoreChangeDirection ==
                                                    ChangeDirection.positive
                                                ? Colors.green
                                                : Colors.black,
                                        scale: 2.5,
                                      ),
                                    ),
                                  Text(
                                    '${viewModel.outcomeMeasureComparisonList[i].rawScoreChange!.abs().toStringAsFixed(viewModel.outcomeMeasureComparisonList[i].newer.info.significantFigures ?? 0)} ${viewModel.outcomeMeasureComparisonList[i].newer.info.yAxisUnit ?? ''}',
                                    style: TextStyle(
                                        color: viewModel
                                                    .outcomeMeasureComparisonList[
                                                        i]
                                                    .rawScoreChangeDirection !=
                                                null
                                            ? viewModel
                                                .outcomeMeasureComparisonList[i]
                                                .rawScoreChangeDirection!
                                                .color
                                            : Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.currentPatient!.encounterCollection
                                          .encounters.length >
                                      1
                                  ? 'Since last visit'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              viewModel.currentPatient!.encounterCollection
                                          .encounters.length >
                                      1
                                  ? '${(viewModel.currentPatient!.encounterCollection.lastEncounter!.encounterCreatedTime!.difference(viewModel.currentPatient!.encounterCollection.encounters[1].encounterCreatedTime!).inDays / 30).round().toString()}mo ago'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                    if (viewModel.outcomeMeasureComparisonList[i].newer.info
                            .sigDiffNegative !=
                        null)
                      Row(
                        children: [
                          const Text(
                            'Significant Diffs',
                          ),
                          horizontalSpaceTiny,
                          Switch(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: viewModel.isSigDiffOn[i],
                              onChanged: (bool newValue) =>
                                  viewModel.onToggleSigDif(newValue, i))
                        ],
                      ),
                  ],
                ),
                _buildSfCartesianChart(
                    viewModel.outcomeMeasureComparisonList[i].newer,
                    i,
                    viewModel),
              ],
            ),
          ),
        ),
        verticalSpaceSmall,
      ],
    );
  }

  Row _buildProGaitScore(OmDetailViewModel viewModel, int i) {
    double apChange = (viewModel.fromLastEncounter as ProGait)
            .prosthesisDynamicsAP -
        (viewModel.fromSecondToLastEncounter as ProGait).prosthesisDynamicsAP;
    double tsChange =
        (viewModel.fromLastEncounter as ProGait).temporalSymmetry -
            (viewModel.fromSecondToLastEncounter as ProGait).temporalSymmetry;
    return Row(
      children: [
        Row(
          children: [
            const Text(
              'Prosthesis\nDynamics A/P',
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset(
                apChange > 0 ? singleArrowUpIcon : singleArrowDownIcon,
                color: apChange < 0
                    ? Colors.red
                    : apChange > 0
                    ? Colors.green
                    : Colors.black,
                scale: 2.5,
              ),
            ),
            Text(
              '${apChange.abs().toStringAsFixed(viewModel.outcomeMeasureComparisonList[i].newer.info.significantFigures ?? 0)} ${viewModel.outcomeMeasureComparisonList[i].newer.info.yAxisUnit ?? ''}',
              style: TextStyle(
                  color: apChange < 0
                      ? Colors.red
                      : apChange > 0
                      ? Colors.green
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        horizontalSpaceLarge,
        Row(
          children: [
            const Text(
              'Prosthesis\nDynamics M/L',
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset(
                viewModel.outcomeMeasureComparisonList[i].rawScoreChange! > 0
                    ? singleArrowUpIcon
                    : singleArrowDownIcon,
                color: viewModel.outcomeMeasureComparisonList[i]
                    .rawScoreChangeDirection ==
                    ChangeDirection.negative
                    ? Colors.red
                    : viewModel.outcomeMeasureComparisonList[i]
                    .rawScoreChangeDirection ==
                    ChangeDirection.positive
                    ? Colors.green
                    : Colors.black,
                scale: 2.5,
              ),
            ),
            Text(
              '${viewModel.outcomeMeasureComparisonList[i].rawScoreChange!.abs().toStringAsFixed(viewModel.outcomeMeasureComparisonList[i].newer.info.significantFigures ?? 0)} ${viewModel.outcomeMeasureComparisonList[i].newer.info.yAxisUnit ?? ''}',
              style: TextStyle(
                  color: viewModel.outcomeMeasureComparisonList[i]
                      .rawScoreChangeDirection !=
                      null
                      ? viewModel.outcomeMeasureComparisonList[i]
                      .rawScoreChangeDirection!.color
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        horizontalSpaceLarge,
        Row(
          children: [
            const Text(
              'Temporal\nSymmetry',
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset(
                tsChange > 0 ? singleArrowUpIcon : singleArrowDownIcon,
                color: tsChange < 0
                    ? Colors.red
                    : tsChange > 0
                        ? Colors.green
                        : Colors.black,
                scale: 2.5,
              ),
            ),
            Text(
              '${tsChange.abs().toStringAsFixed(viewModel.outcomeMeasureComparisonList[i].newer.info.significantFigures ?? 0)} ${viewModel.outcomeMeasureComparisonList[i].newer.info.yAxisUnit ?? ''}',
              style: TextStyle(
                  color: tsChange < 0
                      ? Colors.red
                      : tsChange > 0
                          ? Colors.green
                          : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  SfCartesianChart _buildSfCartesianChart(
      OutcomeMeasure outcomeMeasure, int index, OmDetailViewModel viewModel) {
    return SfCartesianChart(
      legend: Legend(
        position: LegendPosition.bottom,
        isVisible: outcomeMeasure.numOfGraph > 1 ? true : false,
      ),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        minimum: viewModel
            .currentPatient!.encounterCollection.firstEncounterFormattedTime,
        maximum: viewModel.currentPatient!.encounterCollection.lastEncounter!
            .encounterCreatedTime,
        visibleMaximum: viewModel.currentPatient!.encounterCollection
            .lastEncounter!.encounterCreatedTime!
            .add(Duration(
                hours: 6 +
                    (viewModel.currentPatient!.encounterCollection
                            .lastEncounter!.encounterCreatedTime!
                            .difference(viewModel
                                .currentPatient!
                                .encounterCollection
                                .firstEncounterFormattedTime)
                            .inDays)
                        .round())),
        dateFormat: DateFormat('MM/dd\nyyyy'),
      ),
      primaryYAxis: NumericAxis(
          name: 'primaryYAxis',
          isInversed: outcomeMeasure.info.shouldReverse,
          title: AxisTitle(text: outcomeMeasure.chartYAxisTitle),
          labelFormat: '{value}',
          axisLine: const AxisLine(width: 0),
          minimum: outcomeMeasure.info.minYValue,
          maximum: outcomeMeasure.info.maxYValue,
          interval: outcomeMeasure.info.yAxisInterval,
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      axes: <ChartAxis>[
        NumericAxis(
            isVisible: true,
            name: 'secondaryYAxis',
            opposedPosition: true,
            minimum: 50,
            maximum: 150,
            interval: 20,
            labelStyle: const TextStyle(color: Colors.purple),
            title: AxisTitle(text: 'Temporal Symmetry'))
      ],
      series: viewModel.getOmHistoryGraph(outcomeMeasure, index),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  @override
  OmDetailViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final OmDetailViewArguments arguments =
        ModalRoute.of(context)!.settings.arguments as OmDetailViewArguments;
    return OmDetailViewModel(
        domainType: arguments.domainType,
        outcomeMeasures: arguments.outcomeMeasures);
  }
}
