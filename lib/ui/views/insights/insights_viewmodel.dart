import 'dart:async';
import 'dart:math';
import 'package:async/async.dart';
import 'package:biot/constants/app_strings.dart';
import 'package:biot/constants/enum.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/model/encounter_collection.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../constants/images.dart';
import '../../../model/chart_data.dart';
import '../../../model/demo_globals.dart';
import '../../../model/domain.dart';
import '../../../model/outcome_measures/patient_specific_functional_scale.dart';
import '../../../model/outcome_measures/progait.dart';
import '../../../model/patient.dart';
import '../../../model/encounter.dart';
import '../../../services/cloud_service.dart';
import 'package:http/http.dart' as http;

import '../../../services/database_service.dart';
import '../../../services/logger_service.dart';
import '../../common/constants.dart';

class InsightsViewModel extends FutureViewModel with OIDialog {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<BiotService>();
  final _dialogService = locator<DialogService>();
  final _localdbService = locator<DatabaseService>();

  Patient? get currentPatient => _localdbService.currentPatient?.value;

  List<Encounter> get encounters =>
      currentPatient!.encounterCollection.encounters;

  Encounter? get olderEncounter =>
      currentPatient?.encounterCollection.olderComparisonEncounter;

  Encounter? get newerEncounter =>
      currentPatient?.encounterCollection.newerComparisonEncounter;

  int get totalScore => olderEncounter != null
      ? isComparisonOn
          ? newerEncounter!
              .compareUnweightedTotalScoreAgainstPrev(olderEncounter!)
              .$1
              .round()
          : isOlderCircularChartOn
              ? olderEncounter!.unweightedTotalScore!.round()
              : newerEncounter!.unweightedTotalScore!.round()
      : isWeighted
          ? newerEncounter!.weightedTotalScore!.round()
          : newerEncounter!.unweightedTotalScore!.round();

  bool isWeighted = false;
  bool isSigDiffOn = true;
  bool isComparisonOn = false;
  int pieSectionInFocus = -1;

  SelectionBehavior domainSelectionBehavior = SelectionBehavior(
      enable: true,
      unselectedOpacity: 0.1,
      unselectedColor: Colors.grey,
      selectedOpacity: 0);

  List<ChartLegend> chartLegends = [
    ChartLegend(DomainType.goals, goalsIcon),
    ChartLegend(DomainType.satisfaction, satisfactionIcon),
    ChartLegend(DomainType.comfort, comfortIcon),
    ChartLegend(DomainType.function, functionIcon),
    ChartLegend(DomainType.hrqol, hrqolIcon)
  ];

  List<CircularChartData> emptyCircularData = List.generate(
      5,
      (index) => CircularChartData(
            'Empty',
            Colors.transparent,
            radius: 100,
            unweightedY: 100,
            weightedY: 100,
          ));

  Map<Domain, List<TimeSeriesChartData>> domainScoresTrendData = {};

  double startAngle = 0;
  double endAngle = 0;

  // TODO: what about each encounter having this flag?
  List<bool> isSelectedEncounter = [];

  // TODO: move to selection dialog
  List<bool> tempIsSelectedEncounter = [];

  List<CircularChartData>? currentEncounterData;

  List<CircularChartData>? get newerEncounterCircularData =>
      newerEncounter?.getEncounterCircularData();

  List<CircularChartData>? get olderEncounterCircularData =>
      olderEncounter?.getEncounterCircularData();

  List<CircularChartData>? currentOutcomeMeasureData;

  List<CircularChartData>? get newerOutcomeMeasureData =>
      newerEncounter?.getOutcomeMeasureCircularData(pieSectionInFocus);

  List<CircularChartData>? get olderOutcomeMeasureData =>
      olderEncounter?.getOutcomeMeasureCircularData(pieSectionInFocus);

  bool isOlderCircularChartOn = false;

  Timer? _chartTimer;
  Timer? _progressTimer;
  int _iterationCount = 0;
  static const int animationTimeInMs = 1000;
  static const int totalPeriodInMs = 3000;
  static const int tickInterval = 20;

  List<ProgressIndicator> _progressBar =
      List.generate(10, (index) => ProgressIndicator(10, Colors.grey));

  List<Widget> get progressBar => _progressBar
      .map((e) => SizedBox(
          width: 20, child: Icon(Icons.circle, size: e.size, color: e.color)))
      .toList();

