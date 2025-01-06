import 'package:biot/constants/enum.dart';
import 'package:biot/constants/ethnicity.dart';
import 'package:biot/constants/sex_at_birth.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/model/domain_weight_distribution.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../constants/current_sex.dart';
import '../../../constants/race.dart';
import '../../../model/chart_data.dart';
import '../../../model/condition.dart';
import '../../../model/demo_globals.dart';
import '../../../model/device.dart';
import '../../../model/kLevel.dart';
import '../../../model/patient.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import '../../../services/cloud_service.dart';
import '../../../services/database_service.dart';

class PatientFormViewModel extends BaseViewModel with OIDialog {
  final _apiService = locator<BiotService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();

  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;

  GlobalKey<FormState> infoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> conditionsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> addDeviceFormKey = GlobalKey<FormState>();

  TextEditingController patientIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  TextEditingController deviceNameController = TextEditingController();
  TextEditingController lCodeController = TextEditingController();
  bool isSideSelected = false;

  DateTime? dobPickedDate;
  late TooltipBehavior tooltipBehavior;

  List<bool> conditionFromCloud =
      List.filled(ConditionType.values.length, false);
  List<bool> conditionsCheckboxes =
      List.filled(ConditionType.values.length, false);
  List<String> conditionsCheckboxLabels = [
    ConditionType.orthotic.toDisplayName,
    ConditionType.prosthetic.toDisplayName,
    ConditionType.other.toDisplayName,
    ConditionType.upper.toDisplayName,
    ConditionType.lower.toDisplayName,
  ];

  List<bool> kLevelFromCloud = [false, false, false, false];
  List<bool> selectedKLevel = [false, false, false, false];
  List<Widget> kLevelOptions = [
    const Text('1'),
    const Text('2'),
    const Text('3'),
    const Text('4')
  ];

  List<bool> selectedDeviceSide = [false, false];
  List<Widget> deviceSide = [const Text('L'), const Text('R')];

  List<Device> deviceListFromCloud = [];
  List<Device> deviceList = [];

  //TODO: improve checkbox validation more efficiently
  bool isDiagnosesFormSubmitted = false;
  bool isDeviceEdit = false;
  bool isNewDeviceFormSubmitted = false;

  late Patient? patient;
  bool isEdit = false;
  bool isPatientInfoModified = false;
  bool isDiagnosesModified = false;
  bool isDomainWeightDistModified = false;

  bool isPatientIdModified = false;
  bool isFirstNameModified = false;
  bool isLastNameModified = false;
  bool isDobModified = false;
  bool isSexAtBirthModified = false;
  bool isCurrentSexModified = false;
  bool isRaceModified = false;
  bool isEthnicityModified = false;

  bool isConditionModified = false;
  bool isKLevelModified = false;
  bool isDeviceListModified = false;
  bool isSingleDeviceModified = false;
  bool isDeviceNameModified = false;
  bool isAmputeeSideModified = false;
  bool isLCodeModified = false;

  bool isHrqolModified = false;
  bool isFunctionModified = false;
  bool isGoalsModified = false;
  bool isComfortModified = false;
  bool isSatisfactionModified = false;

  bool isSimpleSliderSorted = true;
  bool isAdvancedSliderSorted = true;
  bool isSimpleSlider = true;

  String countryCode = 'US';

  SexAtBirth? selectedSexAtBirth;
  CurrentSex? selectedCurrentSex;
  Race? selectedRace;
  Ethnicity? selectedEthnicity;

  List<DropdownMenuItem<SexAtBirth>> sexAtBirthOptions = SexAtBirth.values
      .where((e) => e != SexAtBirth.neither)
      .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
      .toList();

  final List<DropdownMenuItem<CurrentSex>> currentSexOptions = CurrentSex.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
      .toList();

  final List<DropdownMenuItem<Race>> raceOptions = Race.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
      .toList();

  final List<DropdownMenuItem<Ethnicity>> ethnicityOptions = Ethnicity.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
      .toList();

