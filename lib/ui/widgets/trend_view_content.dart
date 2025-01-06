import 'package:biot/ui/widgets/trend_line_chart.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../model/comparison.dart';
import '../views/trend/trend_viewmodel.dart';

class TrendViewContent extends ViewModelWidget<TrendViewModel> {
  const TrendViewContent({super.key});

  @override
  Widget build(BuildContext context, TrendViewModel viewModel) {
    return viewModel.encounters.isNotEmpty
        ? viewModel.encounters.length > 1
            ? Column(
                children: [
                  SizedBox(
                    // TODO: recalculate the height based on the device's height
                    height: 460,
                    child: PageView(
                      controller: viewModel.pageController,
                      onPageChanged: (int page) =>
                          viewModel.onPageChanged(page),
                      children: [
                        // Total Score
                        TrendLineChart(viewModel
                            .currentPatient!.encounterCollection
                            .getTotalScoresTrendData()),
                        // Domain Score
                        // TODO: use allDomainTypes. Current codes display domains that latest two encounters have.
                        for (DomainComparison domainComparison in viewModel
                            .currentPatient!.encounterCollection
                            .compareEncounterForAnalytics(forTrendView: true)!
                            .domainComparisons)
                          TrendLineChart(
                            viewModel.currentPatient!.encounterCollection
                                    .getDomainScoresTrendData()[
                                domainComparison.domainType]!,
                            domainComparison: domainComparison,
                          ),
                      ],
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: viewModel.newerEncounter!.domains.length + 1,
                    position: viewModel.currentPage,
                  )
                ],
              )
            : const Text('More than 1 encounter is required to see the trend.')
        : const Text('Please add a new encounter to see the trend.');
  }
}
