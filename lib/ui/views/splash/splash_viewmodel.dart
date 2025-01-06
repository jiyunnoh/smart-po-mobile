import 'package:biot/app/app.router.dart';
import 'package:biot/ui/views/login/login_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class SplashViewModel extends BaseViewModel {

  final _navigationService = locator<NavigationService>();
  void navigateToLoginScreen(){
    _navigationService.replaceWithTransition(LoginView(), transitionStyle: Transition.fade, duration: const Duration(seconds: 1));
  }
}
