import 'dart:io';

import 'package:biot/services/analytics_service.dart';
import 'package:biot/services/app_locale_service.dart';
import 'package:biot/services/database_service.dart';
import 'package:biot/services/logger_service.dart';
import 'package:biot/services/outcome_measure_load_service.dart';
import 'package:biot/services/package_info_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:biot/app/app.bottomsheets.dart';
import 'package:biot/app/app.dialogs.dart';
import 'package:biot/app/app.locator.dart';

import 'package:biot/ui/common/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLogFileOutput();
  setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  await setupDatabase();
  PackageInfoService();
  OutcomeMeasureLoadService();

  runApp(
    EasyLocalization(
        supportedLocales: AppLocaleService.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        saveLocale: false,
        useFallbackTranslations: true,
        useOnlyLangCode: true,
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Theme.of(context).copyWith(
        useMaterial3: false,
        primaryColor: kcBackgroundColor,
        focusColor: kcPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
            ),
      ),
      supportedLocales: context.supportedLocales,
      localizationsDelegates: [
        // GlobalMaterialLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // SfGlobalLocalizations.delegate,
        context.localizationDelegates[0]
      ],
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
        locator<AnalyticsService>().getAnalyticsObserver()
      ],
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
