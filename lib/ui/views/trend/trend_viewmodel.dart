import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../constants/enum.dart';
import '../../../model/chart_data.dart';
import '../../../model/comparison.dart';
import '../../../model/encounter.dart';
import '../../../model/patient.dart';
import '../../../model/view_arguments.dart';
import '../../../services/database_service.dart';
import '../../common/constants.dart';
import '../add_patient/add_patient_view.dart';

class TrendViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();

  List<Encounter> encounters = [];
  final PageController pageController = PageController();
  int currentPage = 0;

  Patient? get currentPatient => _localdbService.currentPatient?.value;
  Encounter? get newerEncounter =>
      currentPatient!.encounterCollection.newerComparisonEncounter;

  num? get totalScoreForTrendView => currentPatient!.encounterCollection
      .compareEncounterForAnalytics(forTrendView: true) !=
      null
      ? currentPatient!.encounterCollection
      .compareEncounterForAnalytics(forTrendView: true)!
      .scoreChange
      : currentPatient!.encounterCollection.lastEncounter?.unweightedTotalScore;

  ChangeDirection? get totalScoreChangeDirectionFromTrendView =>
      currentPatient!.encounterCollection
          .compareEncounterForAnalytics(forTrendView: true)
          ?.changeDirection;

  TrendViewModel(this.encounters);

  void onPageChanged(int page) {
    currentPage = page;
    notifyListeners();
  }

  /// The method returns line series to chart.
  List<LineSeries<TimeSeriesChartData, DateTime>> getTrendLineSeries(
      List<TimeSeriesChartData> chartDataList,
      {DomainComparison? domainComparison,
        Color? color}) {
    List<LineSeries<TimeSeriesChartData, DateTime>> lines = [];

    lines.add(LineSeries<TimeSeriesChartData, DateTime>(
        name: domainComparison == null
            ? 'Total Score'
            : domainComparison.newer.type.displayName,
        animationDuration: 2500,
        dataSource: chartDataList,
        width: 2,
        color: domainComparison != null
            ? domainComparison.newer.type.color
            : Colors.black,
        xValueMapper: (TimeSeriesChartData data, _) => data.date,
        yValueMapper: (TimeSeriesChartData data, _) => data.dataList[0].value,
        markerSettings: const MarkerSettings(isVisible: true)));

    return lines;
  }

  void navigateToOmDetailView(DomainType domainType) {
    _navigationService.navigateTo(PatientViewNavigatorRoutes.omDetailView,
        id: 0,
        arguments: OmDetailViewArguments(
            domainType: domainType,
            outcomeMeasures: currentPatient!.encounterCollection
                .allOutcomeMeasuresForDomain(domainType)));
  }

  Future<void> navigateToEncounterView(
      Patient patient, ValueNotifier<List<Encounter>> encounters) async {
    await _navigationService.navigateTo(
        PatientViewNavigatorRoutes.encounterView,
        id: 0,
        arguments:
        EncounterViewArguments(patient: patient, encounters: encounters));

    notifyListeners();
  }

  void navigateToHomeTab() {
    BottomNavigationBar bar = bottomNavKey.currentWidget as BottomNavigationBar;
    bar.onTap!(1);
  }

  void navigateToAddPatientView({bool isEdit = false, Patient? patient}) {
    _navigationService.navigateToView(
        AddPatientView(isEdit: isEdit, patient: patient),
        fullscreenDialog: true);
  }
}
