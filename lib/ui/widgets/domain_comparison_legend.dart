import 'package:biot/model/comparison.dart';
import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:biot/ui/widgets/sig_diff_indication.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants/images.dart';
import '../common/ui_helpers.dart';

class DomainComparisonLegend extends ViewModelWidget<InsightsViewModel> {
  final int index;

  const DomainComparisonLegend(this.index, {super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    final DomainComparison domainComparison = viewModel
        .currentPatient!.encounterCollection
        .compareEncounterForAnalytics()!
        .domainComparisons[index];

    return InkWell(
      onTap: () => viewModel.onPieSectionTapped(index),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                domainComparison.newer.icon,
                horizontalSpaceSmall,
                Text(
                  domainComparison.newer.type.displayName,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              width: 85,
              child: Row(
                mainAxisAlignment: viewModel.isComparisonOn
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 55,
                    child: Row(
                      mainAxisAlignment: viewModel.isComparisonOn
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Opacity(
                          opacity: viewModel.isComparisonOn ? 1 : 0,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.asset(
                                viewModel.olderEncounter != null &&
                                        domainComparison.scoreChange! > 0
                                    ? singleArrowUpIcon
                                    : singleArrowDownIcon,
                                color: domainComparison.changeDirection != null
                                    ? domainComparison.scoreChange! == 0
                                        ? Colors.transparent
                                        : domainComparison
                                            .changeDirection!.color
                                    : Colors.black,
                                scale: 3,
                              )),
                        ),
                        Text(
                          viewModel.isComparisonOn &&
                                  viewModel.olderEncounter != null
                              ? '${domainComparison.scoreChange!.round().abs()}'
                              : domainComparison.newer.score!
                                  .round()
                                  .toString(),
                          style: TextStyle(
                              color: viewModel.isComparisonOn &&
                                      viewModel.olderEncounter != null
                                  ? domainComparison.changeDirection!.color
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.isComparisonOn)
                    SigDiffIndication(domainComparison)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
