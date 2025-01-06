import 'package:flutter/material.dart';
import 'package:biot/ui/common/app_colors.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'confirm_alert_dialog_model.dart';

class ConfirmAlertDialog extends StackedView<ConfirmAlertDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmAlertDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    ConfirmAlertDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    request.title ?? 'Hello Stacked Dialog!!',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (request.description != null) ...[
                  verticalSpaceTiny,
                  Text(
                    request.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kcMediumGrey,
                    ),
                    maxLines: 3,
                    softWrap: true,
                  ),
                ],
              ],
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (request.secondaryButtonTitle != null)
                  GestureDetector(
                    onTap: () {
                      completer(DialogResponse(confirmed: true));
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        request.secondaryButtonTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () => completer(DialogResponse(confirmed: false)),
                  child: Container(
                    height: 50,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      request.mainButtonTitle!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  ConfirmAlertDialogModel viewModelBuilder(BuildContext context) =>
      ConfirmAlertDialogModel();
}
