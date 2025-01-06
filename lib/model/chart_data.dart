import 'dart:ui';

import 'package:biot/model/encounter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../ui/common/constants.dart';
import 'domain.dart';

class CircularChartData {
  final String domainName;
  num radius;
  num unweightedY;
  num weightedY;
  Color color;
  int numOfOutcomeMeasures;

  double get weightedAngle => (weightedY / 100 * 360);

  CircularChartData(
    this.domainName,
    this.color, {
    required this.radius,
    required this.unweightedY,
    required this.weightedY,
    this.numOfOutcomeMeasures = 1,
  });

  factory CircularChartData.fromDomain(Domain domain, Encounter encounter) {
    double r = (doughnutRadius - innerDoughnutRadius) *
            encounter.domainsMap[domain.type]!.score! /
            doughnutRadius +
        innerDoughnutRadius;
    return CircularChartData(domain.type.displayName, domain.type.color,
        radius: r,
        unweightedY: 100 / encounter.domains.length,
        weightedY:
            encounter.domainWeightDist!.getDomainWeightValue(domain.type),
        numOfOutcomeMeasures: domain.outcomeMeasures.length);
  }

  CircularChartData clone() {
    return CircularChartData(domainName, color,
        radius: radius,
        unweightedY: unweightedY,
        weightedY: weightedY,
        numOfOutcomeMeasures: numOfOutcomeMeasures);
  }

  @override
  String toString() {
    return 'radius: $radius';
  }
}

class TimeSeriesChartData {
  final DateTime date;
  final List<ChartData> dataList;
  final Color? color;

  TimeSeriesChartData({required this.date, required this.dataList, this.color});
}

class ChartData {
  final String? label;
  final double? value;

  ChartData({this.label, this.value});
}

class SliderChartData {
  final String domainName;
  double simpleSliderValue;
  SfRangeValues advancedSliderValues;
  late double advancedSliderRange;
  double normalizedValue;
  Color color;

  SliderChartData(this.domainName, this.simpleSliderValue,
      this.advancedSliderValues, this.normalizedValue, this.color);
}
