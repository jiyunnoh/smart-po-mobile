import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/ui/widgets/outcome_measure_info.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/ui_helpers.dart';
import 'outcome_measure_info_bottom_sheet_viewmodel.dart';

class OutcomeMeasureInfoBottomSheetView
    extends StackedView<OutcomeMeasureInfoBottomSheetViewModel> {
  const OutcomeMeasureInfoBottomSheetView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OutcomeMeasureInfoBottomSheetViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              const Text(
                'Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              )
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                viewModel.outcomeMeasure.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Expanded(
              child: viewModel.dataReady
                  ? OutcomeMeasureInfo(viewModel.outcomeMeasure)
                  : const Center(child: CircularProgressIndicator())),
          verticalSpaceLarge,
        ],
      ),
    );
  }

  @override
  OutcomeMeasureInfoBottomSheetViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final OutcomeMeasure arguments =
        ModalRoute.of(context)!.settings.arguments as OutcomeMeasure;
    return OutcomeMeasureInfoBottomSheetViewModel(outcomeMeasure: arguments);
  }
}
