// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:biot/model/encounter.dart' as _i20;
import 'package:biot/model/patient.dart' as _i19;
import 'package:biot/ui/views/add_outcome_measure_bottom_sheet/add_outcome_measure_bottom_sheet_view.dart'
    as _i32;
import 'package:biot/ui/views/add_patient/add_patient_view.dart' as _i5;
import 'package:biot/ui/views/add_patient_dialog/add_patient_dialog_view.dart'
    as _i6;
import 'package:biot/ui/views/app_description/app_description_view.dart'
    as _i30;
import 'package:biot/ui/views/bottom_nav_view.dart' as _i4;
import 'package:biot/ui/views/bottom_sheet_navigator/bottom_sheet_navigator_view.dart'
    as _i12;
import 'package:biot/ui/views/complete/complete_view.dart' as _i15;
import 'package:biot/ui/views/edit_collection_bottom_sheet/edit_collection_bottom_sheet_view.dart'
    as _i31;
import 'package:biot/ui/views/encounter/encounter_view.dart' as _i25;
import 'package:biot/ui/views/evaluation/evaluation_view.dart' as _i8;
import 'package:biot/ui/views/forgot_password/forgot_password_view.dart' as _i3;
import 'package:biot/ui/views/home_view_navigator.dart' as _i22;
import 'package:biot/ui/views/insights/insights_view.dart' as _i24;
import 'package:biot/ui/views/login/login_view.dart' as _i2;
import 'package:biot/ui/views/om_detail/om_detail_view.dart' as _i26;
import 'package:biot/ui/views/outcome_measure_info/outcome_measure_info_view.dart'
    as _i14;
import 'package:biot/ui/views/outcome_measure_info_bottom_sheet/outcome_measure_info_bottom_sheet_view.dart'
    as _i33;
import 'package:biot/ui/views/outcome_measure_select/outcome_measure_select_view.dart'
    as _i28;
import 'package:biot/ui/views/patient/patient_view.dart' as _i23;
import 'package:biot/ui/views/patient_app_bar/patient_app_bar_view.dart'
    as _i17;
import 'package:biot/ui/views/patient_form/patient_form_view.dart' as _i7;
import 'package:biot/ui/views/patient_view_navigator.dart' as _i21;
import 'package:biot/ui/views/sensor_summary/sensor_summary_view.dart' as _i10;
import 'package:biot/ui/views/settings/settings_view.dart' as _i29;
import 'package:biot/ui/views/settings_view_navigator.dart' as _i11;
import 'package:biot/ui/views/soap_note/soap_note_view.dart' as _i13;
import 'package:biot/ui/views/splash/splash_view.dart' as _i16;
import 'package:biot/ui/views/summary/summary_view.dart' as _i9;
import 'package:biot/ui/views/trend/trend_view.dart' as _i27;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as _i18;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i34;

class Routes {
  static const loginView = '/login-view';

  static const forgotPasswordView = '/forgot-password-view';

  static const bottomNavView = '/bottom-nav-view';

  static const addPatientView = '/add-patient-view';

  static const addPatientDialog = '/add-patient-dialog';

  static const patientFormView = '/patient-form-view';

  static const evaluationView = '/evaluation-view';

  static const summaryView = '/summary-view';

  static const sensorSummaryView = '/sensor-summary-view';

  static const settingsViewNavigator = '/settings-view-navigator';

  static const bottomSheetNavigatorView = '/bottom-sheet-navigator-view';

  static const soapNoteView = '/soap-note-view';

  static const outcomeMeasureInfoView = '/outcome-measure-info-view';

  static const completeView = '/complete-view';

  static const splashView = '/splash-view';

  static const patientAppBarView = '/patient-app-bar-view';