  final _logger =
      locator<LoggerService>().getLogger((InsightsViewModel).toString());

  Psfs? get latestPsfs {
    return encounters.isEmpty
        ? null
        : encounters.first.outcomeMeasureById('psfs') as Psfs?;
  }

  final ScrollController scrollController = ScrollController();

  InsightsViewModel() {
    _localdbService.onCurrentPatientDataChanged = () {
      initialise();
    };
  }

  @override
  void dispose() {
    _chartTimer?.cancel();
    _progressTimer?.cancel();
    _localdbService.onCurrentPatientDataChanged = null;
    super.dispose();
  }

  @override
  Future futureToRun() async {
    _logger.d('');
    if (currentPatient != null) {
      if (isDemo) {
        Patient patient = _localdbService.demoPatients.singleWhere(
            (element) => element.entityId == currentPatient?.entityId);
        return (patient.encounters != null)
            ? patient.encounters
            : <Encounter>[];
      } else {
        return _apiService.getEncounters(http.Client(), currentPatient!);
      }
    } else {
      return Future.value(false);
    }
  }

  @override
  Future<void> onData(data) async {
    _logger.d('');
    setBusy(true);

    if (currentPatient == null) {
      return;
    }

    isWeighted = false;

    // This is for testing only when the created time is modified on purpose.
    (data as List<Encounter>).sort(
        (a, b) => b.encounterCreatedTime!.compareTo(a.encounterCreatedTime!));

    // This is for patient_app_bar_view. Patient app bar is loaded before encounter collection is created.
    currentPatient!.encounters = data;
    currentPatient!.encounterCollection = EncounterCollection(data);

    // TODO: need refactoring
    if (encounters.isNotEmpty) {
      // Set up for encounter selection dialog
      isSelectedEncounter = List.generate(encounters.length, (index) => false);
      isSelectedEncounter[0] = true;
      if (encounters.length >= 2) {
        isSelectedEncounter[1] = true;
      }

      FutureGroup futureGroup = FutureGroup();

      if (!isDemo) {
        // Get domain scores for all encounters.
        futureGroup
            .add(_apiService.getDomainScores(http.Client(), currentPatient!));
      }

      if (newerEncounter != null) {
        futureGroup.add(newerEncounter!.populate(patient: currentPatient));
        if (isDemo && currentPatient!.fullName != 'Brown, Emily') {
          if (encounters.length > proGaitList.length) {
            proGaitList.add(ProGait(
                id: ksProgait,
                prosthesisDynamicsAP:
                    min(proGaitList.last.prosthesisDynamicsAP + 5, 100),
                prosthesisDynamicsML:
                    min(proGaitList.last.prosthesisDynamicsML + 5, 100),
                temporalSymmetry:
                    min(proGaitList.last.temporalSymmetry + 5, 150)));
          }

          if (newerEncounter!.outcomeMeasures!
              .every((element) => element.id != ksProgait)) {
            newerEncounter!
                .addOutcomeMeasure(proGaitList[encounters.length - 1]);
            proGaitList[encounters.length - 1].buildInfo();
          }
        }
      }

      if (olderEncounter != null) {
        futureGroup.add(olderEncounter!.populate(patient: currentPatient));
        if (isDemo && currentPatient!.fullName != 'Brown, Emily') {
          if (olderEncounter!.outcomeMeasures!
              .every((element) => element.id != ksProgait)) {
            olderEncounter!
                .addOutcomeMeasure(proGaitList[encounters.length - 2]);
            proGaitList[encounters.length - 2].buildInfo();
          }
        }
      }

      futureGroup.close();

      _logger.d('start populating latest and prior encounter');
      List futureResult = await futureGroup.future;
      _logger.d('finished populating');

      if (!isDemo) {
        List domainScores = futureResult[0];
        // If number of encounters and number of domain scores entity are the same (should be the same)
        if (encounters.length == domainScores.length) {
          for (int i = 0; i < encounters.length; i++) {
            Encounter encounter = encounters[i];
            Map<String, dynamic> domainScoresJson = domainScores[i];
            encounter.populateDomainScores(domainScoresJson);
          }
        } else {
          _logger.d(
              'Something is wrong. The number of encounters and the number of domain score entity are not the matched.');
        }
      }
    }

    // TODO: need refactoring
    tempIsSelectedEncounter = List<bool>.from(isSelectedEncounter);

    currentEncounterData = newerEncounterCircularData;

    if (olderEncounter != null && newerEncounter != null) {
      startAnimation();
    }

    _logger.d('finished getting data');
    notifyListeners();
    setBusy(false);
  }

