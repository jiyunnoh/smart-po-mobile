// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/collection_info/collection_info_sheet.dart';
import '../ui/bottom_sheets/select_outcome_measure/select_outcome_measure_sheet.dart';

enum BottomSheetType {
  selectOutcomeMeasure,
  collectionInfo,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.selectOutcomeMeasure: (context, request, completer) =>
        SelectOutcomeMeasureSheet(request: request, completer: completer),
    BottomSheetType.collectionInfo: (context, request, completer) =>
        CollectionInfoSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
