import 'package:biot/app/app.dialogs.dart';
import 'package:biot/app/app.locator.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel with OIDialog{
  final _apiService = locator<BiotService>();
  final _dialogService = locator<DialogService>();

  bool isSent = false;

  TextEditingController emailController = TextEditingController();

  void onResetPassword() async {
    try {
      await _apiService.forgotPassword(http.Client(), emailController.text);
      showConfirmationDialog();
    } catch (e) {
      handleHTTPError(e);
    }
  }

  void showConfirmationDialog() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Check your email for the reset link.',
    );

    if (response != null && response.confirmed) {
      isSent = true;
      notifyListeners();
    }
  }
}
