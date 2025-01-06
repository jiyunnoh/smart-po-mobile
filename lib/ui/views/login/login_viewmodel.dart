import 'package:biot/app/app.router.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/services/logger_service.dart';
import 'package:biot/ui/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

import '../../../app/app.locator.dart';
import '../../../model/demo_globals.dart';
import '../../../services/cloud_service.dart';
import '../../../services/package_info_service.dart';
import '../../common/constants.dart';
import '../bottom_nav_view.dart';

class LoginViewModel extends ReactiveViewModel with OIDialog {
  final _apiService = locator<BiotService>();
  final _packageInfoService = locator<PackageInfoService>();
  final _navigationService = locator<NavigationService>();
  final _logger =
      locator<LoggerService>().getLogger((LoginViewModel).toString());

  final bool isAuthCheck;
  bool isPwdVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  static const demoEmail = 'orthocaretest+demo@orthocareinnovations.com';
  static const demoPwd = 'Demo1234';

  LoginViewModel({required this.isAuthCheck}) {
    _logger.d('');

    if (isAuthCheck) {
      emailController.text = isDemo ? demoEmail : _apiService.userId;
      pwdController.text = isDemo ? demoPwd : '';
    } else {
      emailController.text = '';
      pwdController.text = '';
    }
  }

  String get appVersion => (_packageInfoService.info == null)
      ? ''
      : '${_packageInfoService.info!.version} (${_packageInfoService.info!.buildNumber})';

  void autoFillDemoLoginCredentials() {
    emailController.text = demoEmail;
    pwdController.text = demoPwd;
  }

  Future<void> login() async {
    _logger.d('');

    showBusyDialog();

    try {
      await _apiService.loginWithCredentials(
          http.Client(), emailController.text, pwdController.text);

      // Get caregiverName
      //TODO: JK - not everyone is caregiver. org admin or org user can sign in using their credential
      // _apiService.getCaregiverById(http.Client());

      // Get organization code
      //TODO: JK - not all org has code. this should be nullable. This may be always true in the future however depends on whether we make this field required or not.
      // _apiService.getOrganizationCodeById(http.Client());

      closeBusyDialog();

      if (isAuthCheck) {
        _navigationService.popUntil((route) => route.isFirst);
        BottomNavigationBar bar =
            bottomNavKey.currentWidget as BottomNavigationBar;
        bar.onTap!(0);
      } else {
        await _navigationService.replaceWithTransition(const BottomNavView(),
            routeName: BottomNavViewRoutes.patientViewNavigator,
            transitionStyle: Transition.fade);
      }

      // reset password in case when logging out.
      pwdController.text = '';
    } catch (e) {
      closeBusyDialog();

      handleHTTPError(e);
    }
  }

  Future<void> demoLogin() async {
    isDemo = true;

    if (isAuthCheck) {
      _navigationService.popUntil((route) => route.isFirst);
      BottomNavigationBar bar =
          bottomNavKey.currentWidget as BottomNavigationBar;
      bar.onTap!(0);
    } else {
      await _navigationService.replaceWithTransition(const BottomNavView(),
          routeName: BottomNavViewRoutes.patientViewNavigator,
          transitionStyle: Transition.fade);
    }
  }

  void onTogglePwdVisible() {
    isPwdVisible = !isPwdVisible;
    notifyListeners();
  }

  void navigateToSettingsView() {
    _navigationService.navigateWithTransition(
        const SettingsView(
          isBeforeLogin: true,
        ),
        routeName: SettingsViewNavigatorRoutes.settingsView,
        fullscreenDialog: true);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_packageInfoService];
}
