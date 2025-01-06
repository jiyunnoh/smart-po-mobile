import 'package:biot/ui/common/ui_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/encounter.dart';
import 'complete_viewmodel.dart';

class CompleteView extends StackedView<CompleteViewModel> {
  final Encounter encounter;

  const CompleteView(this.encounter, {super.key});

  Future<bool?> progressIndicatorAlert(CompleteViewModel viewModel, context) {
    return Alert(
        context: context,
        style: kAlertStyle,
        title: LocaleKeys.pdfGenProgressTitle.tr(),
        desc: LocaleKeys.pdfGenProgressDesc.tr(),
        onWillPopActive: true,
        buttons: []).show();
  }

  @override
  Widget builder(
    BuildContext context,
    CompleteViewModel viewModel,
    Widget? child,
  ) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Complete'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Congratulations!! You have successfully submitted SMART P&O.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpaceLarge,
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, elevation: 0),
                        onPressed: () async {
                          progressIndicatorAlert(viewModel, context);
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          viewModel.exportPDF();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.ios_share_rounded),
                            horizontalSpaceSmall,
                            Text(
                              'Export Report',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, elevation: 0),
                      onPressed: viewModel.navigateToLoginView,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people),
                          horizontalSpaceSmall,
                          Text(
                            'Patient List',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  CompleteViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CompleteViewModel(context: context, encounter: encounter);
}
