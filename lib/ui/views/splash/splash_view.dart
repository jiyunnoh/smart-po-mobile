import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'splash_viewmodel.dart';

class SplashView extends StackedView<SplashViewModel> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SplashAnimation());
  }

  @override
  SplashViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SplashViewModel();
}

class SplashAnimation extends StackedHookView<SplashViewModel> {
  const SplashAnimation({
    super.key,
  });

  @override
  Widget builder(BuildContext context, SplashViewModel model) {
    final _tickerProvider = useSingleTickerProvider();
    final _animationController = useAnimationController(
      vsync: _tickerProvider,
    );
    return Center(
        child: Lottie.asset('assets/lottie/data.json',
            repeat: false,
            controller: _animationController,
          onLoaded: (composition){
          _animationController..duration = composition.duration
              ..forward().whenComplete(() => model.navigateToLoginScreen());
          }
    ));
              // ..forward().whenComplete(() => model.navigateToLoginScreen)));
  }
}