  void startAnimation() {
    isComparisonOn = true;
    isOlderCircularChartOn = false;
    DateTime startTime = DateTime.now();
    int progressIndex = 0;
    // progressBarTickInterval is calculated to determine the interval of time between each tick of the progress bar.
    // Initially, the number of ticks was set to _progressBar.length + 5, resulting in a progressBarTickInterval of 71 ms.
    // Since 71 is not evenly divisible by 20 (the timer's periodic duration), there would be time loss, causing the animation to cut off early.
    // To solve this, progressBarTickInterval was decreased by increasing the number of ticks from _progressBar.length + 5 to _progressBar.length + 8.
    int progressBarTickInterval =
        animationTimeInMs ~/ (_progressBar.length + 8);
    int progressBarElapsedTime = 0;

    if (olderEncounterCircularData != null) {
      _chartTimer = Timer.periodic(const Duration(milliseconds: tickInterval),
          (Timer timer) async {
        int elapsedTime = DateTime.now().difference(startTime).inMilliseconds;
        double percentage =
            min(elapsedTime, animationTimeInMs) / animationTimeInMs;

        // Update currentData radius
        if (pieSectionInFocus == -1) {
          for (int i = 0; i < currentEncounterData!.length; i++) {
            currentEncounterData![i].radius =
                olderEncounterCircularData![i].radius +
                    (newerEncounterCircularData![i].radius -
                            olderEncounterCircularData![i].radius) *
                        percentage;
          }
        }

        // Update currentOutcomeMeasureData radius
        if (currentOutcomeMeasureData != null) {
          for (int i = 0; i < currentOutcomeMeasureData!.length; i++) {
            currentOutcomeMeasureData![i].radius =
                olderOutcomeMeasureData![i].radius +
                    (newerOutcomeMeasureData![i].radius -
                            olderOutcomeMeasureData![i].radius) *
                        percentage;
          }
        }

        // Update progress bar
        progressBarElapsedTime += tickInterval;
        if (progressBarElapsedTime >= progressBarTickInterval) {
          if (progressIndex < _progressBar.length) {
            _progressBar[progressIndex].color = currentPatient!
                .encounterCollection
                .compareEncounterForAnalytics()!
                .changeDirection!
                .color;
            if (progressIndex >= 1) {
              _progressBar[progressIndex - 1].size = 15;
            }
            if (progressIndex >= 2) {
              _progressBar[progressIndex - 2].size = 20;
            }
            if (progressIndex >= 3) {
              _progressBar[progressIndex - 3].size = 15;
            }
            if (progressIndex >= 4) {
              _progressBar[progressIndex - 4].size = 10;
            }
            progressIndex += 1;
          } else {
            if (progressIndex - 1 < _progressBar.length) {
              _progressBar[progressIndex - 1].size = 15;
            }
            if (progressIndex - 2 < _progressBar.length) {
              _progressBar[progressIndex - 2].size = 20;
            }
            if (progressIndex - 3 < _progressBar.length) {
              _progressBar[progressIndex - 3].size = 15;
            }
            if (progressIndex - 4 < _progressBar.length) {
              _progressBar[progressIndex - 4].size = 10;
            }
            progressIndex += 1;
          }
          progressBarElapsedTime = 0;
        }

        if (elapsedTime - tickInterval <= animationTimeInMs) {
          notifyListeners();
        }

        if (elapsedTime >= totalPeriodInMs) {
          _iterationCount++; // Increment the iteration counter
          if (_iterationCount >= 3) {
            stopAnimation(); // Stop animation after three iterations
            _iterationCount = 0; // Reset the iteration counter if needed
          } else {
            stopAnimation();
            startAnimation();
          }
        }
      });
    }
  }

  void stopAnimation() {
    _stopTimer();
    if (pieSectionInFocus == -1) {
      currentEncounterData = newerEncounterCircularData;
    }
    _progressBar =
        List.generate(10, (index) => ProgressIndicator(10, Colors.grey));
    notifyListeners();
  }

  void _stopTimer() {
    _chartTimer?.cancel();
    isComparisonOn = false;
    isOlderCircularChartOn = false;
  }