  List<SliderChartData> chartData = [
    SliderChartData(DomainType.hrqol.displayName, 0,
        const SfRangeValues(0.0, 0.0), 0, DomainType.hrqol.color),
    SliderChartData(DomainType.function.displayName, 0,
        const SfRangeValues(0.0, 0.0), 0, DomainType.function.color),
    SliderChartData(DomainType.goals.displayName, 0,
        const SfRangeValues(0.0, 0.0), 0, DomainType.goals.color),
    SliderChartData(DomainType.comfort.displayName, 0,
        const SfRangeValues(0.0, 0.0), 0, DomainType.comfort.color),
    SliderChartData(DomainType.satisfaction.displayName, 0,
        const SfRangeValues(0.0, 0.0), 0, DomainType.satisfaction.color),
  ];

  final List<bool> selectedToggles = <bool>[true, false];
  List<Widget> sliderTypes = <Widget>[
    Transform.rotate(
        angle: 90 * math.pi / 180, child: const Icon(Icons.bar_chart_rounded)),
    const Icon(Icons.tune_rounded),
  ];

  final double simpleSliderMin = 1.0;
  late double simpleSliderMax;
  final double advancedSliderMin = 0.0;
  final double advancedSliderMax = 100;

  PatientFormViewModel({this.isEdit = false, this.patient}) {
    if (patient != null) {
      isEdit = true;

      patientIdController.text = patient!.id;
      firstNameController.text = patient!.firstName;
      lastNameController.text = patient!.lastName;
      dobController.text = DateFormat('yyyy-MM-dd').format(patient!.dob!);
      dobPickedDate = patient!.dob;
      selectedSexAtBirth = SexAtBirth.values[patient!.sexAtBirthIndex!];
      selectedCurrentSex = CurrentSex.values[patient!.currentSexIndex!];
      selectedRace = Race.values[patient!.raceIndex!];
      selectedEthnicity = Ethnicity.values[patient!.ethnicityIndex!];
      emailController.text = patient!.email;
    }
  }

  Future<void> initialize() async {
    setBusy(true);
    simpleSliderMax = 100;

    if (isEdit) {
      await patient!.populate();

      // Prepare devices, condition, k-level UI in edit mode
      await preparePatientInfoUI();

      // Prepare domain prioritization setup UI in edit mode
      prepareDomainPrioritizationSetupUI();

      // Sort domain prioritization in descending order by default in edit mode
      onTapSort();
    } else {
      // Reset domain prioritization when adding a new patient
      onTapDefault();
    }

    tooltipBehavior = TooltipBehavior(enable: true);

    setBusy(false);
    notifyListeners();
  }

  void prepareDomainPrioritizationSetupUI() {
    final domainMapping = {
      DomainType.hrqol.displayName: patient!.domainWeightDist.hrqol,
      DomainType.function.displayName: patient!.domainWeightDist.function,
      DomainType.goals.displayName: patient!.domainWeightDist.goals,
      DomainType.comfort.displayName: patient!.domainWeightDist.comfort,
      DomainType.satisfaction.displayName:
          patient!.domainWeightDist.satisfaction,
    };

    for (SliderChartData chart in chartData) {
      if (domainMapping.containsKey(chart.domainName)) {
        chart.normalizedValue = domainMapping[chart.domainName]!.toDouble();
        chart.advancedSliderRange = chart.normalizedValue;
        chart.simpleSliderValue =
            chart.advancedSliderRange / 100 * simpleSliderMax;
        if (chart.simpleSliderValue < 1) {
          chart.simpleSliderValue = 1;
        }
      }
    }
  }

