import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/ui_helpers.dart';
import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key, this.isBeforeLogin = false});

  final bool isBeforeLogin;

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings'),
        actions: (viewModel.isBeforeLogin)
            ? null
            : [
                IconButton(
                    onPressed: () => viewModel.showConfirmLogoutDialog(context),
                    icon: const Icon(Icons.logout))
              ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                if (!viewModel.isBeforeLogin)
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.password,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Change Password',
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 30.0,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            onTap: () => print('navigate'),
                          ),
                          const Divider(
                            indent: 30,
                            endIndent: 30,
                            color: Colors.black38,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.repeat,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Subscription',
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 30.0,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            onTap: () => print('navigate'),
                          ),
                          const Divider(
                            indent: 30,
                            endIndent: 30,
                            color: Colors.black38,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.summarize_outlined,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Outcomes Templates',
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 30.0,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            onTap: () => print('navigate'),
                          ),
                          const Divider(
                            indent: 30,
                            endIndent: 30,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Export',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.file_upload_outlined,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'App-wide Data as CSV',
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 30.0,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            onTap: () => print('navigate'),
                          ),
                          const Divider(
                            indent: 30,
                            endIndent: 30,
                            color: Colors.black38,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.file_upload_outlined,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'App Usage Log',
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 30.0,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            onTap: () => print('navigate'),
                          ),
                          const Divider(
                            indent: 30,
                            endIndent: 30,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                    ],
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'About',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'App Description',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 30.0,
                        color: Colors.black54,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      onTap: viewModel.navigateToAppDescriptionView,
                    ),
                    const Divider(
                      indent: 30,
                      endIndent: 30,
                      color: Colors.black38,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.security,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Data Privacy',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 30.0,
                        color: Colors.black54,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      onTap: viewModel.dataPrivacyTapped,
                    ),
                    const Divider(
                      indent: 30,
                      endIndent: 30,
                      color: Colors.black38,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Contact Support',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 30.0,
                        color: Colors.black54,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      onTap: viewModel.sendEmailTapped,
                    ),
                    const Divider(
                      indent: 30,
                      endIndent: 30,
                      color: Colors.black38,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.new_releases_outlined,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'App Version',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Text(viewModel.appVersion),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                    ),
                    const Divider(
                      indent: 30,
                      endIndent: 30,
                      color: Colors.black38,
                    ),
                  ],
                ),
                verticalSpaceSmall,
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black12))),
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, (viewModel.isBeforeLogin) ? 32 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                      'packages/comet_foundation/images/oi-logo.png'),
                ),
                verticalSpaceTiny,
                Expanded(
                  child: Column(
                    children: [
                      Text('©2023 - ${DateTime.now().year}'),
                      const Text('Orthocare Innovations'),
                      const Text('Edmonds, WA, USA'),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel(isBeforeLogin: isBeforeLogin);
}
