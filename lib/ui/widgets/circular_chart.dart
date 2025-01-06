import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/images.dart';
import '../../model/chart_data.dart';
import '../common/app_colors.dart';
import '../common/constants.dart';
import 'arc_painter.dart';

class CircularChart extends ViewModelWidget<InsightsViewModel> {
  const CircularChart({super.key, super.reactive = false});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Container(
      decoration: const BoxDecoration(),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ReactiveChart(),
          ],
        ),
      ),
    );
  }
}

class ReactiveChart extends ViewModelWidget<InsightsViewModel> {
  const ReactiveChart({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // outline border should be reactive depending on isPrioritized bool value.
        const OutlineBorder(),
        // domain chart
        const DomainChart(),
        // om chart
        const OmChart(),
        // older domain chart border
        if (viewModel.olderEncounter != null) const OlderDomainChartBorder(),
        // newer domain chart border
        if (viewModel.newerEncounter != null) const NewerDomainChartBorder(),
        // older om chart border
        if (viewModel.olderEncounter != null) const OlderOmChartBorder(),
        // newer om chart border
        if (viewModel.newerEncounter != null) const NewerOmChartBorder(),
        // sig diff line
        const SigDiffLine(),
        // Total Score
        const TotalScore(),
        // transparent hit box should be reactive depending on isPrioritized bool value.
        const HitBox()
      ],
    );
  }
}