  Future<void> preparePatientInfoUI() async {
    deviceListFromCloud = isDemo
        ? patient!.devices ?? []
        : await _apiService.getDevices(http.Client(), patient: patient);
    deviceList = [...deviceListFromCloud];

    for (var element in patient!.condition!.conditionsList!) {
      final conditionType =
          ConditionType.values.firstWhere((type) => type.name == element);

      final index = ConditionType.values.indexOf(conditionType);

      conditionFromCloud[index] = true;
    }
    conditionsCheckboxes = [...conditionFromCloud];

    // k-level default value is 0 when it is not selected.
    if (patient!.kLevel!.kLevelValue! != 0) {
      kLevelFromCloud[patient!.kLevel!.kLevelValue! - 1] = true;
    }
    selectedKLevel = [...kLevelFromCloud];
  }

  void getDefaultAdvancedSliders() {
    double start = 0.0;
    for (var i = 0; i < chartData.length; i++) {
      chartData[i].advancedSliderRange =
          (advancedSliderMax) / (chartData.length);
      //Set the start point and end point of advanced sliders equally distributed by default
      double end = start + chartData[i].advancedSliderRange;
      chartData[i].advancedSliderValues = SfRangeValues(start, end);
      start = end;
    }
  }

  double getAdvancedSliderRange(SfRangeValues values) {
    return values.end - values.start;
  }

  void onTapToggleButton(int index) {
    if (index == 0) {
      isSimpleSlider = true;
    } else {
      isSimpleSlider = false;
    }

    for (int i = 0; i < selectedToggles.length; i++) {
      selectedToggles[i] = i == index;
    }

    onTapSort();

    notifyListeners();
  }

  void updateSimpleSlider(dynamic value, int i) {
    chartData[i].simpleSliderValue = value;

    // Sort
    for (int index = 0; index < chartData.length - 1; index++) {
      if (chartData[index].simpleSliderValue <
          chartData[index + 1].simpleSliderValue) {
        isSimpleSliderSorted = false;
        break;
      } else {
        isSimpleSliderSorted = true;
      }
    }

    notifyListeners();
  }

  void updateCircularChart() {
    // Use fold method to get total value of sliders.
    double total =
        chartData.fold(0.0, (sum, element) => sum + element.simpleSliderValue);

    // Normalize values for pie chart based on simple slider.
    if (selectedToggles[0]) {
      for (SliderChartData chart in chartData) {
        chart.normalizedValue = (chart.simpleSliderValue / total * 100);
        chart.advancedSliderValues = SfRangeValues(
            chart.advancedSliderValues.start,
            chart.advancedSliderValues.start + chart.normalizedValue);

        chart.advancedSliderRange =
            getAdvancedSliderRange(chart.advancedSliderValues);
      }
    } else {
      // Normalize values for pie chart based on advanced slider.
      for (SliderChartData chart in chartData) {
        chart.normalizedValue = chart.advancedSliderRange;

        chart.simpleSliderValue =
            chart.advancedSliderRange / 100 * simpleSliderMax;
        if (chart.simpleSliderValue < 1) {
          chart.simpleSliderValue = 1;
        }
      }
    }

    if (patient != null) {
      for (SliderChartData data in chartData) {
        if (data.domainName == DomainType.hrqol.displayName) {
          isHrqolModified =
              (data.normalizedValue == patient!.domainWeightDist.hrqol)
                  ? false
                  : true;
        }
        if (data.domainName == DomainType.function.displayName) {
          isFunctionModified =
              (data.normalizedValue == patient!.domainWeightDist.function)
                  ? false
                  : true;
        }
        if (data.domainName == DomainType.goals.displayName) {
          isGoalsModified =
              (data.normalizedValue == patient!.domainWeightDist.goals)
                  ? false
                  : true;
        }
        if (data.domainName == DomainType.comfort.displayName) {
          isComfortModified =
              (data.normalizedValue == patient!.domainWeightDist.comfort)
                  ? false
                  : true;
        }
        if (data.domainName == DomainType.satisfaction.displayName) {
          isSatisfactionModified =
              (data.normalizedValue == patient!.domainWeightDist.satisfaction)
                  ? false
                  : true;
        }
      }
    }

    notifyListeners();
  }

