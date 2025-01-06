import 'package:biot/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'bottom_sheet_navigator_viewmodel.dart';

class BottomSheetNavigatorView
    extends StackedView<BottomSheetNavigatorViewModel> {
  const BottomSheetNavigatorView({super.key});

  @override
  Widget builder(
    BuildContext context,
    BottomSheetNavigatorViewModel viewModel,
    Widget? child,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Navigator(
        initialRoute: viewModel.isCollectionEditing
            ? BottomSheetNavigatorViewRoutes.editCollectionBottomSheetView
            : BottomSheetNavigatorViewRoutes.addOutcomeMeasureBottomSheetView,
        observers: [StackedService.routeObserver],
        onGenerateRoute: BottomSheetNavigatorViewRouter(),
        key: StackedService.nestedNavigationKey(3),
      ),
    );
  }

  @override
  BottomSheetNavigatorViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BottomSheetNavigatorViewModel();
}
