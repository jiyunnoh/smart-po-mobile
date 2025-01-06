import 'package:biot/app/app.router.dart';
import 'package:biot/mixin/dialog_mixin.dart';
import 'package:biot/services/database_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../constants/demo_json.dart';
import '../../../model/condition.dart';
import '../../../model/demo_globals.dart';
import '../../../model/device.dart';
import '../../../model/domain_weight_distribution.dart';
import '../../../model/encounter.dart';
import '../../../model/kLevel.dart';
import '../../../model/outcome_measures/outcome_measure.dart';
import '../../../model/patient.dart';
import '../../../services/cloud_service.dart';
import '../../../services/logger_service.dart';
import '../add_patient/add_patient_view.dart';

class PatientViewModel extends FutureViewModel<List<Patient>> with OIDialog {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<BiotService>();
  final _localdbService = locator<DatabaseService>();
  final _dialogService = locator<DialogService>();

  final _logger =
      locator<LoggerService>().getLogger((PatientViewModel).toString());

  Box<Patient> get patientBox => _localdbService.patientsBox;

  List<Patient> get demoPatients => _localdbService.demoPatients;

  set currentPatient(Patient patient) {
    _localdbService.currentPatient = ReactiveValue<Patient>(patient);

    _localdbService.updateCurrentPatient();
  }

  bool isLoading = false;

  PatientViewModel() {
    _logger.d('');
  }

  @override
  void onData(data) {
    if (data != null) {
      syncToCloud(data);
      notifyListeners();
    }
  }

  @override
  Future<List<Patient>> futureToRun() async {
    return isDemo
        ? getPatientsForDemo()
        : _apiService.getPatients(http.Client());
  }

  Future<List<Patient>> getPatientsForDemo() async {
    List<Patient> patients = [];
    for (Map<String, dynamic> patientMap in demoPatientsJson) {
      // get patients
      Patient patient = Patient.fromJson(patientMap);
      patients.add(patient);

      // get condition
      patient.condition = Condition.fromJson(patientMap['condition']);

      // get k-level
      patient.kLevel = KLevel.fromJson(patientMap['k_level']);

      // get assistive devices
      for (Map<String, dynamic> deviceMap in patientMap['assistive_devices']) {
        Device device = Device.fromJson(deviceMap);
        (patient.devices ??= []).add(device);
      }

      // get encounters
      patient.encounters ??= [];
      for (Map<String, dynamic> encountersMap in patientMap['encounters']) {
        Encounter encounter = Encounter.fromJson(encountersMap);

        patient.outcomeMeasureIds = encountersMap['outcome_measures']
            .split(', ')
            .map<String>((String s) => s.trim())
            .toList();

        // get domain weight distribution
        patient.domainWeightDist = DomainWeightDistribution.fromJson(
            encountersMap['domain_weight_distribution_smartpo']);
        encounter.domainWeightDist = patient.domainWeightDist;

        // get outcome measures
        for (OutcomeMeasure om in encounter.outcomeMeasures!) {
          om.populateWithJson(encountersMap['${om.id}_smartpo']);
          om.buildInfo();
          om.isPopulated = true;
        }

        encounter.isPopulated = true;
        patient.isPopulated = true;

        patient.encounters!.add(encounter);
      }

      // get domain scores and match it to encounter
      List domainScores =
          patientMap['domainScores'] as List<Map<String, dynamic>>;

      // If number of encounters and number of domain scores entity are the same (should be the same)
      if (patient.encounters!.length == domainScores.length) {
        for (int i = 0; i < patient.encounters!.length; i++) {
          Encounter encounter = patient.encounters![i];
          Map<String, dynamic> domainScoresJson = domainScores[i];
          encounter.populateDomainScores(domainScoresJson);
        }
      } else {
        print('encounters and domain scores list length are different');
      }
    }

    return patients;
  }

  Future<void> onPullRefresh() async {
    _logger.d('');
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (!isDemo) {
        List<Patient> patients = await _apiService.getPatients(http.Client());
        syncToCloud(patients);
      }
    } catch (e) {
      handleHTTPError(e);
    }
  }

  void syncToCloud(List<Patient> patients) {
    _logger.d('');

    if (isDemo) {
      _localdbService.demoPatients = patients;
    } else {
      // Add, update patient
      for (final cloudPatient in patients) {
        var matchIndex = patientBox.values.toList().indexWhere(
              (localDbPatient) =>
                  localDbPatient.entityId == cloudPatient.entityId,
            );

        if (matchIndex == -1) {
          patientBox.put(cloudPatient.entityId, cloudPatient);
        } else {
          patientBox.putAt(matchIndex, cloudPatient);
        }
      }

      // Delete patient
      for (Patient localDbPatient in patientBox.values.toList()) {
        var matchIndex = patients.indexWhere(
            (cloudPatient) => cloudPatient.entityId == localDbPatient.entityId);

        if (matchIndex == -1) {
          patientBox.delete(localDbPatient.entityId);
        }
      }
    }
  }

  void onPatientTapped(Patient selectedPatient) async {
    _logger.d(selectedPatient.id);

    showBusyDialog();

    try {
      _localdbService.currentPatient = ReactiveValue<Patient>(selectedPatient);

      closeBusyDialog();
    } catch (e) {
      closeBusyDialog();

      handleHTTPError(e);
    }

    navigateToInsightsView();
  }

  void navigateToAddPatientView({bool isEdit = false, Patient? patient}) {
    _navigationService.navigateToView(
        AddPatientView(isEdit: isEdit, patient: patient),
        fullscreenDialog: true);
  }

  void navigateToInsightsView() {
    _navigationService.navigateTo(PatientViewNavigatorRoutes.insightsView,
        id: 0);
  }

  void showConfirmDeleteDialog(Patient patient) async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.confirmAlert,
        title: 'Are you sure you wish to delete this patient?',
        data: patient,
        mainButtonTitle: 'Cancel',
        secondaryButtonTitle: 'Delete');

    if (response != null && response.confirmed) {
      if (!isDemo) {
        showBusyDialog();
        try {
          await _apiService.deletePatient(http.Client(), patient);
          closeBusyDialog();
        } catch (e) {
          closeBusyDialog();
          if ((e as BadRequestException).message.contains('USER_NOT_FOUND')) {
            _localdbService.deletePatient(patient.entityId);
          } else {
            handleHTTPError(e);
          }
        }
      }
      _localdbService.deletePatient(patient.entityId);
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_localdbService];
}
