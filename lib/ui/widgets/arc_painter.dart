import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/enum.dart';
import '../../model/chart_data.dart';
import '../../model/outcome_measures/outcome_measure.dart';
import '../../model/encounter.dart';
import '../common/constants.dart';

class ArcPainter extends CustomPainter {
  final int selectedIndex;
  final Encounter newerEncounter;
  final Encounter? olderEncounter;
  final bool isSigDiffOn;
  final bool isWeighted;

  List<CircularChartData>? get olderEncounterChartData =>
      olderEncounter?.getEncounterCircularData();
  ChangeDirection? outcomeMeasureScoreDiff;

  double get angle => pi * 2 / newerEncounter.domains.length;
  double weightedAngle = 0;

  ArcPainter(this.selectedIndex, this.newerEncounter, this.olderEncounter,
      {required this.isSigDiffOn, this.isWeighted = false});

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint();
    var dotPaint = Paint();

    double startPoint = pi * 3 / 2;
    double? negative;
    double? positive;
    double radius = size.width / 2;

    if (olderEncounter != null) {
      for (int i = 0; i < olderEncounterChartData!.length; i++) {
        if (selectedIndex == i) {
          // Draw a sig diff for the selected domain in comparison
          if (newerEncounter.domains[i].outcomeMeasures.length ==
              olderEncounter!.domains[i].outcomeMeasures.length) {
            double outcomeMeasureAngle = angle;
            outcomeMeasureAngle /=
                olderEncounterChartData![i].numOfOutcomeMeasures;
            for (int j = 0;
                j < olderEncounterChartData![i].numOfOutcomeMeasures;
                j++) {
              OutcomeMeasure? priorOutcomeMeasure = olderEncounter != null
                  ? olderEncounter!.domains[i].outcomeMeasures[j]
                  : null;
              OutcomeMeasure latestOutcomeMeasure =
                  newerEncounter.domains[i].outcomeMeasures[j];

              outcomeMeasureScoreDiff = priorOutcomeMeasure != null &&
                      priorOutcomeMeasure.info.sigDiffPositive != null
                  ? latestOutcomeMeasure
                      .compareScoreAgainstPrev(priorOutcomeMeasure)
                      .$2
                  : null;

              double r = (doughnutRadius - innerDoughnutRadius) *
                      priorOutcomeMeasure!.calculateScore() /
                      doughnutRadius +
                  innerDoughnutRadius;

              // normalize within 0-100
              negative = olderEncounter!.domains[i].outcomeMeasures[j]
                  .normalizeSigDiffNegative();
              positive = olderEncounter!.domains[i].outcomeMeasures[j]
                  .normalizeSigDiffPositive();

              double center = size.width / 2;
              num radians = startPoint + (outcomeMeasureAngle / 2);
              double midOfArcX = center + cos(radians) * (r * 3 / 2);
              double midOfAcrY = center + sin(radians) * (r * 3 / 2);
              Offset midOfArc;

              midOfArc = Offset(midOfArcX, midOfAcrY);

              if (isSigDiffOn && positive != null && negative != null) {
                // normalize with chart radius
                positive = positive /
                    100 *
                    radius *
                    ((doughnutRadius - innerDoughnutRadius) / 100);
                negative = negative /
                    100 *
                    radius *
                    ((doughnutRadius - innerDoughnutRadius) / 100);

                linePaint = Paint()
                  ..color = outcomeMeasureScoreDiff ==
                              ChangeDirection.positive ||
                          outcomeMeasureScoreDiff == ChangeDirection.sigPositive
                      ? Colors.green
                      : outcomeMeasureScoreDiff == ChangeDirection.negative ||
                              outcomeMeasureScoreDiff ==
                                  ChangeDirection.sigNegative
                          ? Colors.red
                          : Colors.black
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1.5;

                dotPaint = Paint()
                  ..color = outcomeMeasureScoreDiff ==
                              ChangeDirection.positive ||
                          outcomeMeasureScoreDiff == ChangeDirection.sigPositive
                      ? Colors.green
                      : outcomeMeasureScoreDiff == ChangeDirection.negative ||
                              outcomeMeasureScoreDiff ==
                                  ChangeDirection.sigNegative
                          ? Colors.red
                          : Colors.black
                  ..style = PaintingStyle.fill;

                // Draw positive sig diff
                canvas.drawLine(
                    midOfArc,
                    Offset(midOfArcX + (positive * cos(radians)),
                        midOfAcrY + (positive * sin(radians))),
                    linePaint);

                // Draw negative sig diff
                canvas.drawLine(
                    Offset(midOfArcX - (negative * cos(radians)),
                        midOfAcrY - (negative * sin(radians))),
                    midOfArc,
                    linePaint);

                // Draw middle point
                canvas.drawCircle(midOfArc, 3, dotPaint);
              }
              startPoint += outcomeMeasureAngle;
            }
          }
        }
        startPoint += angle;
      }
    } else if (isSigDiffOn) {
      linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Draw sig diff for the selected domain in no comparison when it's either prioritized or not.
      for (int i = 0; i < newerEncounter.domains.length; i++) {
        if (newerEncounter.domainWeightDist != null) {
          // print('arc painter encounter.domainWeightDist');
          weightedAngle = newerEncounter.domainWeightDist!
                  .getDomainWeightValue(newerEncounter.domains[i].type) *
              2 *
              pi /
              100;
        }
        if (selectedIndex == i) {
          double outcomeMeasureAngle = (isWeighted) ? weightedAngle : angle;
          outcomeMeasureAngle /=
              newerEncounter.domains[i].outcomeMeasures.length;

          for (int j = 0;
              j < newerEncounter.domains[i].outcomeMeasures.length;
              j++) {
            double r = (doughnutRadius - innerDoughnutRadius) *
                    newerEncounter.domains[i].outcomeMeasures[j]
                        .calculateScore() /
                    doughnutRadius +
                innerDoughnutRadius;

            negative = newerEncounter.domains[i].outcomeMeasures[j]
                .normalizeSigDiffNegative();
            positive = newerEncounter.domains[i].outcomeMeasures[j]
                .normalizeSigDiffPositive();

            double center = size.width / 2;
            num radians = startPoint + (outcomeMeasureAngle / 2);
            double midOfArcX = center + cos(radians) * (r * 3 / 2);
            double midOfAcrY = center + sin(radians) * (r * 3 / 2);
            Offset midOfArc;
            midOfArc = Offset(midOfArcX, midOfAcrY);

            if (positive != null && negative != null) {
              // normalize with chart radius
              positive =
                  positive * (doughnutRadius - innerDoughnutRadius) / 100;
              negative =
                  negative * (doughnutRadius - innerDoughnutRadius) / 100;

              // Draw positive sig diff
              canvas.drawLine(
                  midOfArc,
                  Offset(midOfArcX + (positive * cos(radians)),
                      midOfAcrY + (positive * sin(radians))),
                  linePaint);

              // Draw negative sig diff
              canvas.drawLine(
                  Offset(midOfArcX - (negative * cos(radians)),
                      midOfAcrY - (negative * sin(radians))),
                  midOfArc,
                  linePaint);

              // Draw middle point
              canvas.drawCircle(midOfArc, 3, dotPaint);
            }
            startPoint += outcomeMeasureAngle;
          }
        }
        startPoint += (isWeighted) ? weightedAngle : angle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