  void updateRangeSlider(double start, double end, int index) {
    //TODO: at least 1% or 1.2%?
    double minLength = 1;
    double maxLength = advancedSliderMax - (minLength * (chartData.length - 1));

    double minStart = index * minLength;
    double maxEnd = minStart + maxLength;
    SfRangeValues range;

    if (index == 0) {
      range = SfRangeValues(advancedSliderMin, end.clamp(minLength, maxEnd));
    } else if (index == chartData.length - 1) {
      range = SfRangeValues(
          start.clamp(minStart, maxEnd - minLength), advancedSliderMax);
    } else {
      range = SfRangeValues(start.clamp(minStart, maxEnd - minLength),
          end.clamp(minStart + minLength, maxEnd));
    }

    chartData[index].advancedSliderValues = range;

    chartData[index].advancedSliderRange =
        getAdvancedSliderRange(chartData[index].advancedSliderValues);

    //Update end point of previous slider except the current slider is the first one.
    if (index > 0) {
      for (var j = index; j > 0; j--) {
        chartData[j - 1].advancedSliderValues = SfRangeValues(
            chartData[j - 1].advancedSliderValues.start,
            chartData[j].advancedSliderValues.start);

        chartData[j - 1].advancedSliderRange =
            getAdvancedSliderRange(chartData[j - 1].advancedSliderValues);

        if (chartData[j - 1].advancedSliderRange < minLength) {
          chartData[j - 1].advancedSliderValues = SfRangeValues(
              chartData[j - 1].advancedSliderValues.end - minLength,
              chartData[j - 1].advancedSliderValues.end);

          chartData[j - 1].advancedSliderRange =
              getAdvancedSliderRange(chartData[j - 1].advancedSliderValues);
        }
      }
    }

    //Update start point of next slider except the current slider is the last one.
    if (index < chartData.length - 1) {
      for (var j = index; j < chartData.length - 1; j++) {
        chartData[j + 1].advancedSliderValues = SfRangeValues(
            chartData[j].advancedSliderValues.end,
            chartData[j + 1].advancedSliderValues.end);

        chartData[j + 1].advancedSliderRange =
            getAdvancedSliderRange(chartData[j + 1].advancedSliderValues);

        if (chartData[j + 1].advancedSliderRange < minLength) {
          chartData[j + 1].advancedSliderValues = SfRangeValues(
              chartData[j + 1].advancedSliderValues.start,
              chartData[j + 1].advancedSliderValues.start + minLength);

          chartData[j + 1].advancedSliderRange =
              getAdvancedSliderRange(chartData[j + 1].advancedSliderValues);
        }
      }
    }

    for (int index = 0; index < chartData.length - 1; index++) {
      if (chartData[index].advancedSliderRange <
          chartData[index + 1].advancedSliderRange) {
        isAdvancedSliderSorted = false;
        break;
      } else {
        isAdvancedSliderSorted = true;
      }
    }

    notifyListeners();
  }

  void onTapDefault() {
    isSimpleSliderSorted = true;
    isAdvancedSliderSorted = true;

    //Alphabetical order by default
    chartData.sort((a, b) => a.domainName.compareTo(b.domainName));

    for (SliderChartData chart in chartData) {
      chart.simpleSliderValue =
          (simpleSliderMax + simpleSliderMin) / chartData.length;
    }

    getDefaultAdvancedSliders();

    updateCircularChart();
    notifyListeners();
  }

  void onTapSort() {
    isSimpleSliderSorted = true;
    isAdvancedSliderSorted = true;

    chartData.sort((a, b) => a.domainName.compareTo(b.domainName));

    chartData
        .sort((a, b) => b.simpleSliderValue.compareTo(a.simpleSliderValue));

    chartData
        .sort((a, b) => b.advancedSliderRange.compareTo(a.advancedSliderRange));

    for (var i = 0; i < chartData.length; i++) {
      if (i == 0) {
        chartData[i].advancedSliderValues =
            SfRangeValues(advancedSliderMin, chartData[i].advancedSliderRange);
      } else {
        chartData[i].advancedSliderValues = SfRangeValues(
            chartData[i - 1].advancedSliderValues.end,
            chartData[i - 1].advancedSliderValues.end +
                chartData[i].advancedSliderRange);
      }
    }

    notifyListeners();
  }