  static const all = <String>{
    loginView,
    forgotPasswordView,
    bottomNavView,
    addPatientView,
    addPatientDialog,
    patientFormView,
    evaluationView,
    summaryView,
    sensorSummaryView,
    settingsViewNavigator,
    bottomSheetNavigatorView,
    soapNoteView,
    outcomeMeasureInfoView,
    completeView,
    splashView,
    patientAppBarView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.loginView,
      page: _i2.LoginView,
    ),
    _i1.RouteDef(
      Routes.forgotPasswordView,
      page: _i3.ForgotPasswordView,
    ),
    _i1.RouteDef(
      Routes.bottomNavView,
      page: _i4.BottomNavView,
    ),
    _i1.RouteDef(
      Routes.addPatientView,
      page: _i5.AddPatientView,
    ),
    _i1.RouteDef(
      Routes.addPatientDialog,
      page: _i6.AddPatientDialog,
    ),
    _i1.RouteDef(
      Routes.patientFormView,
      page: _i7.PatientFormView,
    ),
    _i1.RouteDef(
      Routes.evaluationView,
      page: _i8.EvaluationView,
    ),
    _i1.RouteDef(
      Routes.summaryView,
      page: _i9.SummaryView,
    ),
    _i1.RouteDef(
      Routes.sensorSummaryView,
      page: _i10.SensorSummaryView,
    ),
    _i1.RouteDef(
      Routes.settingsViewNavigator,
      page: _i11.SettingsViewNavigator,
    ),
    _i1.RouteDef(
      Routes.bottomSheetNavigatorView,
      page: _i12.BottomSheetNavigatorView,
    ),
    _i1.RouteDef(
      Routes.soapNoteView,
      page: _i13.SoapNoteView,
    ),
    _i1.RouteDef(
      Routes.outcomeMeasureInfoView,
      page: _i14.OutcomeMeasureInfoView,
    ),
    _i1.RouteDef(
      Routes.completeView,
      page: _i15.CompleteView,
    ),
    _i1.RouteDef(
      Routes.splashView,
      page: _i16.SplashView,
    ),
    _i1.RouteDef(
      Routes.patientAppBarView,
      page: _i17.PatientAppBarView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i2.LoginView(key: args.key, isAuthCheck: args.isAuthCheck),
        settings: data,
        fullscreenDialog: true,
      );
    },
    _i3.ForgotPasswordView: (data) {
      final args = data.getArgs<ForgotPasswordViewArguments>(
        orElse: () => const ForgotPasswordViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.ForgotPasswordView(key: args.key),
        settings: data,
      );
    },
    _i4.BottomNavView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.BottomNavView(),
        settings: data,
      );
    },
    _i5.AddPatientView: (data) {
      final args = data.getArgs<AddPatientViewArguments>(
        orElse: () => const AddPatientViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.AddPatientView(
            key: args.key, isEdit: args.isEdit, patient: args.patient),
        settings: data,
      );
    },
    _i6.AddPatientDialog: (data) {
      final args = data.getArgs<AddPatientDialogArguments>(
        orElse: () => const AddPatientDialogArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.AddPatientDialog(
            key: args.key, isEdit: args.isEdit, patient: args.patient),
        settings: data,
      );
    },
    _i7.PatientFormView: (data) {
      final args = data.getArgs<PatientFormViewArguments>(
        orElse: () => const PatientFormViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.PatientFormView(
            key: args.key, isEdit: args.isEdit, patient: args.patient),
        settings: data,
      );
    },
    _i8.EvaluationView: (data) {
      final args = data.getArgs<EvaluationViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.EvaluationView(args.encounter, key: args.key),
        settings: data,
      );
    },
    _i9.SummaryView: (data) {
      final args = data.getArgs<SummaryViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.SummaryView(args.encounter,
            key: args.key, isNewAdded: args.isNewAdded),
        settings: data,
      );
    },
    _i10.SensorSummaryView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.SensorSummaryView(),
        settings: data,
      );
    },
    _i11.SettingsViewNavigator: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.SettingsViewNavigator(),
        settings: data,
      );
    },
    _i12.BottomSheetNavigatorView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.BottomSheetNavigatorView(),
        settings: data,
      );
    },
    _i13.SoapNoteView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.SoapNoteView(),
        settings: data,
        fullscreenDialog: true,
      );
    },
    _i14.OutcomeMeasureInfoView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.OutcomeMeasureInfoView(),
        settings: data,
        fullscreenDialog: true,
      );
    },
    _i15.CompleteView: (data) {
      final args = data.getArgs<CompleteViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.CompleteView(args.encounter, key: args.key),
        settings: data,
      );
    },
    _i16.SplashView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.SplashView(),
        settings: data,
      );
    },
    _i17.PatientAppBarView: (data) {
      final args = data.getArgs<PatientAppBarViewArguments>(nullOk: false);
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.PatientAppBarView(args.patient,
            key: args.key, onCallBack: args.onCallBack),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class LoginViewArguments {
  const LoginViewArguments({
    this.key,
    this.isAuthCheck = false,
  });

  final _i18.Key? key;

  final bool isAuthCheck;

  @override
  String toString() {
    return '{"key": "$key", "isAuthCheck": "$isAuthCheck"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.isAuthCheck == isAuthCheck;
  }

  @override
  int get hashCode {
    return key.hashCode ^ isAuthCheck.hashCode;
  }
}

class ForgotPasswordViewArguments {
  const ForgotPasswordViewArguments({this.key});

  final _i18.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ForgotPasswordViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddPatientViewArguments {
  const AddPatientViewArguments({
    this.key,
    this.isEdit = false,
    this.patient,
  });

  final _i18.Key? key;

  final bool isEdit;

  final _i19.Patient? patient;

  @override
  String toString() {
    return '{"key": "$key", "isEdit": "$isEdit", "patient": "$patient"}';
  }

  @override
  bool operator ==(covariant AddPatientViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.isEdit == isEdit &&
        other.patient == patient;
  }

  @override
  int get hashCode {
    return key.hashCode ^ isEdit.hashCode ^ patient.hashCode;
  }
}

class AddPatientDialogArguments {
  const AddPatientDialogArguments({
    this.key,
    this.isEdit = false,
    this.patient,
  });

  final _i18.Key? key;

  final bool isEdit;

  final _i19.Patient? patient;

  @override
  String toString() {
    return '{"key": "$key", "isEdit": "$isEdit", "patient": "$patient"}';
  }

  @override
  bool operator ==(covariant AddPatientDialogArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.isEdit == isEdit &&
        other.patient == patient;
  }

  @override
  int get hashCode {
    return key.hashCode ^ isEdit.hashCode ^ patient.hashCode;
  }
}

class PatientFormViewArguments {
  const PatientFormViewArguments({
    this.key,
    this.isEdit = false,
    this.patient,
  });

  final _i18.Key? key;

  final bool isEdit;

  final _i19.Patient? patient;

  @override
  String toString() {
    return '{"key": "$key", "isEdit": "$isEdit", "patient": "$patient"}';
  }

  @override
  bool operator ==(covariant PatientFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.isEdit == isEdit &&
        other.patient == patient;
  }

  @override
  int get hashCode {
    return key.hashCode ^ isEdit.hashCode ^ patient.hashCode;
  }
}

class EvaluationViewArguments {
  const EvaluationViewArguments({
    required this.encounter,
    this.key,
  });

  final _i20.Encounter encounter;

  final _i18.Key? key;

  @override
  String toString() {
    return '{"encounter": "$encounter", "key": "$key"}';
  }

  @override
  bool operator ==(covariant EvaluationViewArguments other) {
    if (identical(this, other)) return true;
    return other.encounter == encounter && other.key == key;
  }

  @override
  int get hashCode {
    return encounter.hashCode ^ key.hashCode;
  }
}

class SummaryViewArguments {
  const SummaryViewArguments({
    required this.encounter,
    this.key,
    required this.isNewAdded,
  });

  final _i20.Encounter encounter;

  final _i18.Key? key;

  final bool isNewAdded;

  @override
  String toString() {
    return '{"encounter": "$encounter", "key": "$key", "isNewAdded": "$isNewAdded"}';
  }

  @override
  bool operator ==(covariant SummaryViewArguments other) {
    if (identical(this, other)) return true;
    return other.encounter == encounter &&
        other.key == key &&
        other.isNewAdded == isNewAdded;
  }

  @override
  int get hashCode {
    return encounter.hashCode ^ key.hashCode ^ isNewAdded.hashCode;
  }
}

class CompleteViewArguments {
  const CompleteViewArguments({
    required this.encounter,
    this.key,
  });

  final _i20.Encounter encounter;

  final _i18.Key? key;

  @override
  String toString() {
    return '{"encounter": "$encounter", "key": "$key"}';
  }

  @override
  bool operator ==(covariant CompleteViewArguments other) {
    if (identical(this, other)) return true;
    return other.encounter == encounter && other.key == key;
  }

  @override
  int get hashCode {
    return encounter.hashCode ^ key.hashCode;
  }
}

class PatientAppBarViewArguments {
  const PatientAppBarViewArguments({
    required this.patient,
    this.key,
    this.onCallBack,
  });

  final _i19.Patient? patient;

  final _i18.Key? key;

  final Function? onCallBack;

  @override
  String toString() {
    return '{"patient": "$patient", "key": "$key", "onCallBack": "$onCallBack"}';
  }

  @override
  bool operator ==(covariant PatientAppBarViewArguments other) {
    if (identical(this, other)) return true;
    return other.patient == patient &&
        other.key == key &&
        other.onCallBack == onCallBack;
  }

  @override
  int get hashCode {
    return patient.hashCode ^ key.hashCode ^ onCallBack.hashCode;
  }
}

class BottomNavViewRoutes {
  static const patientViewNavigator = 'patient-view-navigator';

  static const homeViewNavigator = 'home-view-navigator';

  static const all = <String>{
    patientViewNavigator,
    homeViewNavigator,
  };
}

class BottomNavViewRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      BottomNavViewRoutes.patientViewNavigator,
      page: _i21.PatientViewNavigator,
    ),
    _i1.RouteDef(
      BottomNavViewRoutes.homeViewNavigator,
      page: _i22.HomeViewNavigator,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i21.PatientViewNavigator: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.PatientViewNavigator(),
        settings: data,
      );
    },
    _i22.HomeViewNavigator: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i22.HomeViewNavigator(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class PatientViewNavigatorRoutes {
  static const patientView = 'patient-view';

  static const insightsView = 'insights-view';

  static const encounterView = 'encounter-view';

  static const omDetailView = 'om-detail-view';

  static const trendView = 'trend-view';

  static const all = <String>{
    patientView,
    insightsView,
    encounterView,
    omDetailView,
    trendView,
  };
}

class PatientViewNavigatorRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      PatientViewNavigatorRoutes.patientView,
      page: _i23.PatientView,
    ),
    _i1.RouteDef(
      PatientViewNavigatorRoutes.insightsView,
      page: _i24.InsightsView,
    ),
    _i1.RouteDef(
      PatientViewNavigatorRoutes.encounterView,
      page: _i25.EncounterView,
    ),
    _i1.RouteDef(
      PatientViewNavigatorRoutes.omDetailView,
      page: _i26.OmDetailView,
    ),
    _i1.RouteDef(
      PatientViewNavigatorRoutes.trendView,
      page: _i27.TrendView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i23.PatientView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i23.PatientView(),
        settings: data,
      );
    },
    _i24.InsightsView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i24.InsightsView(),
        settings: data,
      );
    },
    _i25.EncounterView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i25.EncounterView(),
        settings: data,
      );
    },
    _i26.OmDetailView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i26.OmDetailView(),
        settings: data,
      );
    },
    _i27.TrendView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i27.TrendView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HomeViewNavigatorRoutes {
  static const outcomeMeasureSelectView = 'outcome-measure-select-view';

  static const all = <String>{outcomeMeasureSelectView};
}

class HomeViewNavigatorRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      HomeViewNavigatorRoutes.outcomeMeasureSelectView,
      page: _i28.OutcomeMeasureSelectView,
    )
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i28.OutcomeMeasureSelectView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i28.OutcomeMeasureSelectView(),
        settings: data,
      );
    }
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class SettingsViewNavigatorRoutes {
  static const settingsView = 'settings-view';

  static const appDescriptionView = 'app-description-view';

  static const all = <String>{
    settingsView,
    appDescriptionView,
  };
}

class SettingsViewNavigatorRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      SettingsViewNavigatorRoutes.settingsView,
      page: _i29.SettingsView,
    ),
    _i1.RouteDef(
      SettingsViewNavigatorRoutes.appDescriptionView,
      page: _i30.AppDescriptionView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i29.SettingsView: (data) {
      final args = data.getArgs<NestedSettingsViewArguments>(
        orElse: () => const NestedSettingsViewArguments(),
      );
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i29.SettingsView(key: args.key, isBeforeLogin: args.isBeforeLogin),
        settings: data,
      );
    },
    _i30.AppDescriptionView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i30.AppDescriptionView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class NestedSettingsViewArguments {
  const NestedSettingsViewArguments({
    this.key,
    this.isBeforeLogin = false,
  });

  final _i18.Key? key;

  final bool isBeforeLogin;

  @override
  String toString() {
    return '{"key": "$key", "isBeforeLogin": "$isBeforeLogin"}';
  }

  @override
  bool operator ==(covariant NestedSettingsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.isBeforeLogin == isBeforeLogin;
  }

  @override
  int get hashCode {
    return key.hashCode ^ isBeforeLogin.hashCode;
  }
}

