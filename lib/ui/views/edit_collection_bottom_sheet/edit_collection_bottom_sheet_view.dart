import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/images.dart';
import '../../common/ui_helpers.dart';
import 'edit_collection_bottom_sheet_viewmodel.dart';

class EditCollectionBottomSheetView
    extends StackedView<EditCollectionBottomSheetViewModel> {
  const EditCollectionBottomSheetView({super.key});

  @override
  Widget builder(
    BuildContext context,
    EditCollectionBottomSheetViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                viewModel.outcomeMeasureCollection.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => viewModel.closeBottomSheet(),
                    icon: const Icon(Icons.close),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    pieChartIcon,
                    horizontalSpaceTiny,
                    Text(
                        '${viewModel.outcomeMeasureCollection.outcomeMeasuresMapByDomainType.length.toString()} Domains'),
                  ],
                ),
                Row(
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
                            Text(
                                '${viewModel.outcomeMeasureCollection.patientTimeToComplete.toString()} min'),
                          ],
                        ),
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
                            Text(
                                '${viewModel.outcomeMeasureCollection.assistantTimeToComplete.toString()} min'),
                          ],
                        ),
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
                            Text(
                                '${viewModel.outcomeMeasureCollection.clinicianTimeToComplete.toString()} min'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Expanded(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: viewModel
                      .outcomeMeasureCollection.tempOutcomeMeasures.length,
                  itemBuilder: (context, index) {
                    List<OutcomeMeasure> outcomeMeasures =
                        viewModel.outcomeMeasureCollection.tempOutcomeMeasures;
                    return ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 20,
                      leading: IconButton(
                        onPressed: () =>
                            viewModel.navigateToInfoBottomSheetView(
                                outcomeMeasures[index]),
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(),
                      ),
                      title: outcomeMeasures[index].familyName != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  outcomeMeasures[index].familyName!,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black54),
                                ),
                                Text(
                                  '${outcomeMeasures[index].name} (${outcomeMeasures[index].shortName})',
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            )
                          : Text(
                              '${outcomeMeasures[index].name} (${outcomeMeasures[index].shortName})',
                              style: const TextStyle(fontSize: 14),
                            ),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          backgroundColor:
                              outcomeMeasures[index].domainType.color,
                          label: Text(
                            outcomeMeasures[index].domainType.displayName,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () =>
                            viewModel.removeOutcomeMeasureFromCollection(
                                outcomeMeasures[index]),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 0,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () =>
                        viewModel.navigateToAddOutcomeMeasureBottomSheetView(),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          GestureDetector(
            onTap: () => viewModel.save(),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              child: const Center(
                  child: Text(
                'Save',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
            ),
          ),
          verticalSpaceSmall
        ],
      ),
    );
  }

  @override
  EditCollectionBottomSheetViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EditCollectionBottomSheetViewModel();
}