  void onChangeDob() {
    dobController.text = DateFormat('yyyy-MM-dd').format(dobPickedDate!);
    notifyListeners();
  }

  void onChangeSexAtBirth(value) {
    selectedSexAtBirth = value;
    notifyListeners();
  }

  void onChangeCurrentSex(value) {
    selectedCurrentSex = value;
    notifyListeners();
  }

  void onChangeRace(value) {
    selectedRace = value;
    notifyListeners();
  }

  void onChangeEthnicity(value) {
    selectedEthnicity = value;
    notifyListeners();
  }

  bool shouldEnable() {
    if (isEdit) {
      // TODO: Optimize this later
      isPatientInfoModified = isPatientIdModified ||
          isFirstNameModified ||
          isLastNameModified ||
          isDobModified ||
          isSexAtBirthModified ||
          isCurrentSexModified ||
          isRaceModified ||
          isEthnicityModified;

      isSingleDeviceModified =
          isDeviceNameModified || isAmputeeSideModified || isLCodeModified;

      isDiagnosesModified = isDeviceListModified ||
          isSingleDeviceModified ||
          isConditionModified ||
          isKLevelModified;

      isDomainWeightDistModified = isHrqolModified ||
          isFunctionModified ||
          isGoalsModified ||
          isComfortModified ||
          isSatisfactionModified;

      if (isPatientInfoModified == false &&
          isDiagnosesModified == false &&
          isDomainWeightDistModified == false) {
        return false;
      }
    }
    return true;
  }

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  double? hrqol;
  double? function;
  double? goals;
  double? comfort;
  double? satisfaction;
  late DomainWeightDistribution domainWeightDist;
  late Condition condition;
  late KLevel kLevel;

  Future<void> onAddPatient() async {
    showBusyDialog();
    try {
      for (SliderChartData data in chartData) {
        if (data.domainName == DomainType.hrqol.displayName) {
          hrqol = data.normalizedValue;
        }
        if (data.domainName == DomainType.function.displayName) {
          function = data.normalizedValue;
        }
        if (data.domainName == DomainType.goals.displayName) {
          goals = data.normalizedValue;
        }
        if (data.domainName == DomainType.comfort.displayName) {
          comfort = data.normalizedValue;
        }
        if (data.domainName == DomainType.satisfaction.displayName) {
          satisfaction = data.normalizedValue;
        }
      }
      domainWeightDist = DomainWeightDistribution(
          hrqol: hrqol,
          function: function,
          goals: goals,
          comfort: comfort,
          satisfaction: satisfaction);

      List<String> conditionsList = [];
      for (int i = 0; i < conditionsCheckboxes.length; i++) {
        if (conditionsCheckboxes[i]) {
          conditionsList.add(conditionsCheckboxLabels[i].toLowerCase());
        }
      }
      condition = Condition(conditionsList: conditionsList);

      int kLevelIndex = selectedKLevel.indexOf(true);
      kLevel = KLevel(kLevelValue: kLevelIndex + 1);

      Patient patient = Patient(
          id: patientIdController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          dob: dobPickedDate,
          sexAtBirthIndex: selectedSexAtBirth?.index,
          currentSexIndex: selectedCurrentSex?.index,
          raceIndex: selectedRace?.index,
          ethnicityIndex: selectedEthnicity?.index,
          countryCode: 'AU');

      patient.domainWeightDist = domainWeightDist;
      patient.condition = condition;
      patient.kLevel = kLevel;
      patient.entityId = isDemo
          ? '${patient.id}_${patient.initial}'
          : await _apiService.addPatient(http.Client(), patient);
      patient.devices = deviceList;
      patient.isPopulated = true;
      _localdbService.addPatient(patient);
      closeBusyDialog();
    } catch (e) {
      closeBusyDialog();
      handleHTTPError(e);
    }
  }

