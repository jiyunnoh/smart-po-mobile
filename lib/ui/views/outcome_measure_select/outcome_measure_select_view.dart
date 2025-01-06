import 'package:biot/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/images.dart';
import '../../widgets/outcome_measure_tiles.dart';
import '../../widgets/outcome_measure_collection_card.dart';
import 'outcome_measure_select_viewmodel.dart';

class OutcomeMeasureSelectView
    extends StackedView<OutcomeMeasureSelectViewModel> {
  const OutcomeMeasureSelectView({super.key});

  Widget _titleWidget(OutcomeMeasureSelectViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: viewModel.currentPatient != null
              ? Center(
                  child: Text(
                  viewModel.currentPatient!.initial,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ))
              : const Icon(
                  Icons.no_accounts,
                  size: 25,
                  color: Colors.black,
                ),
        ),
        horizontalSpaceSmall,
        Text(
            viewModel.currentPatient != null
                ? viewModel.currentPatient!.fullName
                : 'Anonymous',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _emptySelectionView() {
    return const Center(child: Text('Select Outcome Measures'));
  }

  @override
  Widget builder(
    BuildContext context,
    OutcomeMeasureSelectViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: _titleWidget(viewModel),
        leading: Container(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: viewModel.validateStartEvaluationCriteria,
                child: const Text(
                  'Start',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    pieChartIcon,
                    horizontalSpaceTiny,
                    Text('${viewModel.numOfDomains.toString()} Domains'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        patientIcon,
                        horizontalSpaceTiny,
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Patient'),
                              horizontalSpaceTiny,
                              Text('${viewModel.patientTimeToComplete} min')
                            ]),
                      ],
                    ),
                    horizontalSpaceMedium,
                    Row(
                      children: [
                        assistantIcon,
                        horizontalSpaceTiny,
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Asst'),
                              horizontalSpaceTiny,
                              Text('${viewModel.assistantTimeToComplete} min')
                            ]),
                      ],
                    ),
                    horizontalSpaceMedium,
                    Row(
                      children: [
                        clinicianIcon,
                        horizontalSpaceTiny,
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Clinician'),
                              horizontalSpaceTiny,
                              Text('${viewModel.clinicianTimeToComplete} min')
                            ]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: viewModel.selectedOutcomeMeasures.isNotEmpty
                              ? 125
                              : 70,
                          child: viewModel.selectedOutcomeMeasures.isEmpty
                              ? _emptySelectionView()
                              : const OutcomeMeasureTiles(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                            width: 80,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () =>
                                  viewModel.onSelectOutcomeMeasure(),
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.black, width: 3),
                                  backgroundColor: Colors.white),
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.black,
                                size: 30,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          Expanded(
            child: viewModel.dataReady
                ? Device.get().isTablet
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          double childAspectRatio;
                          if (constraints.maxWidth < 750) {
                            // Small screens (e.g., small tablets)
                            childAspectRatio = 1.8;
                          } else if (constraints.maxWidth < 900) {
                            // Medium screens (e.g., large tablets)
                            childAspectRatio = 2.0;
                          } else {
                            // Large screens (e.g., large tablets, desktop)
                            childAspectRatio = 2.4;
                          }
                          return GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: childAspectRatio,
                            children: viewModel.defaultOutcomeMeasureCollections
                                .map((e) => OutcomeMeasureCollectionCard(e))
                                .toList(),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount:
                            viewModel.defaultOutcomeMeasureCollections.length,
                        itemBuilder: (context, index) => SizedBox(
                            height: 200,
                            child: OutcomeMeasureCollectionCard(viewModel
                                .defaultOutcomeMeasureCollections[index])))
                : const CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  @override
  OutcomeMeasureSelectViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OutcomeMeasureSelectViewModel();
}
