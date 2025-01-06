import 'package:biot/constants/app_strings.dart';
import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants/enum.dart';
import '../../constants/images.dart';
import '../../model/outcome_measures/outcome_measure.dart';
import '../common/ui_helpers.dart';

class OutcomeMeasureLegend extends ViewModelWidget<InsightsViewModel> {
  final int index;

  const OutcomeMeasureLegend(this.index, {super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    OutcomeMeasure? olderOutcomeMeasure = viewModel.olderEncounter != null
        ? viewModel.olderEncounter!.domains[viewModel.pieSectionInFocus]
            .outcomeMeasures[index]
        : null;
    OutcomeMeasure newerOutcomeMeasure = viewModel.newerEncounter!
        .domains[viewModel.pieSectionInFocus].outcomeMeasures[index];
    ChangeDirection? outcomeMeasureScoreDiff = olderOutcomeMeasure != null &&
            olderOutcomeMeasure.info.sigDiffPositive != null &&
            olderOutcomeMeasure.info.sigDiffNegative != null
        ? newerOutcomeMeasure.compareScoreAgainstPrev(olderOutcomeMeasure).$2
        : null;
    double? outcomeMeasureScoreChange = olderOutcomeMeasure != null
        ? newerOutcomeMeasure.compareScoreAgainstPrev(olderOutcomeMeasure).$1
        : null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                ksPieSliceIcon,
                scale: 7.0,
                color: viewModel.newerEncounter!
                    .getOutcomeMeasureCircularData(
                        viewModel.pieSectionInFocus)[index]
                    .color,
              ),
              horizontalSpaceSmall,
              if (newerOutcomeMeasure.id == ksProgait)
                const Icon(Icons.bluetooth),
              Text(
                '${newerOutcomeMeasure.id.toUpperCase()}'
                '${(newerOutcomeMeasure.info.sigDiffPositive == null && viewModel.isSigDiffOn) ? '**' : ''}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Opacity(
                opacity: viewModel.isComparisonOn && olderOutcomeMeasure != null
                    ? 1
                    : 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    olderOutcomeMeasure != null &&
                            outcomeMeasureScoreDiff ==
                                ChangeDirection.sigNegative
                        ? sigDiffDownIcon
                        : olderOutcomeMeasure != null &&
                                outcomeMeasureScoreDiff ==
                                    ChangeDirection.sigPositive
                            ? sigDiffUpIcon
                            : olderOutcomeMeasure != null &&
                                    outcomeMeasureScoreChange! > 0
                                ? singleArrowUpIcon
                                : singleArrowDownIcon,
                    color: outcomeMeasureScoreDiff != null
                        ? outcomeMeasureScoreChange == 0
                            ? Colors.transparent
                            : outcomeMeasureScoreDiff.color
                        : Colors.black,
                    scale: 4,
                  ),
                ),
              ),
              Text(
                viewModel.isComparisonOn && olderOutcomeMeasure != null
                    ? outcomeMeasureScoreChange!.round().abs().toString()
                    : viewModel.isOlderCircularChartOn
                        ? olderOutcomeMeasure!
                            .calculateScore()
                            .round()
                            .toString()
                        : newerOutcomeMeasure
                            .calculateScore()
                            .round()
                            .toString(),
                style: TextStyle(
                    color: viewModel.isComparisonOn
                        ? outcomeMeasureScoreDiff?.color
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}