  Future<void> onEditPatient() async {
    showBusyDialog();
    try {
      if (isDiagnosesModified) {
        if (isSingleDeviceModified && !isDemo) {
          for (Device device in deviceList) {
            if (device.isEdited) {
              await _apiService.editDevice(http.Client(), device);
            }
          }
        }

        if (isDeviceListModified) {
          if (isDemo) {
            patient!.devices = deviceList;
          } else {
            // Add devices to the cloud
            for (Device deviceFromLocal in deviceList) {
              if (!deviceListFromCloud.any((deviceFromCloud) =>
                  deviceFromCloud.deviceName == deviceFromLocal.deviceName)) {
                await _apiService.addDevice(http.Client(), deviceFromLocal,
                    patient: patient!);
              }
            }

            // Delete devices from the cloud
            for (Device deviceFromCloud in deviceListFromCloud) {
              if (!deviceList.any((deviceFromLocal) =>
                  deviceFromLocal.deviceName == deviceFromCloud.deviceName)) {
                await _apiService.deleteDevice(http.Client(),
                    deviceId: deviceFromCloud.id);
              }
            }
          }
        }

        if (isConditionModified) {
          List<String> conditionsList = [];
          for (int i = 0; i < conditionsCheckboxes.length; i++) {
            if (conditionsCheckboxes[i]) {
              conditionsList.add(conditionsCheckboxLabels[i].toLowerCase());
            }
          }

          condition = Condition(conditionsList: conditionsList);

          if (patient!.condition != null) {
            if (isDemo) {
              patient!.condition = condition;
            } else {
              await _apiService.editCondition(http.Client(),
                  conditionId: patient!.condition!.entityId!,
                  condition: condition);
            }
          }
        }

        if (isKLevelModified || isConditionModified) {
          int kLevelIndex = selectedKLevel.indexOf(true);
          kLevel = KLevel(kLevelValue: kLevelIndex + 1);

          if (patient!.kLevel != null) {
            if (isDemo) {
              patient!.kLevel = kLevel;
            } else {
              await _apiService.editKLevel(http.Client(),
                  kLevelId: patient!.kLevel!.entityId!, kLevel: kLevel);
            }
          }
        }
      }

      if (isDomainWeightDistModified) {
        for (SliderChartData data in chartData) {
          if (data.domainName == DomainType.hrqol.displayName) {
            hrqol = data.normalizedValue;
          }
          if (data.domainName == DomainType.function.displayName) {
            function = data.normalizedValue;
          }
          if (data.domainName == DomainType.goals.displayName) {
            goals = data.normalizedValue;
          }
          if (data.domainName == DomainType.comfort.displayName) {
            comfort = data.normalizedValue;
          }
          if (data.domainName == DomainType.satisfaction.displayName) {
            satisfaction = data.normalizedValue;
          }
        }

        domainWeightDist = DomainWeightDistribution(
            hrqol: hrqol,
            function: function,
            goals: goals,
            comfort: comfort,
            satisfaction: satisfaction);

        if (isDemo) {
          patient!.domainWeightDist = domainWeightDist;
        } else {
          await _apiService.editDomainWeightDistribution(http.Client(),
              domainWeightDistId: patient!.domainWeightDist.entityId!,
              domainWeightDistribution: domainWeightDist);
        }
      }

      if (isPatientInfoModified) {
        patient!.id = patientIdController.text;
        patient!.firstName = firstNameController.text;
        patient!.lastName = lastNameController.text;
        patient!.dob = dobPickedDate;
        patient!.sexAtBirthIndex = selectedSexAtBirth?.index;
        patient!.currentSexIndex = selectedCurrentSex?.index;
        patient!.raceIndex = selectedRace?.index;
        patient!.ethnicityIndex = selectedEthnicity?.index;

        if (!isDemo) {
          await _apiService.editPatient(http.Client(), patient!);
        }

        _localdbService.editPatient(patient!);
      }

      closeBusyDialog();
    } catch (e) {
      closeBusyDialog();
      handleHTTPError(e);
    }
  }

