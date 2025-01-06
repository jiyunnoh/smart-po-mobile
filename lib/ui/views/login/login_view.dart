import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../../model/demo_globals.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  LoginView({super.key, this.isAuthCheck = false});

  final formKey = GlobalKey<FormState>();

  final bool isAuthCheck;

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: (viewModel.isAuthCheck)
          ? AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            const Spacer(),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('packages/comet_foundation/images/smartpo-logo.png',
                    scale: 2),
                verticalSpaceMedium,
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: const Key('email'),
                        controller: viewModel.emailController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
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
                      verticalSpaceSmall,
                      TextFormField(
                        key: const Key('pwd'),
                        controller: viewModel.pwdController,
                        obscureText: !viewModel.isPwdVisible,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            filled: true,
                            hintText: viewModel.isAuthCheck && isDemo
                                ? 'Enter any random password to continue for demo.'
                                : 'Password',
                            suffixIcon: IconButton(
                                onPressed: viewModel.onTogglePwdVisible,
                                icon: Icon(
                                  (viewModel.isPwdVisible)
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ))),
                        keyboardType: TextInputType.text,
                        validator: (value) => value != null && value.isEmpty
                            ? 'Password is required'
                            : null,
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                MaterialButton(
                    key: const Key('loginBtn'),
                    color: kcDarkGreyColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90.0, vertical: 10.0),
                      child: Text(
                        (viewModel.isAuthCheck) ? 'CONTINUE' : 'LOGIN',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    onPressed: () async {
                      final isValid = formKey.currentState?.validate();
                      if (isValid!) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        isDemo ? viewModel.demoLogin() : viewModel.login();
                      }
                    }),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: !viewModel.isAuthCheck,
              child: MaterialButton(
                  key: const Key('demoLoginBtn'),
                  color: kcDarkGreyColor,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 90.0, vertical: 10.0),
                    child: Text(
                      'DEMO',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  onPressed: () async {
                    viewModel.autoFillDemoLoginCredentials();
                    final isValid = formKey.currentState?.validate();
                    if (isValid!) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      viewModel.demoLogin();
                    }
                  }),
            ),
            const Spacer(),
            const Spacer(),
            Visibility(
              visible: !viewModel.isAuthCheck,
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: viewModel.navigateToSettingsView,
                    iconSize: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel(isAuthCheck: isAuthCheck);
}
