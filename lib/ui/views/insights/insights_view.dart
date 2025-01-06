import 'package:biot/ui/common/ui_helpers.dart';
import 'package:biot/ui/views/patient_app_bar/patient_app_bar_view.dart';
import 'package:biot/ui/widgets/overview_content.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/goal.dart';
import 'insights_viewmodel.dart';

class InsightsView extends StackedView<InsightsViewModel> {
  const InsightsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    InsightsViewModel viewModel,
    Widget? child,
  ) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        viewModel.stopAnimation();
        viewModel.removeSelectedPatient();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PatientAppBarView(
          viewModel.currentPatient,
          onCallBack: viewModel.stopAnimation,
        ),
        body: (viewModel.dataReady)
            ? _buildInsightsView(viewModel, context, size)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildInsightsView(
      InsightsViewModel viewModel, BuildContext context, Size size) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: GestureDetector(
        onTap: () => viewModel.onPieSectionTapped(-1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (viewModel.encounters.isNotEmpty)
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Insights',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    horizontalSpaceSmall,
                    if (viewModel.encounters.length >= 2)
                    GestureDetector(
                        onTap: viewModel.navigateToTrendView,
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2.0, color: Colors.black)),
                            child: const Icon(Icons.auto_graph)))
                  ],
                ),
              GestureDetector(
                onTap: () =>
                    viewModel.onPieSectionTapped(viewModel.pieSectionInFocus),
                child: viewModel.encounters.isNotEmpty
                    ? const Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalSpaceSmall,
                              OverviewContent(),
                              verticalSpaceSmall,
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'Please add a new encounter to see the overview.'),
                      )),
              ),
              if (viewModel.latestPsfs != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Goals',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const Goal()
              ]
            ],
          ),
        ),
      ),
    );
  }

  @override
  InsightsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InsightsViewModel();
}