class BottomSheetNavigatorViewRoutes {
  static const editCollectionBottomSheetView =
      'edit-collection-bottom-sheet-view';

  static const addOutcomeMeasureBottomSheetView =
      'add-outcome-measure-bottom-sheet-view';

  static const outcomeMeasureInfoBottomSheetView =
      'outcome-measure-info-bottom-sheet-view';

  static const all = <String>{
    editCollectionBottomSheetView,
    addOutcomeMeasureBottomSheetView,
    outcomeMeasureInfoBottomSheetView,
  };
}

class BottomSheetNavigatorViewRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      BottomSheetNavigatorViewRoutes.editCollectionBottomSheetView,
      page: _i31.EditCollectionBottomSheetView,
    ),
    _i1.RouteDef(
      BottomSheetNavigatorViewRoutes.addOutcomeMeasureBottomSheetView,
      page: _i32.AddOutcomeMeasureBottomSheetView,
    ),
    _i1.RouteDef(
      BottomSheetNavigatorViewRoutes.outcomeMeasureInfoBottomSheetView,
      page: _i33.OutcomeMeasureInfoBottomSheetView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i31.EditCollectionBottomSheetView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i31.EditCollectionBottomSheetView(),
        settings: data,
      );
    },
    _i32.AddOutcomeMeasureBottomSheetView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i32.AddOutcomeMeasureBottomSheetView(),
        settings: data,
      );
    },
    _i33.OutcomeMeasureInfoBottomSheetView: (data) {
      return _i18.MaterialPageRoute<dynamic>(
        builder: (context) => const _i33.OutcomeMeasureInfoBottomSheetView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

extension NavigatorStateExtension on _i34.NavigationService {
  Future<dynamic> navigateToLoginView({
    _i18.Key? key,
    bool isAuthCheck = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key, isAuthCheck: isAuthCheck),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotPasswordView({
    _i18.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forgotPasswordView,
        arguments: ForgotPasswordViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBottomNavView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.bottomNavView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddPatientView({
    _i18.Key? key,
    bool isEdit = false,
    _i19.Patient? patient,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addPatientView,
        arguments:
            AddPatientViewArguments(key: key, isEdit: isEdit, patient: patient),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddPatientDialog({
    _i18.Key? key,
    bool isEdit = false,
    _i19.Patient? patient,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addPatientDialog,
        arguments: AddPatientDialogArguments(
            key: key, isEdit: isEdit, patient: patient),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPatientFormView({
    _i18.Key? key,
    bool isEdit = false,
    _i19.Patient? patient,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.patientFormView,
        arguments: PatientFormViewArguments(
            key: key, isEdit: isEdit, patient: patient),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEvaluationView({
    required _i20.Encounter encounter,
    _i18.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.evaluationView,
        arguments: EvaluationViewArguments(encounter: encounter, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSummaryView({
    required _i20.Encounter encounter,
    _i18.Key? key,
    required bool isNewAdded,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.summaryView,
        arguments: SummaryViewArguments(
            encounter: encounter, key: key, isNewAdded: isNewAdded),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSensorSummaryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.sensorSummaryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsViewNavigator([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsViewNavigator,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBottomSheetNavigatorView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.bottomSheetNavigatorView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSoapNoteView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.soapNoteView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOutcomeMeasureInfoView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.outcomeMeasureInfoView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCompleteView({
    required _i20.Encounter encounter,
    _i18.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.completeView,
        arguments: CompleteViewArguments(encounter: encounter, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPatientAppBarView({
    required _i19.Patient? patient,
    _i18.Key? key,
    Function? onCallBack,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.patientAppBarView,
        arguments: PatientAppBarViewArguments(
            patient: patient, key: key, onCallBack: onCallBack),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPatientViewNavigator([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(BottomNavViewRoutes.patientViewNavigator,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeViewNavigator([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(BottomNavViewRoutes.homeViewNavigator,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedPatientViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(PatientViewNavigatorRoutes.patientView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedInsightsViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(PatientViewNavigatorRoutes.insightsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedEncounterViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(PatientViewNavigatorRoutes.encounterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedOmDetailViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(PatientViewNavigatorRoutes.omDetailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedTrendViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(PatientViewNavigatorRoutes.trendView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      navigateToNestedOutcomeMeasureSelectViewInHomeViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewNavigatorRoutes.outcomeMeasureSelectView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedSettingsViewInSettingsViewNavigatorRouter({
    _i18.Key? key,
    bool isBeforeLogin = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(SettingsViewNavigatorRoutes.settingsView,
        arguments:
            NestedSettingsViewArguments(key: key, isBeforeLogin: isBeforeLogin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      navigateToNestedAppDescriptionViewInSettingsViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(SettingsViewNavigatorRoutes.appDescriptionView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      navigateToNestedEditCollectionBottomSheetViewInBottomSheetNavigatorViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(
        BottomSheetNavigatorViewRoutes.editCollectionBottomSheetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      navigateToNestedAddOutcomeMeasureBottomSheetViewInBottomSheetNavigatorViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(
        BottomSheetNavigatorViewRoutes.addOutcomeMeasureBottomSheetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      navigateToNestedOutcomeMeasureInfoBottomSheetViewInBottomSheetNavigatorViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(
        BottomSheetNavigatorViewRoutes.outcomeMeasureInfoBottomSheetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i18.Key? key,
    bool isAuthCheck = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key, isAuthCheck: isAuthCheck),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotPasswordView({
    _i18.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.forgotPasswordView,
        arguments: ForgotPasswordViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBottomNavView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.bottomNavView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddPatientView({
    _i18.Key? key,
    bool isEdit = false,
    _i19.Patient? patient,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addPatientView,
        arguments:
            AddPatientViewArguments(key: key, isEdit: isEdit, patient: patient),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddPatientDialog({
    _i18.Key? key,
    bool isEdit = false,
    _i19.Patient? patient,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addPatientDialog,
        arguments: AddPatientDialogArguments(
            key: key, isEdit: isEdit, patient: patient),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPatientFormView({
    _i18.Key? key,
    bool isEdit = false,
    _i19.Patient? patient,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.patientFormView,
        arguments: PatientFormViewArguments(
            key: key, isEdit: isEdit, patient: patient),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEvaluationView({
    required _i20.Encounter encounter,
    _i18.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.evaluationView,
        arguments: EvaluationViewArguments(encounter: encounter, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSummaryView({
    required _i20.Encounter encounter,
    _i18.Key? key,
    required bool isNewAdded,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.summaryView,
        arguments: SummaryViewArguments(
            encounter: encounter, key: key, isNewAdded: isNewAdded),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSensorSummaryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.sensorSummaryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsViewNavigator([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsViewNavigator,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBottomSheetNavigatorView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.bottomSheetNavigatorView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSoapNoteView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.soapNoteView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOutcomeMeasureInfoView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.outcomeMeasureInfoView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCompleteView({
    required _i20.Encounter encounter,
    _i18.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.completeView,
        arguments: CompleteViewArguments(encounter: encounter, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPatientAppBarView({
    required _i19.Patient? patient,
    _i18.Key? key,
    Function? onCallBack,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.patientAppBarView,
        arguments: PatientAppBarViewArguments(
            patient: patient, key: key, onCallBack: onCallBack),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPatientViewNavigator([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(BottomNavViewRoutes.patientViewNavigator,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeViewNavigator([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(BottomNavViewRoutes.homeViewNavigator,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedPatientViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(PatientViewNavigatorRoutes.patientView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedInsightsViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(PatientViewNavigatorRoutes.insightsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedEncounterViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(PatientViewNavigatorRoutes.encounterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedOmDetailViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(PatientViewNavigatorRoutes.omDetailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedTrendViewInPatientViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(PatientViewNavigatorRoutes.trendView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      replaceWithNestedOutcomeMeasureSelectViewInHomeViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(
        HomeViewNavigatorRoutes.outcomeMeasureSelectView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedSettingsViewInSettingsViewNavigatorRouter({
    _i18.Key? key,
    bool isBeforeLogin = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(SettingsViewNavigatorRoutes.settingsView,
        arguments:
            NestedSettingsViewArguments(key: key, isBeforeLogin: isBeforeLogin),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      replaceWithNestedAppDescriptionViewInSettingsViewNavigatorRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(SettingsViewNavigatorRoutes.appDescriptionView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      replaceWithNestedEditCollectionBottomSheetViewInBottomSheetNavigatorViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(
        BottomSheetNavigatorViewRoutes.editCollectionBottomSheetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      replaceWithNestedAddOutcomeMeasureBottomSheetViewInBottomSheetNavigatorViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(
        BottomSheetNavigatorViewRoutes.addOutcomeMeasureBottomSheetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic>
      replaceWithNestedOutcomeMeasureInfoBottomSheetViewInBottomSheetNavigatorViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(
        BottomSheetNavigatorViewRoutes.outcomeMeasureInfoBottomSheetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
