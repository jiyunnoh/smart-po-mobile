import 'package:biot/constants/enum.dart';
import 'package:biot/model/outcome_measure_collection.dart';
import 'package:flutter/material.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../constants/images.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import 'collection_info_sheet_model.dart';

class CollectionInfoSheet extends StackedView<CollectionInfoSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const CollectionInfoSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    CollectionInfoSheetModel viewModel,
    Widget? child,
  ) {
    OutcomeMeasureCollection outcomeMeasureCollection = request.data;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                outcomeMeasureCollection.title,
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
                        '${outcomeMeasureCollection.outcomeMeasuresMapByDomainType.length.toString()} Domains'),
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
                                  '${outcomeMeasureCollection.patientTimeToComplete.toString()} min')
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
                              Text(
                                  '${outcomeMeasureCollection.assistantTimeToComplete.toString()} min')
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
                              Text(
                                  '${outcomeMeasureCollection.clinicianTimeToComplete.toString()} min')
                            ]),
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: outcomeMeasureCollection
                  .outcomeMeasuresMapByDomainType.length,
              itemBuilder: (context, index) {
                final DomainType domainType = outcomeMeasureCollection
                    .outcomeMeasuresMapByDomainType.keys
                    .elementAt(index);
                final List<OutcomeMeasure> outcomeMeasures =
                    outcomeMeasureCollection
                        .outcomeMeasuresMapByDomainType[domainType]!;
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        domainType.displayName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      verticalSpaceTiny,
                      for (OutcomeMeasure outcomeMeasure in outcomeMeasures)
                        Text(
                          '${outcomeMeasure.name} (${outcomeMeasure.shortName})',
                          style: TextStyle(
                              color: outcomeMeasure.isActive
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          verticalSpaceSmall
        ],
      ),
    );
  }

  @override
  CollectionInfoSheetModel viewModelBuilder(BuildContext context) =>
      CollectionInfoSheetModel();
}
