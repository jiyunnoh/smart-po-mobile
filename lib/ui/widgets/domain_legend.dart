import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../common/ui_helpers.dart';

class DomainLegend extends ViewModelWidget<InsightsViewModel> {
  final int index;

  const DomainLegend(this.index, {super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return InkWell(
      onTap: () => viewModel.onPieSectionTapped(index),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                viewModel.chartLegends[index].icon,
                horizontalSpaceSmall,
                Text(
                  viewModel.chartLegends[index].domainType.displayName,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  viewModel.isOlderCircularChartOn &&
                          viewModel.olderEncounter != null
                      ? viewModel
                          .olderEncounter!
                          .domainsMap[viewModel.chartLegends[index].domainType]!
                          .score!
                          .round()
                          .toString()
                      : viewModel
                          .newerEncounter!
                          .domainsMap[viewModel.chartLegends[index].domainType]!
                          .score!
                          .round()
                          .toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