  void updateCheckbox(int i) {
    conditionsCheckboxes[i] = !conditionsCheckboxes[i];

    if (conditionsCheckboxes != conditionFromCloud) {
      isConditionModified = true;
    }

    if (!conditionsCheckboxes[1]) {
      selectedKLevel = [false, false, false, false];
    }

    notifyListeners();
  }

  bool validateToggleButtons() {
    if (selectedDeviceSide.every((element) => element == false)) {
      isSideSelected = false;
    } else {
      isSideSelected = true;
    }
    notifyListeners();
    return isSideSelected;
  }

  void resetFormValidation() {
    isDiagnosesFormSubmitted = false;
    notifyListeners();
  }

  void updateKLevelToggleButton(int index) {
    for (int i = 0; i < 4; i++) {
      selectedKLevel[i] = i == index;
    }

    if (selectedKLevel != kLevelFromCloud) {
      isKLevelModified = true;
    }
    notifyListeners();
  }

  void onSubmitDiagnosesForm() {
    isDiagnosesFormSubmitted = true;

    notifyListeners();
  }

  void onAddNewDevice() {
    late AmputeeSide amputeeSide;

    if (selectedDeviceSide[0] == true && selectedDeviceSide[1] == true) {
      amputeeSide = AmputeeSide.both;
    } else if (selectedDeviceSide[0] == true) {
      amputeeSide = AmputeeSide.left;
    } else {
      amputeeSide = AmputeeSide.right;
    }

    deviceList.add(Device(
        deviceName: deviceNameController.text,
        amputeeSide: amputeeSide,
        lCode: lCodeController.text));

    isDeviceListModified = true;

    notifyListeners();
  }

  void onEditSingleDevice(int index) {
    late AmputeeSide amputeeSide;

    if (selectedDeviceSide[0] == true && selectedDeviceSide[1] == true) {
      amputeeSide = AmputeeSide.both;
    } else if (selectedDeviceSide[0] == true) {
      amputeeSide = AmputeeSide.left;
    } else {
      amputeeSide = AmputeeSide.right;
    }

    isDeviceNameModified =
        deviceList[index].deviceName != deviceNameController.text;
    isLCodeModified = deviceList[index].lCode != lCodeController.text;
    isAmputeeSideModified = deviceList[index].amputeeSide != amputeeSide;

    deviceList[index].deviceName = deviceNameController.text;
    deviceList[index].lCode = lCodeController.text;
    deviceList[index].amputeeSide = amputeeSide;

    deviceList[index].isEdited = true;
    isSingleDeviceModified = true;

    notifyListeners();
  }

  void onTabEditDevices({bool alwaysClose = false}) {
    if (alwaysClose) {
      isDeviceEdit = false;
    } else {
      isDeviceEdit = !isDeviceEdit;
    }
    notifyListeners();
  }

  void capitalizeInitial(TextEditingController textEditingController) {
    String text = textEditingController.text;
    if (text.isNotEmpty) {
      textEditingController.value = textEditingController.value.copyWith(
          text: text[0].toUpperCase() + text.substring(1),
          selection: TextSelection.collapsed(offset: text.length));
    }
    notifyListeners();
  }

  void navigateBack() {
    _navigationService.back();
  }

  void showConfirmDeleteDialog(int index) async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.confirmAlert,
        title: 'Are you sure you wish to delete this device?',
        data: patient,
        mainButtonTitle: 'Cancel',
        secondaryButtonTitle: 'Delete');

    if (response != null && response.confirmed) {
      try {
        deviceList.removeAt(index);
        isDeviceListModified = true;
        notifyListeners();
      } catch (e) {
        handleHTTPError(e);
      }
    }
  }
}
