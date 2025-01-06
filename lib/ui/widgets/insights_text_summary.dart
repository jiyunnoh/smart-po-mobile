import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/comparison.dart';
import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:biot/ui/widgets/sig_diff_indication.dart';
import 'package:biot/ui/widgets/text_summary_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InsightsTextSummary extends ViewModelWidget<InsightsViewModel> {
  const InsightsTextSummary({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    final EncounterComparison? encounterComparison = viewModel
        .currentPatient!.encounterCollection
        .compareEncounterForAnalytics();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: viewModel.olderEncounter != null ? 10.0 : 0),
      child: Column(
        children: [
          if (encounterComparison
                  ?.improvedDomainComparisons[ksImproved]!.isNotEmpty ??
              false)
            _buildDomainComparisonsSummary(
                viewModel,
                ksImproved,
                encounterComparison!.improvedDomainComparisons[ksImproved]!,
                context),
          if (encounterComparison
                  ?.declinedDomainComparisons[ksDeclined]!.isNotEmpty ??
              false)
            _buildDomainComparisonsSummary(
                viewModel,
                ksDeclined,
                encounterComparison!.declinedDomainComparisons[ksDeclined]!,
                context),
          if (encounterComparison
                  ?.stableDomainComparisons[ksStable]!.isNotEmpty ??
              false)
            _buildDomainComparisonsSummary(
                viewModel,
                ksStable,
                encounterComparison!.stableDomainComparisons[ksStable]!,
                context),
        ],
      ),
    );
  }

  Column _buildDomainComparisonsSummary(
      InsightsViewModel viewModel,
      String changeDirection,
      List<DomainComparison> domainComparisons,
      BuildContext context) {
    return Column(
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          leading: IconButton(
            icon: Icon(
                changeDirection == ksImproved
                    ? Icons.arrow_circle_up_outlined
                    : changeDirection == ksDeclined
                        ? Icons.arrow_circle_down_outlined
                        : Icons.arrow_circle_right_outlined,
                color: changeDirection == ksImproved
                    ? Colors.green
                    : changeDirection == ksDeclined
                        ? Colors.red
                        : Colors.black,
                size: 46),
            onPressed: changeDirection == ksStable
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (context) => TextSummaryDialog(
                            domainComparisons, changeDirection));
                    viewModel.onPieSectionTapped(-1);
                    viewModel.stopAnimation();
                  },
            padding: EdgeInsets.zero,
          ),
          title: RichText(
            text: TextSpan(children: [
              for (int i = 0; i < domainComparisons.length; i++)
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => viewModel.onPieSectionTapped(
                              domainComparisons[i].domainType.index),
                          child: Chip(
                            backgroundColor: viewModel.pieSectionInFocus == -1
                                ? domainComparisons[i].domainType.color
                                : viewModel.pieSectionInFocus ==
                                        domainComparisons[i].domainType.index
                                    ? domainComparisons[i].domainType.color
                                    : Colors.black12,
                            label: Text(domainComparisons[i].header,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: SigDiffIndication(domainComparisons[i]),
                        ),
                        if (i != domainComparisons.length - 1)
                          const Text(
                            ', ',
                            style: TextStyle(fontSize: 16),
                          )
                      ],
                    )),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    domainComparisons.length == 1 ? 'is' : 'are',
                    style: const TextStyle(fontSize: 16),
                  )),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                      changeDirection == ksImproved
                          ? ' improving'
                          : changeDirection == ksDeclined
                              ? ' declining'
                              : ' stable',
                      style: const TextStyle(fontSize: 16))),
            ]),
          ),
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(
          height: 10,
        ),
      ],
    );
  }
}