class OutlineBorder extends ViewModelWidget<InsightsViewModel> {
  const OutlineBorder({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return SfCircularChart(
      series: <CircularSeries>[
        DoughnutSeries<CircularChartData, String>(
          radius: '$doughnutRadius%',
          innerRadius: '$innerDoughnutRadius%',
          strokeColor: Colors.grey.shade400,
          strokeWidth: 1,
          animationDuration: 0,
          dataSource: viewModel.emptyCircularData,
          xValueMapper: (CircularChartData data, _) => data.domainName,
          yValueMapper: (CircularChartData data, _) =>
              (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
          pointColorMapper: (CircularChartData data, _) => data.color,
        )
      ],
      margin: EdgeInsets.zero,
    );
  }
}

class DomainChart extends ViewModelWidget<InsightsViewModel> {
  const DomainChart({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return SfCircularChart(
      key: const Key('domainChart'),
      series: <CircularSeries>[
        DoughnutSeries<CircularChartData, String>(
          animationDuration: 0,
          radius: '$doughnutRadius%',
          innerRadius: '$innerDoughnutRadius%',
          dataSource: viewModel.currentEncounterData,
          xValueMapper: (CircularChartData data, _) => data.domainName,
          yValueMapper: (CircularChartData data, _) =>
              (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
          pointRadiusMapper: (CircularChartData data, _) => '${data.radius}%',
          pointColorMapper: (CircularChartData data, _) => data.color,
          dataLabelMapper: (CircularChartData data, _) => data.domainName,
          selectionBehavior: viewModel.domainSelectionBehavior,
        )
      ],
      margin: EdgeInsets.zero,
    );
  }
}

class OmChart extends ViewModelWidget<InsightsViewModel> {
  const OmChart({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Opacity(
      opacity: viewModel.pieSectionInFocus == -1 ? 0 : 1.0,
      child: SfCircularChart(
        key: const Key('omChart'),
        series: <CircularSeries>[
          DoughnutSeries<CircularChartData, String>(
            animationDuration: 0,
            startAngle: viewModel.startAngle.round(),
            endAngle: viewModel.endAngle.round(),
            radius: '$doughnutRadius%',
            innerRadius: '$innerDoughnutRadius%',
            dataSource: viewModel.currentOutcomeMeasureData,
            xValueMapper: (CircularChartData data, _) => data.domainName,
            yValueMapper: (CircularChartData data, _) =>
                (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
            pointRadiusMapper: (CircularChartData data, _) => '${data.radius}%',
            pointColorMapper: (CircularChartData data, _) => data.color,
            dataLabelMapper: (CircularChartData data, _) => data.domainName,
          )
        ],
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class NewerDomainChartBorder extends ViewModelWidget<InsightsViewModel> {
  const NewerDomainChartBorder({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Opacity(
      opacity: viewModel.pieSectionInFocus == -1 ? 1 : 0,
      child: SfCircularChart(
        key: const Key('newerDomainChart'),
        series: <CircularSeries>[
          DoughnutSeries<CircularChartData, String>(
            strokeColor: kcNewerEncounterColor,
            strokeWidth: 3,
            animationDuration: 0,
            radius: '$doughnutRadius%',
            innerRadius: '$innerDoughnutRadius%',
            dataSource: viewModel.newerEncounter!.getEncounterCircularData(),
            xValueMapper: (CircularChartData data, _) => data.domainName,
            yValueMapper: (CircularChartData data, _) =>
                (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
            pointRadiusMapper: (CircularChartData data, _) => '${data.radius}%',
            pointColorMapper: (CircularChartData data, _) => Colors.transparent,
            dataLabelMapper: (CircularChartData data, _) => data.domainName,
          )
        ],
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class OlderDomainChartBorder extends ViewModelWidget<InsightsViewModel> {
  const OlderDomainChartBorder({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Opacity(
      opacity: viewModel.pieSectionInFocus == -1 ? 1 : 0,
      child: SfCircularChart(
        key: const Key('comparisonChart'),
        series: <CircularSeries>[
          DoughnutSeries<CircularChartData, String>(
            strokeColor: kcOlderEncounterColor,
            strokeWidth: 3,
            animationDuration: 0,
            radius: '$doughnutRadius%',
            innerRadius: '$innerDoughnutRadius%',
            dataSource: viewModel.olderEncounter!.getEncounterCircularData(),
            xValueMapper: (CircularChartData data, _) => data.domainName,
            yValueMapper: (CircularChartData data, _) =>
                (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
            pointRadiusMapper: (CircularChartData data, _) => '${data.radius}%',
            pointColorMapper: (CircularChartData data, _) => Colors.transparent,
            dataLabelMapper: (CircularChartData data, _) => data.domainName,
          )
        ],
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class NewerOmChartBorder extends ViewModelWidget<InsightsViewModel> {
  const NewerOmChartBorder({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Opacity(
      opacity: (viewModel.pieSectionInFocus == -1) ? 0 : 1,
      child: SfCircularChart(
        key: const Key('omNewerChart'),
        series: <CircularSeries>[
          DoughnutSeries<CircularChartData, String>(
            strokeColor: kcNewerEncounterColor,
            strokeWidth: 3,
            animationDuration: 0,
            startAngle: viewModel.startAngle.round(),
            endAngle: viewModel.endAngle.round(),
            radius: '$doughnutRadius%',
            innerRadius: '$innerDoughnutRadius%',
            dataSource: viewModel.newerEncounter!.getOutcomeMeasureCircularData(
                viewModel.pieSectionInFocus,
                transparentColor: true),
            xValueMapper: (CircularChartData data, _) => data.domainName,
            yValueMapper: (CircularChartData data, _) =>
                (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
            pointRadiusMapper: (CircularChartData data, _) => '${data.radius}%',
            pointColorMapper: (CircularChartData data, _) => data.color,
            dataLabelMapper: (CircularChartData data, _) => data.domainName,
          )
        ],
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class OlderOmChartBorder extends ViewModelWidget<InsightsViewModel> {
  const OlderOmChartBorder({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Opacity(
      opacity: viewModel.pieSectionInFocus == -1 ? 0 : 1,
      child: SfCircularChart(
        key: const Key('omComparisonChart'),
        series: <CircularSeries>[
          DoughnutSeries<CircularChartData, String>(
            strokeColor: kcOlderEncounterColor,
            strokeWidth: 3,
            animationDuration: 0,
            startAngle: viewModel.startAngle.round(),
            endAngle: viewModel.endAngle.round(),
            radius: '$doughnutRadius%',
            innerRadius: '$innerDoughnutRadius%',
            dataSource: viewModel.olderEncounter!.getOutcomeMeasureCircularData(
                viewModel.pieSectionInFocus,
                transparentColor: true),
            xValueMapper: (CircularChartData data, _) => data.domainName,
            yValueMapper: (CircularChartData data, _) =>
                (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
            pointRadiusMapper: (CircularChartData data, _) => '${data.radius}%',
            pointColorMapper: (CircularChartData data, _) => data.color,
            dataLabelMapper: (CircularChartData data, _) => data.domainName,
          )
        ],
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class TotalScore extends ViewModelWidget<InsightsViewModel> {
  const TotalScore({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Opacity(
      opacity: viewModel.pieSectionInFocus == -1 ? 1 : 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (viewModel.isComparisonOn &&
              viewModel.currentPatient!.encounterCollection
                      .compareEncounterForAnalytics() !=
                  null &&
              viewModel.totalScore != 0)
            Image.asset(
              viewModel.totalScore > 0
                  ? singleArrowUpIcon
                  : singleArrowDownIcon,
              color: viewModel.currentPatient!.encounterCollection
                          .compareEncounterForAnalytics() !=
                      null
                  ? viewModel.totalScore == 0
                      ? Colors.transparent
                      : viewModel.currentPatient!.encounterCollection
                          .compareEncounterForAnalytics()!
                          .changeDirection!
                          .color
                  : Colors.black,
              scale: 2.5,
            ),
          Text(viewModel.totalScore.abs().toString(),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: (viewModel.isComparisonOn &&
                          viewModel.currentPatient!.encounterCollection
                                  .compareEncounterForAnalytics() !=
                              null)
                      ? viewModel.currentPatient!.encounterCollection
                          .compareEncounterForAnalytics()!
                          .changeDirection!
                          .color
                      : Colors.black)),
        ],
      ),
    );
  }
}

class SigDiffLine extends ViewModelWidget<InsightsViewModel> {
  const SigDiffLine({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return CustomPaint(
      painter: ArcPainter(viewModel.pieSectionInFocus,
          viewModel.newerEncounter!, viewModel.olderEncounter,
          isSigDiffOn: viewModel.isSigDiffOn, isWeighted: viewModel.isWeighted),
      size: const Size(300, 300),
    );
  }
}

class HitBox extends ViewModelWidget<InsightsViewModel> {
  const HitBox({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return SfCircularChart(
      series: <CircularSeries>[
        DoughnutSeries<CircularChartData, String>(
          radius: '$doughnutRadius%',
          innerRadius: '$innerDoughnutRadius%',
          strokeColor: Colors.transparent,
          strokeWidth: 1,
          animationDuration: 0,
          dataSource: viewModel.emptyCircularData,
          xValueMapper: (CircularChartData data, _) => data.domainName,
          yValueMapper: (CircularChartData data, _) =>
              (viewModel.isWeighted) ? data.weightedY : data.unweightedY,
          pointColorMapper: (CircularChartData data, _) => data.color,
          onPointTap: (detail) {
            if (detail.pointIndex != null) {
              viewModel.onPieSectionTapped(detail.pointIndex!);
            }
          },
        )
      ],
      margin: EdgeInsets.zero,
    );
  }
}