  void showOlderCircularChart() {
    _stopTimer();
    isComparisonOn = false;
    isOlderCircularChartOn = true;
    currentEncounterData = olderEncounterCircularData;
    currentOutcomeMeasureData = olderOutcomeMeasureData;

    notifyListeners();
  }

  void showNewerCircularChart() {
    _stopTimer();
    isComparisonOn = false;
    isOlderCircularChartOn = false;
    currentEncounterData = newerEncounterCircularData;
    currentOutcomeMeasureData = newerOutcomeMeasureData;

    notifyListeners();
  }

  String getTimeDifference(DateTime value) {
    DateTime now = DateTime.now();

    value = DateTime(value.year, value.month, value.day);
    now = DateTime(now.year, now.month, now.day);
    int differenceInDays = (now.difference(value).inHours / 24).round();

    if (differenceInDays == 0) {
      return 'Today';
    } else if (differenceInDays >= 1 && differenceInDays <= 30) {
      return '${differenceInDays}d ago';
    } else {
      int month = differenceInDays ~/ 30;
      if (month <= 11) {
        return '${month}mo ago';
      } else {
        int year = month ~/ 12;
        return '${year}yr ago';
      }
    }
  }

  void calculateAngle({required bool isWeighted, required int tappedIndex}) {
    startAngle = 0;
    endAngle = 0;

    if (isWeighted) {
      for (var i = tappedIndex; i > 0; i--) {
        startAngle = startAngle +
            (newerEncounter!
                .getEncounterCircularData()[tappedIndex - i]
                .weightedAngle);
      }
      endAngle = startAngle +
          (newerEncounter!
              .getEncounterCircularData()[tappedIndex]
              .weightedAngle);
    } else {
      startAngle =
          startAngle + (360 / newerEncounter!.domains.length * tappedIndex);
      endAngle = startAngle + (360 / newerEncounter!.domains.length);
    }
  }

  void onPieSectionTapped(int index) {
    // selecting the same index deselects pie slice.
    if (index == -1 || index == pieSectionInFocus) {
      domainSelectionBehavior.selectDataPoints(pieSectionInFocus);
      pieSectionInFocus = -1;
      currentOutcomeMeasureData = null;
      isSigDiffOn = false;
    } else {
      pieSectionInFocus = index;
      domainSelectionBehavior.selectDataPoints(index);
      currentOutcomeMeasureData = isOlderCircularChartOn
          ? olderOutcomeMeasureData
          : newerOutcomeMeasureData;

      isSigDiffOn = true;

      calculateAngle(isWeighted: isWeighted, tappedIndex: index);
    }

    notifyListeners();
  }

  void onToggleWeighted(bool value) {
    isWeighted = value;

    if (pieSectionInFocus != -1) {
      calculateAngle(isWeighted: isWeighted, tappedIndex: pieSectionInFocus);
    }

    if (isWeighted) {
      for (int i = 0;
          i < newerEncounter!.getEncounterCircularData().length;
          i++) {
        emptyCircularData[i].weightedY =
            newerEncounter!.getEncounterCircularData()[i].weightedY;
      }
    }

    notifyListeners();
  }

  void onToggleSigDiff(bool value) {
    isSigDiffOn = value;

    notifyListeners();
  }

  void removeSelectedPatient() {
    _localdbService.currentPatient = null;
    _localdbService.updateCurrentPatient();
  }

  void navigateToTrendView() {
    _navigationService.navigateTo(PatientViewNavigatorRoutes.trendView,
        id: 0, arguments: encounters);
  }

  void navigateToHomeTab() {
    BottomNavigationBar bar = bottomNavKey.currentWidget as BottomNavigationBar;
    bar.onTap!(1);
  }

  // TODO: replace _buildComparisonDialog in overview_content to this
  void showComparisonSelectDialog() async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.comparisonSelect,
        barrierDismissible: true,
        // TODO: how to pass multiple data?
        data: {''});

    if (response != null && response.confirmed) {
      notifyListeners();
    }
  }

  void navigateToSoapNoteView() {
    _navigationService.navigateToSoapNoteView();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_localdbService];
}

class ChartLegend {
  final DomainType domainType;
  final Image icon;

  ChartLegend(this.domainType, this.icon);
}

class ProgressIndicator {
  double size;
  Color color;

  ProgressIndicator(this.size, this.color);
}
