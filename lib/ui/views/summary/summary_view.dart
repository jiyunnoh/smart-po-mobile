import 'package:biot/ui/common/ui_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/encounter.dart';
import '../../widgets/outcome_measure_summary_score.dart';
import 'summary_viewmodel.dart';

class SummaryView extends StackedView<SummaryViewModel> {
  final Encounter encounter;
  final bool isNewAdded;

  const SummaryView(this.encounter, {super.key, required this.isNewAdded});

  void noPDFReaderAlert(BuildContext context) {
    Alert alertView;
    alertView = Alert(
        context: context,
        style: kAlertStyle,
        title: LocaleKeys.noPDFReaderTitle.tr(),
        desc: LocaleKeys.noPDFReaderDesc.tr(),
        onWillPopActive: true,
        buttons: [
          DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              height: kAlertButtonHeight,
              color: Colors.orange,
              child: const Text(
                LocaleKeys.ok,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ).tr())
        ]);
    alertView.show();
  }

  @override
  Widget builder(
    BuildContext context,
    SummaryViewModel viewModel,
    Widget? child,
  ) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Summary'),
          automaticallyImplyLeading: false,
        ),
        body: (viewModel.dataReady)
            ? Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(indent: 10),
                    itemCount: viewModel.encounter.outcomeMeasures!.length,
                    itemBuilder: (context, index) {
                      return OutcomeScore(
                          viewModel.encounter.outcomeMeasures![index]);
                    },
                  )),
                  GestureDetector(
                      onTap: () => viewModel.onSubmit(),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        color: Colors.red,
                        child: Center(
                            child: Text('Submit', style: buttonTextStyle).tr()),
                      ))
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  SummaryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SummaryViewModel(
          encounter: encounter, isNewAdded: isNewAdded, context: context);
}
