import 'package:biot/constants/app_strings.dart';
import 'package:biot/model/outcome_measure_collection.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/images.dart';
import '../../common/ui_helpers.dart';
import 'add_outcome_measure_bottom_sheet_viewmodel.dart';

class AddOutcomeMeasureBottomSheetView
    extends StackedView<AddOutcomeMeasureBottomSheetViewModel> {
  const AddOutcomeMeasureBottomSheetView({super.key});

  @override
  Widget builder(
    BuildContext context,
    AddOutcomeMeasureBottomSheetViewModel viewModel,
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
                viewModel.outcomeMeasureCollection != null
                    ? viewModel.outcomeMeasureCollection!.title
                    : 'Select Outcome Measures',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: viewModel.outcomeMeasureCollection != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (viewModel.outcomeMeasureCollection != null)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
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
                        '${viewModel.outcomeMeasureCollection != null ? viewModel.outcomeMeasureCollection!.outcomeMeasuresMapByDomainType.length.toString() : viewModel.numOfDomains} Domains'),
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
                                '${viewModel.outcomeMeasureCollection != null ? viewModel.outcomeMeasureCollection!.patientTimeToComplete.toString() : viewModel.patientTimeToComplete} min'),
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
                                '${viewModel.outcomeMeasureCollection != null ? viewModel.outcomeMeasureCollection!.assistantTimeToComplete.toString() : viewModel.assistantTimeToComplete} min'),
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
                                '${viewModel.outcomeMeasureCollection != null ? viewModel.outcomeMeasureCollection!.clinicianTimeToComplete.toString() : viewModel.clinicianTimeToComplete} min'),
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
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: viewModel.tempOutcomeMeasures.length,
              itemBuilder: (context, index) {
                if (viewModel.tempOutcomeMeasures[index].id != ksProgait) {
                  return Container(
                    color: viewModel.tempOutcomeMeasures[index].isActive
                        ? Colors.transparent
                        : Colors.black12,
                    child: ListTile(
                      onTap: viewModel.tempOutcomeMeasures[index].isActive
                          ? () => viewModel.selectOutcomeMeasure(
                              viewModel.tempOutcomeMeasures[index])
                          : null,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 20,
                      leading: IconButton(
                        onPressed: viewModel.tempOutcomeMeasures[index].isActive
                            ? () => viewModel.navigateToInfoBottomSheetView(
                                viewModel.tempOutcomeMeasures[index])
                            : null,
                        icon: Icon(
                          Icons.info_outline_rounded,
                          color: viewModel.tempOutcomeMeasures[index].isActive
                              ? Colors.black
                              : null,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(),
                      ),
                      title: viewModel.tempOutcomeMeasures[index].familyName !=
                              null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel
                                      .tempOutcomeMeasures[index].familyName!,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black54),
                                ),
                                Text(
                                  '${viewModel.tempOutcomeMeasures[index].name} (${viewModel.tempOutcomeMeasures[index].shortName})',
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            )
                          : Text(
                              '${viewModel.tempOutcomeMeasures[index].name} (${viewModel.tempOutcomeMeasures[index].shortName})'),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          backgroundColor: viewModel
                              .tempOutcomeMeasures[index].domainType.color,
                          label: Text(
                            viewModel.tempOutcomeMeasures[index].domainType
                                .displayName,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ),
                      trailing: viewModel.tempOutcomeMeasures[index].isActive
                          ? IconButton(
                              onPressed: () =>
                                  viewModel.selectOutcomeMeasure(
                                      viewModel.tempOutcomeMeasures[index]),
                              icon: Icon(
                                viewModel.tempOutcomeMeasures[index].isSelected
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(),
                            )
                          : null,
                    ),
                  );
                } else {
                  return null;
                }
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 0,
              ),
            ),
          ),
          if (viewModel.outcomeMeasureCollection != null)
            GestureDetector(
              onTap: () => viewModel.save(),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
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
  AddOutcomeMeasureBottomSheetViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final OutcomeMeasureCollection? arguments =
        ModalRoute.of(context)?.settings.arguments as OutcomeMeasureCollection?;
    return AddOutcomeMeasureBottomSheetViewModel(
        outcomeMeasureCollection: arguments);
  }
}
