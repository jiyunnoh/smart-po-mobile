// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/comparison_select/comparison_select_dialog.dart';
import '../ui/dialogs/confirm_alert/confirm_alert_dialog.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/loading_indicator/loading_indicator_dialog.dart';
import '../ui/dialogs/outcome_measure_select_edit/outcome_measure_select_edit_dialog.dart';

enum DialogType {
  infoAlert,
  confirmAlert,
  outcomeMeasureSelectEdit,
  comparisonSelect,
  loadingIndicator,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.confirmAlert: (context, request, completer) =>
        ConfirmAlertDialog(request: request, completer: completer),
    DialogType.outcomeMeasureSelectEdit: (context, request, completer) =>
        OutcomeMeasureSelectEditDialog(request: request, completer: completer),
    DialogType.comparisonSelect: (context, request, completer) =>
        ComparisonSelectDialog(request: request, completer: completer),
    DialogType.loadingIndicator: (context, request, completer) =>
        LoadingIndicatorDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
