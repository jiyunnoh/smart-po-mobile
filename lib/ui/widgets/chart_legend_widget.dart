import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../common/ui_helpers.dart';
import 'domain_comparison_legend.dart';
import 'domain_legend.dart';
import 'outcome_measure_legend.dart';

class ChartLegendWidget extends ViewModelWidget<InsightsViewModel> {
  const ChartLegendWidget({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Prioritization toggle
            Visibility(
              visible: (viewModel.isSelectedEncounter
                      .where((element) => element == true)
                      .length ==
                  1),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.percent,
                          size: 20.0,
                        ),
                        horizontalSpaceSmall,
                        Text('Prioritized'),
                      ],
                    ),
                    Switch(
                      value: viewModel.isWeighted,
                      activeColor: Colors.blue,
                      onChanged: (bool value) =>
                          viewModel.onToggleWeighted(value),
                    ),
                  ],
                ),
              ),
            ),
            // Significant difference toggle
            if (viewModel.pieSectionInFocus != -1)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '†',
                          style: TextStyle(fontSize: 20),
                        ),
                        horizontalSpaceSmall,
                        Text('Significant Diffs'),
                      ],
                    ),
                    Switch(
                      value: viewModel.isSigDiffOn,
                      activeColor: Colors.blue,
                      onChanged: (bool value) =>
                          viewModel.onToggleSigDiff(value),
                    ),
                  ],
                ),
              ),
          ],
        ),
        // Chart legend for all domains
        if (viewModel.pieSectionInFocus == -1)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Opacity(
                            opacity: 0, child: viewModel.chartLegends[0].icon),
                        horizontalSpaceSmall,
                        const Text(
                          'Domain',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 130,
                      child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                            children: [
                              TextSpan(
                                text: (viewModel.olderEncounter != null)
                                    ? (viewModel.isComparisonOn)
                                        ? 'Change'
                                        : 'Score'
                                    : 'Score',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54),
                              ),
                              TextSpan(
                                text: (viewModel.olderEncounter != null &&
                                        viewModel.isComparisonOn)
                                    ? ' [Sig MEAS]'
                                    : '',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
              ),
              if (viewModel.currentPatient!.encounterCollection
                          .compareEncounterForAnalytics() !=
                      null &&
                  viewModel.isComparisonOn)
                for (int i = 0;
                    i <
                        viewModel.currentPatient!.encounterCollection
                            .compareEncounterForAnalytics()!
                            .domainComparisons
                            .length;
                    i++)
                  DomainComparisonLegend(i),
              if (!viewModel.isComparisonOn)
                for (int i = 0; i < viewModel.chartLegends.length; i++)
                  DomainLegend(i)
            ],
          ),
        // Chart legend for selected domain
        if (viewModel.pieSectionInFocus != -1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Opacity(
                          opacity: 0,
                          child: viewModel
                              .chartLegends[viewModel.pieSectionInFocus].icon,
                        ),
                        horizontalSpaceSmall,
                        Text(
                          viewModel.chartLegends[viewModel.pieSectionInFocus]
                              .domainType.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    Text(
                      (viewModel.olderEncounter != null)
                          ? (viewModel.isComparisonOn)
                              ? 'Change'
                              : 'Score'
                          : 'Score',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 0.5,
              ),
              for (int i = 0;
                  i <
                      viewModel
                          .newerEncounter!
                          .domains[viewModel.pieSectionInFocus]
                          .outcomeMeasures
                          .length;
                  i++)
                OutcomeMeasureLegend(i),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Text((viewModel
                            .newerEncounter!
                            .domains[viewModel.pieSectionInFocus]
                            .outcomeMeasures
                            .any((element) =>
                                element.info.sigDiffPositive == null)) &&
                        viewModel.isSigDiffOn
                    ? '** Significant Diffs Unavailable'
                    : ''),
              )
            ],
          )
      ],
    );
  }
}
