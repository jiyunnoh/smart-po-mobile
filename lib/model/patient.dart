import 'dart:convert';

import 'package:async/async.dart';
import 'package:biot/model/encounter.dart';
import 'package:hive/hive.dart';

import '../app/app.locator.dart';
import '../constants/app_strings.dart';
import '../constants/sex_at_birth.dart';
import '../services/logger_service.dart';
import 'condition.dart';
import 'device.dart';
import 'domain_weight_distribution.dart';
import 'encounter_collection.dart';
import 'kLevel.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  final _logger = locator<LoggerService>().getLogger((Patient).toString());

  @HiveField(0)
  String id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  int? sexAtBirthIndex;

  SexAtBirth get sexAtBirth => SexAtBirth.values[sexAtBirthIndex!];

  @HiveField(5)
  String? caregiverName;

  @HiveField(6)
  bool? isSetToDelete = false;

  @HiveField(7)
  List<Encounter>? encounters;

  @HiveField(8)
  String? domainWeightDistJson;

  String get initial => firstName[0].toUpperCase() + lastName[0].toUpperCase();

  String get fullName => '$lastName, $firstName';

  DomainWeightDistribution? _domainWeightDist;

  DomainWeightDistribution get domainWeightDist {
    if (_domainWeightDist == null) {
      domainWeightDist =
          DomainWeightDistribution.fromJson(jsonDecode(domainWeightDistJson!));
      return _domainWeightDist!;
    } else {
      return _domainWeightDist!;
    }
  }

  set domainWeightDist(DomainWeightDistribution domainWeightDistribution) {
    _domainWeightDist = domainWeightDistribution;
  }

  @HiveField(10)
  String? entityId;

  @HiveField(11)
  DateTime? dob;

  @HiveField(12)
  int? currentSexIndex;

  @HiveField(13)
  int? raceIndex;

  @HiveField(14)
  int? ethnicityIndex;

  @HiveField(15)
  String? conditionJson;

  Condition? _condition;

  Condition? get condition {
    if (_condition == null) {
      condition = Condition.fromJson(jsonDecode(conditionJson!));
      return _condition;
    } else {
      return _condition;
    }
  }

  set condition(Condition? condition) {
    _condition = condition;
  }

  @HiveField(16)
  String? kLevelJson;

  KLevel? _kLevel;

  KLevel? get kLevel {
    if (_kLevel == null) {
      kLevel = KLevel.fromJson(jsonDecode(kLevelJson!));
      return _kLevel;
    } else {
      return _kLevel;
    }
  }

  set kLevel(KLevel? kLevel) {
    _kLevel = kLevel;
  }

  List<Map<String, dynamic>>? devicesJson;
  List<Device>? _devices;

  List<Device>? get devices {
    // if (_devices == null) {
    //   _devices = devicesJson!.map((device) => Device.fromJson(device)).toList();
    //   return _devices;
    // } else {
    return _devices;
    // }
  }

  set devices(List<Device>? devices) {
    _devices = devices;
  }

  @HiveField(17)
  List<String?>? outcomeMeasureIds;

  late EncounterCollection encounterCollection;

  String? countryCode;

  bool isPopulated = false;
  bool isLead;

  Patient(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.entityId,
      this.dob,
      this.sexAtBirthIndex,
      this.currentSexIndex,
      this.raceIndex,
      this.ethnicityIndex,
      this.caregiverName,
      this.domainWeightDistJson,
      this.conditionJson,
      this.kLevelJson,
      this.outcomeMeasureIds,
      this.countryCode,
      this.isLead = false});

  factory Patient.fromJson(Map<String, dynamic> data) {
    return Patient(
      id: data['patient_id'],
      entityId: data['_id'],
      firstName: data['_name']['firstName'],
      lastName: data['_name']['lastName'],
      email: data['_email'],
      dob: DateTime.parse(data['_dateOfBirth']),
      sexAtBirthIndex: data['sex_at_birth'],
      currentSexIndex: data['current_sex'],
      raceIndex: data['race'],
      ethnicityIndex: data['ethnicity'],
      countryCode: data['_address']?['countryCode'],
      caregiverName: (data['_caregiver'] != null)
          ? data['_caregiver']['name'].toString().split('(')[0]
          : null,
      domainWeightDistJson: jsonEncode(data[ksDomainWeightDist]),
      conditionJson: jsonEncode(data['condition']),
      kLevelJson: jsonEncode(data['k_level']),
      outcomeMeasureIds: (data['outcome_measures'] != null)
          ? data['outcome_measures'].toString().replaceAll(' ', '').split(',')
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> body = {
      "_name": {"firstName": firstName, "lastName": lastName},
      "patient_id": id,
      "_templateId": ksPatientTemplateId,
      ksDomainWeightDistribution: {"id": domainWeightDist.entityId},
      "condition": {"id": condition!.entityId},
      "k_level": {"id": kLevel!.entityId},
      "_email": email,
      "_dateOfBirth": dob!.toIso8601String(),
      "sex_at_birth": sexAtBirthIndex,
      "current_sex": currentSexIndex,
      "ethnicity": ethnicityIndex,
      "race": raceIndex,
    };
    return body;
  }

  Future populate() async {
    _logger.d('populating the patient. entity id: $entityId');

    if (isPopulated) {
      _logger.d('already populated');
      return;
    }

    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(domainWeightDist.populate());
    if (condition != null) futureGroup.add(condition!.populate());
    if (kLevel != null) futureGroup.add(kLevel!.populate());
    futureGroup.close();
    await futureGroup.future;

    isPopulated = true;

    _logger.d('successfully populated the patient');
    return true;
  }

  Map<String, dynamic> toJsonForPDF() {
    return {"birth_year": dob!.year.toString(), "sex": sexAtBirth.displayName};
  }
}
