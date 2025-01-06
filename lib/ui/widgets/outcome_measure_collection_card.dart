import 'package:biot/model/outcome_measure_collection.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:biot/ui/views/outcome_measure_select/outcome_measure_select_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants/images.dart';

class OutcomeMeasureCollectionCard
    extends ViewModelWidget<OutcomeMeasureSelectViewModel> {
  final OutcomeMeasureCollection outcomeMeasureCollection;

  const OutcomeMeasureCollectionCard(this.outcomeMeasureCollection,
      {super.key});

  @override
  Widget build(BuildContext context, OutcomeMeasureSelectViewModel viewModel) {
    return GestureDetector(
      onTap: () =>
          viewModel.onSelectOutcomeMeasureCollection(outcomeMeasureCollection),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            outcomeMeasureCollection.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          if (outcomeMeasureCollection.isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              children: [
                                pieChartIcon,
                                Text(
                                  '${outcomeMeasureCollection.outcomeMeasuresMapByDomainType.length.toString()} Domains',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          verticalSpaceSmall,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.file_copy_outlined,
                                  size: 22,
                                ),
                                horizontalSpaceTiny,
                                Text(
                                  '${outcomeMeasureCollection.outcomeMeasures.length.toString()} Outcome Measures',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          verticalSpaceSmall,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: 'Patient',
                                    preferBelow: false,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.person, size: 22),
                                        horizontalSpaceTiny,
                                        Column(
                                          children: [
                                            Text(
                                              '${outcomeMeasureCollection.patientTimeToComplete.toString()} min',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: 'Assistant',
                                    preferBelow: false,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.assignment_outlined,
                                            size: 22),
                                        horizontalSpaceTiny,
                                        Column(
                                          children: [
                                            Text(
                                              '${outcomeMeasureCollection.assistantTimeToComplete.toString()} min',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: 'Clinician',
                                    preferBelow: false,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icon-stethoscope.png',
                                            scale: 26.0),
                                        horizontalSpaceTiny,
                                        Column(
                                          children: [
                                            Text(
                                              '${outcomeMeasureCollection.clinicianTimeToComplete.toString()} min',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () => viewModel.showCollectionInfoBottomSheet(
                            outcomeMeasureCollection),
                        child: Container(
                          color: Colors.black,
                          height: 35,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.white,
                              ),
                              horizontalSpaceTiny,
                              Text(
                                'Info',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )),
                      const VerticalDivider(
                        color: Colors.white,
                        indent: 5,
                        endIndent: 5,
                        thickness: 1,
                        width: 1,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () => viewModel
                            .onEditCollection(outcomeMeasureCollection),
                        child: Container(
                          color: Colors.black,
                          height: 35,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                              horizontalSpaceTiny,
                              Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )),
                      const VerticalDivider(
                        color: Colors.white,
                        indent: 5,
                        endIndent: 5,
                        thickness: 1,
                        width: 1,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () => viewModel.onSelectOutcomeMeasureCollection(
                            outcomeMeasureCollection),
                        child: Container(
                          color: Colors.black,
                          height: 35,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 20,
                                color: Colors.white,
                              ),
                              horizontalSpaceTiny,
                              Text(
                                'Select',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
