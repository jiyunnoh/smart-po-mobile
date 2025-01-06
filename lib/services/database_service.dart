import 'dart:convert';
import 'package:biot/model/patient.dart';
import 'package:biot/model/encounter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../model/demo_globals.dart';
import 'logger_service.dart';

Future<void> setupDatabase() async {
  // Retrieve encryption key to open the hive database
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var containsEncryptionKey =
      await secureStorage.containsKey(key: 'encryptionKey');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(
        key: 'encryptionKey', value: base64UrlEncode(key));
  }

  // Initialize Hive database
  await Hive.initFlutter();
  Hive.registerAdapter(PatientAdapter());
  Hive.registerAdapter(EncounterAdapter());

  // Decode the key and open the database
  var encryptionKey =
      base64Url.decode((await secureStorage.read(key: 'encryptionKey'))!);
  await Hive.openBox<Patient>('patients',
      encryptionCipher: HiveAesCipher(encryptionKey));
}

class DatabaseService with ListenableServiceMixin {
  final _logger =
      locator<LoggerService>().getLogger((DatabaseService).toString());

  List<Patient> demoPatients = [];
  Box<Patient> patientsBox = Hive.box<Patient>('patients');
  ReactiveValue<Patient>? currentPatient;

  Function? onCurrentPatientDataChanged;

  DatabaseService() {
    listenToReactiveValues([currentPatient]);
  }

  void updateCurrentPatient() {
    _logger.d('');
    if (onCurrentPatientDataChanged != null) {
      onCurrentPatientDataChanged!();
    }
    notifyListeners();
  }

  void addPatient(Patient patient) {
    _logger.d('');

    if (isDemo) {
      demoPatients.add(patient);
      notifyListeners();
    } else {
      patientsBox.put(patient.entityId, patient);
    }
  }

  void deletePatient(patientId) {
    _logger.d('');

    if (isDemo) {
      int index =
          demoPatients.indexWhere((element) => element.entityId == patientId);
      demoPatients.removeAt(index);
      notifyListeners();
    } else {
      patientsBox.delete(patientId);
    }
  }

  void editPatient(Patient patient) {
    _logger.d('');

    if (isDemo) {
      int index = demoPatients
          .indexWhere((element) => element.entityId == patient.entityId);
      demoPatients[index] = patient;
      notifyListeners();
    } else {
      patient.save();
    }
  }
}
