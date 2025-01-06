import 'package:biot/ui/common/app_colors.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'forgot_password_viewmodel.dart';

class ForgotPasswordView extends StackedView<ForgotPasswordViewModel> {
  ForgotPasswordView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Forgot Password'),
      ),
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We will send you a reset link to your email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            verticalSpaceLarge,
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('email'),
                    controller: viewModel.emailController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      filled: true,
                      hintText: 'Email',
                    ),
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9@+.]"))
                    ],
                    validator: (value) => value != null && value.isEmpty
                        ? 'Email is required'
                        : null,
                  ),
                ],
              ),
            ),
            verticalSpaceLarge,
            MaterialButton(
                key: const Key('resetPassword'),
                color: kcDarkGreyColor,
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  final isValid = formKey.currentState?.validate();
                  if (isValid!) {
                    viewModel.onResetPassword();
                  }
                }),
            verticalSpaceMedium,
            if (viewModel.isSent)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Didn\'t get the link?'),
                  TextButton(
                      onPressed: () {
                        final isValid = formKey.currentState?.validate();
                        if (isValid!) {
                          viewModel.onResetPassword();
                        }
                      },
                      child: const Text('Resend'))
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ForgotPasswordViewModel();
}
