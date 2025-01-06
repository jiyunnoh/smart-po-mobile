import 'package:biot/model/outcome_measure_collection.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../model/outcome_measures/outcome_measure.dart';
import '../views/outcome_measure_select/outcome_measure_select_viewmodel.dart';

class OutcomeMeasureTiles
    extends ViewModelWidget<OutcomeMeasureSelectViewModel> {
  const OutcomeMeasureTiles({super.key});

  @override
  Widget build(BuildContext context, OutcomeMeasureSelectViewModel viewModel) {
    List<dynamic> combinedList = [
      ...viewModel.selectedOutcomeMeasureCollections,
      viewModel.selectedIndividualOutcomeMeasures
    ];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: combinedList.length,
      itemBuilder: (context, index) {
        if (index < combinedList.length - 1) {
          return _buildCollectionTile(combinedList[index], viewModel);
        } else {
          List<OutcomeMeasure> outcomeMeasures = combinedList[index];
          return SizedBox(
            width: 600,
            child: GridView.count(
              childAspectRatio: 0.65,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              children: outcomeMeasures
                  .map((e) => _buildOutcomeMeasureTile(e, viewModel))
                  .toList(),
            ),
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const VerticalDivider(
        width: 10,
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildCollectionTile(OutcomeMeasureCollection outcomeMeasureCollection,
      OutcomeMeasureSelectViewModel viewModel) {
    return Container(
      width: 105,
      height: 125,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
                child: SizedBox(
              height: 35,
              child: Text(
                outcomeMeasureCollection.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.file_copy_outlined,
                  size: 16,
                ),
                horizontalSpaceTiny,
                Expanded(
                    child: Text(
                  '${outcomeMeasureCollection.outcomeMeasures.length} Outcome Measures',
                  softWrap: true,
                  style: const TextStyle(fontSize: 12),
                )),
              ],
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => viewModel.onSelectOutcomeMeasureCollection(
                  outcomeMeasureCollection),
              icon: const Icon(Icons.remove_circle),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeMeasureTile(
      OutcomeMeasure outcomeMeasure, OutcomeMeasureSelectViewModel viewModel) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              outcomeMeasure.shortName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () =>
                  viewModel.onRemoveOutcomeMeasure(outcomeMeasure),
              icon: const Icon(Icons.remove_circle),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
