import 'package:biot/ui/views/bottom_sheet_navigator/bottom_sheet_navigator_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'select_outcome_measure_sheet_model.dart';

class SelectOutcomeMeasureSheet
    extends StackedView<SelectOutcomeMeasureSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const SelectOutcomeMeasureSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    SelectOutcomeMeasureSheetModel viewModel,
    Widget? child,
  ) {
    return const BottomSheetNavigatorView();
  }

  @override
  SelectOutcomeMeasureSheetModel viewModelBuilder(BuildContext context) =>
      SelectOutcomeMeasureSheetModel();
}
