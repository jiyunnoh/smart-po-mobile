import 'package:biot/services/app_locale_service.dart';
import 'package:biot/services/tts_service.dart';
import 'package:biot/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:biot/ui/dialogs/outcome_measure_select_edit/outcome_measure_select_edit_dialog.dart';
import 'package:biot/ui/views/add_patient/add_patient_view.dart';
import 'package:biot/ui/views/add_patient_dialog/add_patient_dialog_view.dart';
import 'package:biot/ui/views/bottom_nav_view.dart';
import 'package:biot/ui/views/bottom_sheet_navigator/bottom_sheet_navigator_view.dart';
import 'package:biot/ui/views/home_view_navigator.dart';
import 'package:biot/ui/views/patient_view_navigator.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:biot/ui/views/patient/patient_view.dart';
import 'package:biot/services/cloud_service.dart';
import 'package:biot/services/database_service.dart';
import 'package:biot/services/shared_preferences_service.dart';
import 'package:biot/ui/dialogs/confirm_alert/confirm_alert_dialog.dart';
import 'package:biot/services/package_info_service.dart';
import 'package:biot/ui/views/summary/summary_view.dart';
import 'package:biot/ui/views/forgot_password/forgot_password_view.dart';
import 'package:biot/ui/views/sensor_summary/sensor_summary_view.dart';
import 'package:biot/services/file_service.dart';
import 'package:biot/ui/views/patient_form/patient_form_view.dart';
import 'package:biot/ui/views/insights/insights_view.dart';
import 'package:biot/ui/views/login/login_view.dart';
import 'package:biot/ui/views/settings/settings_view.dart';

import '../services/analytics_service.dart';
import '../services/outcome_measure_load_service.dart';
import '../ui/bottom_sheets/select_outcome_measure/select_outcome_measure_sheet.dart';
import '../ui/views/add_outcome_measure_bottom_sheet/add_outcome_measure_bottom_sheet_view.dart';
import '../ui/views/edit_collection_bottom_sheet/edit_collection_bottom_sheet_view.dart';
import '../ui/views/encounter/encounter_view.dart';
import '../ui/views/outcome_measure_select/outcome_measure_select_view.dart';
import '../ui/views/settings_view_navigator.dart';
import 'package:biot/ui/views/app_description/app_description_view.dart';
import 'package:biot/ui/views/om_detail/om_detail_view.dart';
import 'package:biot/ui/dialogs/comparison_select/comparison_select_dialog.dart';
import 'package:biot/services/outcome_measure_selection_service.dart';
import 'package:biot/ui/views/outcome_measure_info_bottom_sheet/outcome_measure_info_bottom_sheet_view.dart';
import 'package:biot/ui/bottom_sheets/collection_info/collection_info_sheet.dart';
import 'package:biot/ui/views/soap_note/soap_note_view.dart';
import 'package:biot/ui/views/evaluation/evaluation_view.dart';
import 'package:biot/services/pdf_service.dart';
import 'package:biot/services/file_saver_service.dart';
import 'package:biot/ui/views/outcome_measure_info/outcome_measure_info_view.dart';
import 'package:biot/ui/views/complete/complete_view.dart';
import 'package:biot/ui/dialogs/loading_indicator/loading_indicator_dialog.dart';
import 'package:biot/services/logger_service.dart';
import 'package:biot/ui/views/splash/splash_view.dart';
import 'package:biot/ui/views/trend/trend_view.dart';
import 'package:biot/ui/views/patient_app_bar/patient_app_bar_view.dart';
// @stacked-import

@StackedApp(routes: [
  MaterialRoute(page: LoginView, fullscreenDialog: true),
  MaterialRoute(page: ForgotPasswordView),
  MaterialRoute(page: BottomNavView, children: [
    MaterialRoute(page: PatientViewNavigator, children: [
      MaterialRoute(page: PatientView),
      MaterialRoute(page: InsightsView),
      MaterialRoute(page: EncounterView),
      MaterialRoute(page: OmDetailView),
      MaterialRoute(page: TrendView),
    ]),
    MaterialRoute(page: HomeViewNavigator, children: [
      MaterialRoute(page: OutcomeMeasureSelectView),
    ])
  ]),
  MaterialRoute(page: AddPatientView),
  MaterialRoute(page: AddPatientDialog),
  MaterialRoute(page: PatientFormView),
  MaterialRoute(page: EvaluationView),
  MaterialRoute(page: SummaryView),
  MaterialRoute(page: SensorSummaryView),
  MaterialRoute(page: SettingsViewNavigator, children: [
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: AppDescriptionView),
  ]),
  MaterialRoute(
    page: BottomSheetNavigatorView,
    children: [
      MaterialRoute(page: EditCollectionBottomSheetView),
      MaterialRoute(page: AddOutcomeMeasureBottomSheetView),
      MaterialRoute(page: OutcomeMeasureInfoBottomSheetView),
    ],
  ),
  MaterialRoute(page: SoapNoteView, fullscreenDialog: true),
  MaterialRoute(page: OutcomeMeasureInfoView, fullscreenDialog: true),
  MaterialRoute(page: CompleteView),
  MaterialRoute(page: SplashView),
  MaterialRoute(page: PatientAppBarView),
// @stacked-route
], dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: BiotService),
  LazySingleton(classType: DatabaseService),
  LazySingleton(classType: SharedPreferencesService),
  LazySingleton(classType: PackageInfoService),
  LazySingleton(classType: FileService),
  LazySingleton(classType: OutcomeMeasureLoadService),
  LazySingleton(classType: AppLocaleService),
  LazySingleton(classType: OutcomeMeasureSelectionService),
  LazySingleton(classType: TtsService),
  LazySingleton(classType: PdfService),
  LazySingleton(classType: FileSaverService),
  LazySingleton(classType: LoggerService),
  LazySingleton(classType: AnalyticsService),
// @stacked-service
], bottomsheets: [
  StackedBottomsheet(classType: SelectOutcomeMeasureSheet),
  StackedBottomsheet(classType: CollectionInfoSheet),
// @stacked-bottom-sheet
], dialogs: [
  StackedDialog(classType: InfoAlertDialog),
  StackedDialog(classType: ConfirmAlertDialog),
  StackedDialog(classType: OutcomeMeasureSelectEditDialog),
  StackedDialog(classType: ComparisonSelectDialog),
  StackedDialog(classType: LoadingIndicatorDialog),
// @stacked-dialog
], logger: StackedLogger())
class App {}
