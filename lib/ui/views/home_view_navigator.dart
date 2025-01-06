import 'package:biot/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewNavigator extends StatelessWidget {
  const HomeViewNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Navigator(
      initialRoute: HomeViewNavigatorRoutes.outcomeMeasureSelectView,
      observers: [StackedService.routeObserver],
      onGenerateRoute: HomeViewNavigatorRouter(),
      key: StackedService.nestedNavigationKey(1),
    ));
  }
}
