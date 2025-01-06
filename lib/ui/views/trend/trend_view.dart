import 'package:biot/ui/views/patient_app_bar/patient_app_bar_view.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../model/encounter.dart';
import '../../common/ui_helpers.dart';
import '../../widgets/trend_view_content.dart';

import 'trend_viewmodel.dart';

class TrendView extends StackedView<TrendViewModel> {
  const TrendView({super.key});

  @override
  Widget builder(
    BuildContext context,
    TrendViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: PatientAppBarView(viewModel.currentPatient),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'Trend',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        verticalSpaceSmall,
                        TrendViewContent(),
                        verticalSpaceSmall,
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  @override
  TrendViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final List<Encounter> encounters =
        ModalRoute.of(context)!.settings.arguments as List<Encounter>;
    return TrendViewModel(encounters);
  }
}
