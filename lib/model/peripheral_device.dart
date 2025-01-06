import 'package:biot/model/patient.dart';

import '../constants/enum.dart';

class PeripheralDevice {
  String? id;
  String name;
  String usageType;
  String? createdTimeString;

  DateTime? get createdTime =>
      createdTimeString != null ? DateTime.parse(createdTimeString!) : null;
  EncounterType? type;

  // TODO: Patient should be in Session
  Patient? patient;
  String startTime;
  String endTime;
  String? rawDataId;

  PeripheralDevice(
      {this.id = '',
      required this.name,
      this.createdTimeString,
      required this.usageType,
      required this.patient,
      required this.startTime,
      required this.endTime,
      required this.rawDataId,
      required this.type});

  Map<String, dynamic> data = {};
}

class Mgain extends PeripheralDevice {
  int gain;
  int totalTimePlayed;
  String gameName;
  String gameSettings;
  double batteryLevelAtStart;

  Mgain(
      {required id,
      required name,
      required creationTime,
      patient,
      required this.gain,
      required this.totalTimePlayed,
      required this.gameName,
      required this.gameSettings,
      required this.batteryLevelAtStart,
      required startTime,
      required endTime,
      mgRawDataId})
      : super(
            id: id,
            name: name,
            usageType: 'mgain_monitoring',
            patient: patient,
            startTime: startTime,
            endTime: endTime,
            rawDataId: mgRawDataId,
            type: EncounterType.mg);

  factory Mgain.fromJson(Map<String, dynamic> data) {
    // TODO: Can be optional?
    return Mgain(
        id: data['_id'],
        name: data['_device']['name'],
        creationTime: data['_creationTime'],
        gain: data['gain'],
        totalTimePlayed: data['totalTimePlayed'],
        gameName: data['gameName'],
        gameSettings: data['gameSettings'],
        mgRawDataId: data['mgRawData']['id'],
        batteryLevelAtStart: data['batteryLevelAtStart'],
        startTime: data['_startTime'],
        endTime: data['_endTime']);
  }

  @override
  Map<String, dynamic> get data => {
        "totalTimePlayed": totalTimePlayed,
        "batteryLevelAtStart": batteryLevelAtStart,
        "gameName": gameName,
        "gain": gain,
        "gameSettings": gameSettings
      };

//  TODO: factory Mgain.fromRandom
}

class Prosat extends PeripheralDevice {
  int stepsPerDay;
  int cadence;
  int sensitivity;

  Prosat(
      {required id,
      required name,
      required creationTime,
      patient,
      required this.stepsPerDay,
      required this.cadence,
      required this.sensitivity,
      required startTime,
      required endTime,
      prosatRawDataId})
      : super(
            id: id,
            name: name,
            usageType: 'prosat_monitoring',
            patient: patient,
            startTime: startTime,
            endTime: endTime,
            rawDataId: prosatRawDataId,
            type: EncounterType.prosat);

  factory Prosat.fromJson(Map<String, dynamic> data) {
    return Prosat(
        id: data['_id'],
        name: data['_device']['name'],
        creationTime: data['_creationTime'],
        stepsPerDay: data['prosat_steps_per_day'],
        cadence: data['prosat_cadence'],
        sensitivity: data['prosat_sensitivity'],
        startTime: data['_startTime'],
        endTime: data['_endTime'],
        prosatRawDataId: data['prosatRawData']['id']);
  }

  @override
  Map<String, dynamic> get data => {
        "prosat_steps_per_day": stepsPerDay,
        "prosat_cadence": cadence,
        "prosat_sensitivity": sensitivity
      };
}
