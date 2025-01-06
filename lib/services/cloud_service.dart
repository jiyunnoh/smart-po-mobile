import 'dart:core';
import 'dart:convert';
import 'dart:math';
import 'package:async/async.dart';
import 'package:biot/constants/enum.dart';
import 'package:biot/model/domain_weight_distribution.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/services/file_service.dart';
import 'package:http/http.dart' as http;
import 'package:biot/app/app.locator.dart';
import 'package:biot/model/patient.dart';
import 'package:biot/model/encounter.dart';
import 'package:intl/intl.dart';
import '../constants/app_strings.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/condition.dart';
import '../model/device.dart';
import '../model/kLevel.dart';
import '../model/peripheral_device.dart';
import 'logger_service.dart';

const String _endpoint = 'https://api.dev.orthocare.biot-med.com';
const String _getGenericEntitiesApi = '/generic-entity/v1/generic-entities';
const String _deleteGenericEntityApi = '/generic-entity/v1/generic-entities/';
const String _getUsageSessionsApi = '/device/v1/devices/usage-sessions';
const String _paramName = 'searchRequest';

class BiotService {
  final _fileService = locator<FileService>();
  final _logger = locator<LoggerService>().getLogger((BiotService).toString());

  String _token = '';
  late String userId;
  String? caregiverId;
  String? caregiverName;
  late String ownerOrganizationId;

  // late String ownerOrganizationCode;
  late String _refreshToken;
  DateTime? updateTime;

  Map<String, String> get requestHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Map<String, String> get requestHeadersAuthorization => {
        'Authorization': 'Bearer $_token',
      };

  Map<String, String> get requestHeadersConfirmEmail => {
        'email-confirmation-landing-page':
            'https://organization.app.dev.orthocare.biot-med.com/auth/invitation',
      };

  Map<String, String> get requestHeadersForgotPassword => {
        'forgot-password-landing-page':
            'https://organization.app.dev.orthocare.biot-med.com/auth/password/reset',
      };

  Future<List<OutcomeMeasure>> getOutcomeMeasureHistory(
      http.Client client, Patient patient, OutcomeMeasure outcomeMeasure,
      {bool isRetry = false}) async {
    _logger.d('');

      String url = _endpoint + _getGenericEntitiesApi;
      Map<String, dynamic> responseJson;

      //requires authorization
      Map<String, String> header = {};
      header.addAll(requestHeaders);
      header.addAll(requestHeadersAuthorization);

      Map<String, dynamic> filterById = {
        "filter": {
          "_templateId": {"eq": outcomeMeasure.templateId},
          "${outcomeMeasure.id}_patient.id": {"eq": patient.entityId}
        }
      };

      //encode map to json
      String jsonString = json.encode(filterById);
      String paramRequest =
          '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
      String urlWithParam = url + paramRequest;

      try {
        final response =
            await client.get(Uri.parse(urlWithParam), headers: header);

        responseJson = _returnResponse(response);

        _logger.d('successfully retrieved outcome measure history');

        return (responseJson['data'] as List)
            .map((outcomeMeasure) => OutcomeMeasure.fromJson(outcomeMeasure))
            .toList();
      } on ExpiredTokenException {
        if (isRetry) {
          rethrow;
        } else {
          _logger.d('retry');

          await refreshTokens(http.Client(), _refreshToken);
          return Future.delayed(const Duration(seconds: 2)).then((value) =>
              getOutcomeMeasureHistory(http.Client(), patient, outcomeMeasure,
                  isRetry: true));
        }
      } catch (e) {
        rethrow;
      }
  }

  Future<PeripheralDevice?> getUsageSession(http.Client client,
      {bool isRetry = false, required String usageSessionId}) async {
    _logger.d('');

    String url = _endpoint + _getUsageSessionsApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterByUsageSessionId = {
      "filter": {
        "_id": {"eq": usageSessionId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterByUsageSessionId);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      EncounterType type = getType(responseJson['data'][0]['_device']['name']);

      switch (type) {
        case EncounterType.mg:
          return Mgain.fromJson(responseJson['data'][0]);

        case EncounterType.prosat:
          return Prosat.fromJson(responseJson['data'][0]);
        default:
          return null;
      }
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            getUsageSession(http.Client(),
                usageSessionId: usageSessionId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, List<Encounter>>> getUsageSessions(
      http.Client client, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getUsageSessionsApi;
    Map<String, dynamic> responseJson;
    Map<String, List<Encounter>> usageSessionsMap = {};

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterByPatient = {
      "filter": {
        "_patient.id": {"eq": patient.entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterByPatient);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      (responseJson['data'] as List).map((usageSession) {
        EncounterType type = getType(usageSession['_device']['name']);
        switch (type) {
          case EncounterType.mg:
            if (usageSessionsMap.containsKey('mg')) {
              // TODO: convert Mgain to Encounter
              usageSessionsMap['mg']!
                  .add(Mgain.fromJson(usageSession) as Encounter);
            } else {
              usageSessionsMap['mg'] = [
                Mgain.fromJson(usageSession) as Encounter
              ];
            }
            break;

          case EncounterType.prosat:
            if (usageSessionsMap.containsKey('prosat')) {
              // TODO: convert Prosat to Encounter
              usageSessionsMap['prosat']!
                  .add(Prosat.fromJson(usageSession) as Encounter);
            } else {
              usageSessionsMap['prosat'] = [
                Prosat.fromJson(usageSession) as Encounter
              ];
            }
            break;
          case EncounterType.outcomeMeasure:
            break;
          case EncounterType.unknown:
            break;
        }
      }).toList();

      return usageSessionsMap;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then(
            (value) => getUsageSessions(http.Client(), patient, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Encounter?> addUsageEncounter(http.Client client,
      {required PeripheralDevice usageEncounter, bool isRetry = false}) async {
    _logger.d('');

    String addUsageSessionByUsageTypeApi =
        '/device/v1/devices/${usageEncounter.name}/usage-sessions/usage-type/${usageEncounter.usageType}';
    String url = _endpoint + addUsageSessionByUsageTypeApi;

    // Upload a file
    Map<String, String> fileMap = await uploadFileId(client,
        deviceId: usageEncounter.name, patient: usageEncounter.patient!);
    await uploadFile(
        signedUrl: fileMap[ksSignedUrl]!,
        filePath: "assets/files/${fileMap['fileName']}");

    Map<String, dynamic> bodyMap = {
      "_startTime": usageEncounter.startTime,
      "_endTime": usageEncounter.endTime,
      "_state": "DONE",
      "_summary": {
        "_stopReason": "Manual Stop",
        "_stopReasonCode": "COMPLETION"
      },
      "_patient": {"id": usageEncounter.patient!.id},
      "${usageEncounter.type!.toStringValue()}RawData": {
        "id": fileMap[ksFileId]
      }
    };
    bodyMap.addAll(usageEncounter.data);

    String requestBody = jsonEncode(bodyMap);

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    Map<String, dynamic> responseJson;

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);

      switch (usageEncounter.type) {
        case EncounterType.mg:
          // TODO: convert Mgain to Encounter
          return Mgain.fromJson(responseJson) as Encounter;

        case EncounterType.prosat:
          // TODO: convert Prosat to Encounter
          return Prosat.fromJson(responseJson) as Encounter;
        case EncounterType.outcomeMeasure:
          break;
        case EncounterType.unknown:
          break;
        default:
          break;
      }
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addUsageEncounter(http.Client(),
                usageEncounter: usageEncounter, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Get an upload file id and a pre-signed url.
  Future<Map<String, String>> uploadFileId(http.Client client,
      {required String deviceId,
      required Patient patient,
      bool isRetry = false}) async {
    _logger.d('');

    const String uploadFileApi = '/file/v1/files/upload';
    String url = _endpoint + uploadFileApi;

    Map<String, dynamic> responseJson;
    Map<String, String> fileMap = {};

    const String date = '20230622';

    String fileName =
        '${deviceId}_${patient.lastName[0].toLowerCase()}${patient.firstName}_$date.csv';

    String requestBody = jsonEncode({"name": fileName, "mimeType": "text/csv"});

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);
      fileMap[ksFileId] = responseJson['id'];
      fileMap[ksSignedUrl] = responseJson[ksSignedUrl];
      fileMap['fileName'] = fileName;
      return fileMap;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            uploadFileId(http.Client(),
                deviceId: deviceId, patient: patient, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Upload a file to the pre-signed url.
  Future<void> uploadFile(
      {required String signedUrl,
      required String filePath,
      bool isRetry = false}) async {
    _logger.d('');

    final myFile = await rootBundle.loadString(filePath);

    try {
      await http.put(Uri.parse(signedUrl),
          headers: {'Content-Type': 'text/csv'}, body: myFile);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadFile({required fileId}) async {
    Map<String, String> fileMap =
        await getFileById(http.Client(), fileId: fileId);
    String fileBody = await getFile(signedUrl: fileMap[ksSignedUrl]!);
    _fileService.writeFile(fileBody, fileMap['fileName']!);
  }

  // Get a file name and pre-signed url by id.
  Future<Map<String, String>> getFileById(http.Client client,
      {required String fileId}) async {
    _logger.d('');

    const String getFileByIdApi = '/file/v1/files/';
    String url = '$_endpoint$getFileByIdApi$fileId/download';
    Map<String, dynamic> responseJson;
    Map<String, String> fileMap = {};

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    try {
      final response = await client.get(Uri.parse(url), headers: header);

      responseJson = _returnResponse(response);
      fileMap['fileName'] = responseJson['name'];
      fileMap[ksSignedUrl] = responseJson[ksSignedUrl];

      return fileMap;
    } catch (e) {
      rethrow;
    }
  }

  // Get the file from the pre-signed url.
  Future<String> getFile({required String signedUrl}) async {
    _logger.d('');

    try {
      final response = await http.get(Uri.parse(signedUrl));
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addMeasurement(http.Client client, DateTime time, int totalSteps,
      {bool isRetry = false}) async {
    _logger.d('');

    const String addMeasurementApi = '/measurement/v1/measurements';
    String url = _endpoint + addMeasurementApi;
    int temp = Random().nextInt(5000);
    totalSteps = totalSteps + temp;

    String requestBody = jsonEncode({
      "metadata": {
        "timestamp": time.toIso8601String(),
        "deviceId": "SWREMOTE0002",
        "patientId": "e5f472aa-1fde-473d-bec6-1ffbbe83dd65",
        "sessionId": "c348458b-c524-4f33-bdb8-99bbf0caf323"
      },
      "data": {"total_steps": totalSteps}
    });

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addMeasurement(http.Client(), time, totalSteps, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }

    return totalSteps;
  }

  //login with credentials
  Future<void> loginWithCredentials(http.Client client, id, pwd) async {
    _logger.d('attempting to log in');

    const String loginWithCredentialsApi = '/ums/v2/users/login';
    String url = _endpoint + loginWithCredentialsApi;
    Map<String, dynamic> responseJson;

    try {
      final response = await client.post(Uri.parse(url),
          headers: requestHeaders,
          body: jsonEncode(<String, String>{"username": id, "password": pwd}));

      responseJson = _returnResponse(response);
      _logger.d('successfully logged in');
      _logger.d('current time: ${DateTime.now()}');

      userId = id;
      // caregiverId = responseJson['userId'];
      ownerOrganizationId = responseJson[ksOwnerOrganizationId];
      _token = responseJson[ksAccessJwt][ksToken];
      _refreshToken = responseJson[ksRefreshJwt][ksToken];

      _logger.d(
          'expiration time: ${DateTime.parse(responseJson[ksAccessJwt]['expiration']).toLocal()}');

      return;
    } catch (e) {
      rethrow;
    }
  }

  //refresh tokens
  Future<void> refreshTokens(http.Client client, refreshToken) async {
    _logger.d('');
    const String refreshTokenApi = '/ums/v2/users/token/refresh';
    String url = _endpoint + refreshTokenApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    try {
      final response = await client.post(Uri.parse(url),
          headers: header,
          body: jsonEncode(<String, String>{"refreshToken": refreshToken}));

      responseJson = _returnResponse(response);

      _token = responseJson[ksAccessJwt][ksToken];
      _refreshToken = responseJson[ksRefreshJwt][ksToken];

      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut(http.Client client) async {
    _logger.d('');

    const String logOutApi = '/ums/v2/users/logout';
    String url = _endpoint + logOutApi;

    try {
      final response = await client.post(Uri.parse(url),
          headers: requestHeaders,
          body: jsonEncode(<String, String>{"refreshToken": _refreshToken}));

      _returnResponse(response);

      return;
    } catch (e) {
      rethrow;
    }
  }

  // Forgot Password
  Future<void> forgotPassword(http.Client client, String username) async {
    _logger.d('');

    const String forgotPasswordApi = '/ums/v2/users/self/password/forgot';
    String url = _endpoint + forgotPasswordApi;

    String requestBody = jsonEncode({"username": username});

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersForgotPassword);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Patient>> getPatients(http.Client client,
      {bool isRetry = false, String? caregiverId}) async {
    _logger.d('');

    const String getPatientsApi = '/organization/v1/users/patients';
    String url = _endpoint + getPatientsApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    String urlWithParam = url;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved patient list');

      List<Patient> patients = (responseJson['data'] as List).map((patient) {
        return Patient.fromJson(patient);
      }).toList();

      _logger.d('successfully converted json to List<Patient>');

      updateTime = DateTime.now();

      return patients;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2))
            .then((value) => getPatients(http.Client(), isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  //add a new patient
  Future<String> addPatient(
    http.Client client,
    Patient patient, {
    bool isRetry = false,
    List<Device>? deviceList,
  }) async {
    _logger.d('');

      const String addPatientApi = '/organization/v1/users/patients';
      String url = _endpoint + addPatientApi;
      Map<String, dynamic> responseJson;

      // TODO: can use futureGroup?
      // POST domain weight distribution.
      patient.domainWeightDist.entityId =
          await addDomainWeightDistribution(client, patient);
      patient.domainWeightDistJson =
          jsonEncode(patient.domainWeightDist.toJson());

      // POST condition.
      patient.condition!.entityId = await addCondition(client, patient);
      patient.conditionJson = jsonEncode(patient.condition!.toJson());

      // POST k-level.
      patient.kLevel!.entityId = await addKLevel(client, patient);
      patient.kLevelJson = jsonEncode(patient.kLevel!.toJson());

      Map<String, dynamic> bodyMap = {
        ksOwnerOrganization: {"id": ownerOrganizationId},
      };

      bodyMap.addAll(patient.toJson());

      if (caregiverId != null) {
        bodyMap.addAll({
          "_caregiver": {"id": caregiverId}
        });
      }
      String requestBody = jsonEncode(bodyMap);

      http.Request request = http.Request('post', Uri.parse(url));
      request.body = requestBody;
      request.headers.addAll(requestHeaders);
      request.headers.addAll(requestHeadersAuthorization);
      request.headers.addAll(requestHeadersConfirmEmail);

      try {
        final response =
            await http.Response.fromStream(await client.send(request));

        responseJson = _returnResponse(response);

        patient.entityId = responseJson['_id'];

        FutureGroup futureGroup = FutureGroup();

        // POST device
        if (deviceList != null) {
          futureGroup.add(addDevices(client, deviceList, patient: patient));
        }

        futureGroup.close();
        await futureGroup.future;

        return patient.entityId!;
      } on ExpiredTokenException {
        if (isRetry) {
          rethrow;
        } else {
          _logger.d('retry');

          await refreshTokens(http.Client(), _refreshToken);
          return Future.delayed(const Duration(seconds: 2)).then(
              (value) => addPatient(http.Client(), isRetry: true, patient));
        }
      } catch (e) {
        rethrow;
    }
  }

  Future<void> editPatient(http.Client client, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

      const String updatePatientApi = '/organization/v1/users/patients/';
      String url = _endpoint + updatePatientApi + patient.entityId!;

      String requestBody = jsonEncode({
        "patient_id": patient.id,
        "_name": {"firstName": patient.firstName, "lastName": patient.lastName},
        "_dateOfBirth": patient.dob!.toIso8601String(),
        "sex_at_birth": patient.sexAtBirthIndex,
        "current_sex": patient.currentSexIndex,
        "race": patient.raceIndex,
        "ethnicity": patient.ethnicityIndex
      });

      http.Request request = http.Request('patch', Uri.parse(url));
      request.body = requestBody;
      request.headers.addAll(requestHeaders);
      request.headers.addAll(requestHeadersAuthorization);

      try {
        final response =
            await http.Response.fromStream(await client.send(request));

        _returnResponse(response);
        return;
      } on ExpiredTokenException {
        if (isRetry) {
          rethrow;
        } else {
          _logger.d('retry');

          await refreshTokens(http.Client(), _refreshToken);
          return Future.delayed(const Duration(seconds: 2)).then(
              (value) => editPatient(http.Client(), patient, isRetry: true));
        }
      } catch (e) {
        rethrow;
      }
  }

  Future<void> deletePatient(http.Client client, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

      const String deletePatientApi = '/organization/v1/users/patients/';
      String url = _endpoint + deletePatientApi + patient.entityId!;
      patient.isSetToDelete = true;

      //requires authorization
      Map<String, String> header = {
        'Accept': '*/*',
      };

      http.Request request = http.Request('delete', Uri.parse(url));
      request.headers.addAll(header);
      request.headers.addAll(requestHeadersAuthorization);

      try {
        // Get devices list and delete them.
        List<Device> devices = await getDevices(client, patient: patient);
        await deleteDevices(http.Client(), devices);

        // Get OM list to check to make sure if it is empty.
        List<Encounter> encounters =
            await getOutcomeMeasureEncounters(client, patient);

        if (encounters.isEmpty) {
          final response =
              await http.Response.fromStream(await client.send(request));

          _returnResponse(response);

          FutureGroup futureGroup = FutureGroup();
          // Delete the current domain weight distribution from the cloud
          futureGroup.add(deleteDomainWeightDistribution(
              http.Client(), patient.domainWeightDist.entityId!));

          // Delete the current condition from the cloud.
          if (patient.condition != null) {
            futureGroup.add(
                deleteCondition(http.Client(), patient.condition!.entityId!));
          }

          // Delete the current k-level from the cloud.
          if (patient.kLevel != null) {
            futureGroup
                .add(deleteKLevel(http.Client(), patient.kLevel!.entityId!));
          }

          futureGroup.close();
          await futureGroup.future;
        } else {
          FutureGroup futureGroup = FutureGroup();

          for (Encounter encounter in encounters) {
            futureGroup.add(deleteEncounter(client, encounter));
          }

          futureGroup.close();
          await futureGroup.future;

          final response =
              await http.Response.fromStream(await client.send(request));

          _returnResponse(response);
        }
      } on ExpiredTokenException {
        if (isRetry) {
          rethrow;
        } else {
          _logger.d('retry');

          await refreshTokens(http.Client(), _refreshToken);
          return Future.delayed(const Duration(seconds: 2)).then(
              (value) => deletePatient(http.Client(), patient, isRetry: true));
        }
      } catch (e) {
        rethrow;
      }
  }

  Future<String> addDomainWeightDistribution(
      http.Client client, Patient patient,
      {String? date, bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;
    date = date ?? 'current';

    Map<String, dynamic> domainWeightDistJson =
        patient.domainWeightDist.toJson();

    domainWeightDistJson.addAll({
      "_name": "${patient.initial}_dwd_$date",
      ksOwnerOrganization: {"id": ownerOrganizationId},
    });

    String requestBody = jsonEncode(domainWeightDistJson);

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);

      _logger.d('successfully added domain weight dist');

      return responseJson['_id'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addDomainWeightDistribution(http.Client(), patient,
                date: date, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainWeightDistribution> getDomainWeightDistribution(
      http.Client client, String entityId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterById = {
      "filter": {
        "_id": {"eq": entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterById);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;
    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved domain weight dist');

      return DomainWeightDistribution.fromJson(responseJson['data'][0]);
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            getDomainWeightDistribution(http.Client(), entityId,
                isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editDomainWeightDistribution(http.Client client,
      {required String domainWeightDistId,
      required DomainWeightDistribution domainWeightDistribution,
      bool isRetry = false}) async {
    _logger.d('');

    String url = '$_endpoint$_getGenericEntitiesApi/$domainWeightDistId';

    String requestBody = jsonEncode({
      ksComfortWeightVal: domainWeightDistribution.comfort,
      ksFunctionWeightVal: domainWeightDistribution.function,
      ksHrQoLWeightVal: domainWeightDistribution.hrqol,
      ksGoalsWeightVal: domainWeightDistribution.goals,
      ksSatisfactionWeightVal: domainWeightDistribution.satisfaction
    });

    http.Request request = http.Request('patch', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);
      _logger.d('successfully edited domain weight dist');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            editDomainWeightDistribution(http.Client(),
                domainWeightDistId: domainWeightDistId,
                domainWeightDistribution: domainWeightDistribution,
                isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDomainWeightDistribution(
      http.Client client, String domainWeightDistId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _deleteGenericEntityApi + domainWeightDistId;

    //requires authorization
    Map<String, String> header = {
      'Accept': '*/*',
    };

    http.Request request = http.Request('delete', Uri.parse(url));
    request.headers.addAll(header);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully deleted domain weight dist');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            deleteDomainWeightDistribution(http.Client(), domainWeightDistId,
                isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addDomainScores(
      http.Client client, Patient patient, Encounter encounter,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    Map<String, dynamic> jsonMap = {
      "_templateId": ksDomainScoresTemplateId,
      "_name": encounter.generateUniqueEntityInstanceNameWithPatient(
          patient, 'dm_scores'),
      ksOwnerOrganization: {"id": ownerOrganizationId},
      "patient_domain_scores": {"id": patient.entityId}
    };

    encounter.domainsMap.forEach((key, value) {
      jsonMap.addAll(value.scoreToJson());
    });

    String requestBody = jsonEncode(jsonMap);

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);

      _logger.d('successfully added domain scores');

      encounter.domainScoresId = responseJson['_id'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addDomainScores(http.Client(), patient, encounter, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getDomainScores(http.Client client, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterByPatient = {
      "filter": {
        "_templateId": {"eq": ksDomainScoresTemplateId},
        "patient_domain_scores.id": {"eq": patient.entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterByPatient);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved domain scores');

      return responseJson['data'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then(
            (value) => getDomainScores(http.Client(), patient, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDomainScores(http.Client client,
      {required String domainScoresId, bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _deleteGenericEntityApi + domainScoresId;

    //requires authorization
    Map<String, String> header = {
      'Accept': '*/*',
    };

    http.Request request = http.Request('delete', Uri.parse(url));
    request.headers.addAll(header);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully deleted domain scores');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            deleteDomainScores(http.Client(),
                domainScoresId: domainScoresId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addKLevel(http.Client client, Patient patient,
      {String? date, bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;
    date = date ?? 'current';

    Map<String, dynamic> kLevelJson = patient.kLevel!.toJson();
    kLevelJson.addAll({
      "_name": "${patient.initial}_kLevel_$date",
      ksOwnerOrganization: {"id": ownerOrganizationId},
    });

    String requestBody = jsonEncode(kLevelJson);

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);

      _logger.d('successfully added k-level');

      return responseJson['_id'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addKLevel(http.Client(), patient, date: date, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<KLevel> getKLevel(http.Client client, String entityId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterById = {
      "filter": {
        "_id": {"eq": entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterById);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved k-level');

      return KLevel.fromJson(responseJson['data'][0]);
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2))
            .then((value) => getKLevel(http.Client(), entityId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editKLevel(http.Client client,
      {required String kLevelId,
      required KLevel kLevel,
      bool isRetry = false}) async {
    _logger.d('');

    String url = '$_endpoint$_getGenericEntitiesApi/$kLevelId';
    String requestBody = jsonEncode({"k_level": kLevel.kLevelValue});

    http.Request request = http.Request('patch', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully edited k-level');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            editKLevel(http.Client(),
                kLevelId: kLevelId, kLevel: kLevel, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteKLevel(http.Client client, String kLevelId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _deleteGenericEntityApi + kLevelId;

    //requires authorization
    Map<String, String> header = {
      'Accept': '*/*',
    };

    http.Request request = http.Request('delete', Uri.parse(url));
    request.headers.addAll(header);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully deleted k-level');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then(
            (value) => deleteKLevel(http.Client(), kLevelId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> addDevices(http.Client client, List<Device> deviceList,
      {String? date,
      Patient? patient,
      Encounter? encounter,
      bool isRetry = false}) async {
    List<String> result = [];

    for (var i = 0; i < deviceList.length; i++) {
      String eachDeviceId = await addDevice(http.Client(), deviceList[i],
          patient: patient, date: date, encounter: encounter);
      result.add(eachDeviceId);
    }

    return result;
  }

  Future<String> addDevice(http.Client client, Device device,
      {String? date,
      Patient? patient,
      Encounter? encounter,
      bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    String requestBody = jsonEncode(device.toJson(ownerOrganizationId,
        patient: patient, date: date, encounter: encounter));

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));
      responseJson = _returnResponse(response);

      _logger.d('successfully added device');

      return responseJson['_id'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addDevice(http.Client(), device,
                patient: patient, encounter: encounter, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Device>> getDevices(http.Client client,
      {bool isRetry = false, Patient? patient, Encounter? encounter}) async {
    _logger.d('');

      String url = _endpoint + _getGenericEntitiesApi;
      Map<String, dynamic> responseJson;

      //requires authorization
      Map<String, String> header = {};
      header.addAll(requestHeaders);
      header.addAll(requestHeadersAuthorization);

      Map<String, dynamic> filterByPatient = {
        "filter": {
          "_templateId": {"eq": ksDeviceTemplateId},
          "patient_for_device.id": {"eq": patient?.entityId},
          "encounter_for_device.id": {"eq": encounter?.entityId}
        }
      };

      //encode map to json
      String jsonString = json.encode(filterByPatient);
      String paramRequest =
          '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
      String urlWithParam = url + paramRequest;

      try {
        final response =
            await client.get(Uri.parse(urlWithParam), headers: header);

        responseJson = _returnResponse(response);

        _logger.d('successfully retrieved device list');

        List<Device> devices = (responseJson['data'] as List)
            .map((device) => Device.fromJson(device))
            .toList();

        _logger.d('successfully converted json to List<Device>');

        return devices;
      } on ExpiredTokenException {
        if (isRetry) {
          rethrow;
        } else {
          _logger.d('retry');

          await refreshTokens(http.Client(), _refreshToken);
          return Future.delayed(const Duration(seconds: 2)).then((value) =>
              getDevices(http.Client(),
                  patient: patient, encounter: encounter, isRetry: true));
        }
      } catch (e) {
        rethrow;
      }
  }

  Future<void> editDevice(http.Client client, Device device,
      {bool isRetry = false, String? date}) async {
    _logger.d('');

    String url = '$_endpoint$_getGenericEntitiesApi/${device.id}';

    String requestBody = jsonEncode({
      "amputee_side": device.amputeeSide.index,
      "l_code": device.lCode,
      "device_name": device.deviceName
    });

    http.Request request = http.Request('patch', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully edited device');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2))
            .then((value) => editDevice(http.Client(), device, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDevices(http.Client client, List<Device> deviceList,
      {bool isRetry = false}) async {
    FutureGroup futureGroup = FutureGroup();

    for (var i = 0; i < deviceList.length; i++) {
      futureGroup.add(deleteDevice(http.Client(), deviceId: deviceList[i].id));
    }
    futureGroup.close();
    await futureGroup.future;
  }

  Future<void> deleteDevice(http.Client client,
      {required String deviceId, bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _deleteGenericEntityApi + deviceId;

    //requires authorization
    Map<String, String> header = {
      'Accept': '*/*',
    };

    http.Request request = http.Request('delete', Uri.parse(url));
    request.headers.addAll(header);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully deleted device');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            deleteDevice(http.Client(), deviceId: deviceId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addCondition(http.Client client, Patient patient,
      {String? date, bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;
    date = date ?? 'current';

    Map<String, dynamic> conditionJson = patient.condition!.toJson();

    conditionJson.addAll({
      "_name": "${patient.initial}_condition_$date",
      ksOwnerOrganization: {"id": ownerOrganizationId},
    });

    String requestBody = jsonEncode(conditionJson);

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);

      _logger.d('successfully added condition');

      return responseJson['_id'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addCondition(http.Client(), patient, date: date, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Condition> getCondition(http.Client client, String entityId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterById = {
      "filter": {
        "_id": {"eq": entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterById);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);
      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved condition');

      return Condition.fromJson(responseJson['data'][0]);
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then(
            (value) => getCondition(http.Client(), entityId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editCondition(http.Client client,
      {required String conditionId,
      required Condition condition,
      bool isRetry = false}) async {
    _logger.d('');

    String url = '$_endpoint$_getGenericEntitiesApi/$conditionId';

    String requestBody =
        jsonEncode({"condition_type": condition.conditionsList});

    http.Request request = http.Request('patch', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully edited condition');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            editCondition(http.Client(),
                condition: condition, conditionId: conditionId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCondition(http.Client client, String conditionsId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _deleteGenericEntityApi + conditionsId;

    //requires authorization
    Map<String, String> header = {
      'Accept': '*/*',
    };

    http.Request request = http.Request('delete', Uri.parse(url));
    request.headers.addAll(header);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully deleted condition');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            deleteCondition(http.Client(), conditionsId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Encounter>> getEncounters(
      http.Client client, Patient patient) async {
    _logger.d('');

    List<Encounter> sessionList = [];
    List<Encounter> outcomeMeasureSessionList = [];
    Map<String, List<Encounter>> usageSessions = {};

    FutureGroup futureGroup = FutureGroup();

    // Add the outcome measure sessions future to the group
    futureGroup.add(getOutcomeMeasureEncounters(client, patient));

    // Add the usage sessions future to the group
    futureGroup.add(getUsageSessions(client, patient));

    futureGroup.close();

    // Wait for all futures to complete
    List results = await futureGroup.future;

    // Process the outcome measure sessions
    outcomeMeasureSessionList = results[0];
    if (outcomeMeasureSessionList.isNotEmpty) {
      sessionList.addAll(outcomeMeasureSessionList);
    }

    // Process the usage sessions
    usageSessions = results[1];
    if (usageSessions[EncounterType.mg.toStringValue()] != null) {
      sessionList.addAll(usageSessions[EncounterType.mg.toStringValue()]!);
    }
    if (usageSessions[EncounterType.prosat.toStringValue()] != null) {
      sessionList.addAll(usageSessions[EncounterType.prosat.toStringValue()]!);
    }

    return sessionList;
  }

  // Get a list of outcome measure encounters filtered by patient
  Future<List<Encounter>> getOutcomeMeasureEncounters(
      http.Client client, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterByPatient = {
      "filter": {
        "_templateName": {"eq": ksSmartpoEncounter},
        "patient_smartpo.id": {"eq": patient.entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterByPatient);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);
      _logger.d('successfully retrieved encounter list');

      List<Encounter> encounters = (responseJson['data'] as List)
          .map((encounter) => Encounter.fromJson(encounter))
          .toList();

      // Get previous encounter's outcome measures set
      if (encounters.isNotEmpty) {
        patient.outcomeMeasureIds = encounters.last.outcomeMeasureIds;
      }
      _logger.d('successfully converted json to List<Encounter>');

      return encounters;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            getOutcomeMeasureEncounters(http.Client(), patient, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get a list of outcome measures
  Future<List<OutcomeMeasure>> getOutcomeMeasures(Encounter encounter) async {
    List<OutcomeMeasure> result = [];
    await Future.forEach(encounter.outcomeMeasures!,
        (OutcomeMeasure outcomeMeasure) async {
      OutcomeMeasure eachOutcomeMeasure =
          await getOutcomeMeasure(http.Client(), outcomeMeasure);
      result.add(eachOutcomeMeasure);
    });

    return result;
  }

  // Get each outcome measure
  Future<OutcomeMeasure> getOutcomeMeasure(
      http.Client client, OutcomeMeasure outcomeMeasure,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    Map<String, dynamic> filterById = {
      "filter": {
        "_id": {"eq": outcomeMeasure.entityId}
      }
    };

    //encode map to json
    String jsonString = json.encode(filterById);
    String paramRequest =
        '?$_paramName=${Uri.encodeQueryComponent(jsonString)}';
    String urlWithParam = url + paramRequest;

    try {
      final response =
          await client.get(Uri.parse(urlWithParam), headers: header);

      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved outcome measure');

      outcomeMeasure.populateWithJson(responseJson['data'][0]);
      return outcomeMeasure;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            getOutcomeMeasure(http.Client(), outcomeMeasure, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Add a new encounter
  Future<void> addEncounter(
      http.Client client, Encounter encounter, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    String currentTime =
        '${DateFormat('yyyyMMdd').format(DateTime.now())}_${DateFormat.Hms().format(DateTime.now())}';

    // Add outcome measures
    await addOutcomeMeasures(encounter.outcomeMeasures!, patient);

    // Add domain scores
    await addDomainScores(client, patient, encounter);

    Map<String, dynamic> encounterJson = encounter.toJson();

    encounterJson.addAll({
      "_name": "${patient.initial}_session_$currentTime",
      ksOwnerOrganization: {"id": ownerOrganizationId},
      "patient_smartpo": {"id": patient.entityId},
      "domain_weight_distribution_smartpo": {
        "id": patient.domainWeightDist.entityId
      },
      "condition_smartpo": {"id": patient.condition!.entityId},
      "k_level_smartpo": {"id": patient.kLevel!.entityId},
    });

    // TODO: Jiyun - Removing this code will break the domain chart legend in Insights view.
    for (var i = 0; i < encounter.outcomeMeasures!.length; i++) {
      OutcomeMeasure om = encounter.outcomeMeasures![i];
      encounterJson.addAll({
        "${om.id}_smartpo": {"id": om.entityId}
      });
    }

    String requestBody = jsonEncode(encounterJson);

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      responseJson = _returnResponse(response);

      _logger.d('successfully added encounter');

      encounter.entityId = responseJson['_id'];

      // Add devices
      List<Device> devices = await getDevices(client, patient: patient);
      await addDevices(client, devices,
          date: currentTime, encounter: encounter);
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addEncounter(http.Client(), encounter, patient, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Add a list of outcome measures
  Future<List<String>> addOutcomeMeasures(
      List<OutcomeMeasure> outcomeMeasures, Patient patient) async {
    List<String> result = [];

    for (var i = 0; i < outcomeMeasures.length; i++) {
      String eachOutcomeMeasureId = await addOutcomeMeasure(
          http.Client(), i, outcomeMeasures[i], patient);
      result.add(eachOutcomeMeasureId);
    }

    return result;
  }

  // Add an outcome measure
  Future<String> addOutcomeMeasure(http.Client client, int index,
      OutcomeMeasure outcomeMeasure, Patient patient,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;
    Map<String, dynamic> responseJson;

    String requestBody =
        jsonEncode(outcomeMeasure.toJson(ownerOrganizationId, patient, index));

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));
      responseJson = _returnResponse(response);

      _logger.d('successfully added outcome measure');

      outcomeMeasure.entityId = responseJson['_id'];
      return responseJson['_id'];
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            addOutcomeMeasure(http.Client(), index, outcomeMeasure, patient,
                isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete an encounter
  Future<void> deleteEncounter(http.Client client, Encounter encounter,
      {bool isRetry = false}) async {
    _logger.d('');

      String url = _endpoint + _deleteGenericEntityApi + encounter.entityId!;
      List<Device> devices;

      //requires authorization
      Map<String, String> header = {
        'Accept': '*/*',
      };

      http.Request request = http.Request('delete', Uri.parse(url));
      request.headers.addAll(header);
      request.headers.addAll(requestHeadersAuthorization);

      try {
        // Delete devices.
        devices = await getDevices(http.Client(), encounter: encounter);
        await deleteDevices(client, devices);

        final response =
            await http.Response.fromStream(await client.send(request));

        _returnResponse(response);

        _logger.d('successfully deleted encounter');

        // Delete all outcome measures
        deleteOutcomeMeasures(encounter.outcomeMeasures!);
        deleteDomainScores(client, domainScoresId: encounter.domainScoresId!);

        return;
      } on ExpiredTokenException {
        if (isRetry) {
          rethrow;
        } else {
          _logger.d('retry');

          await refreshTokens(http.Client(), _refreshToken);
          return Future.delayed(const Duration(seconds: 2)).then((value) =>
              deleteEncounter(http.Client(), encounter, isRetry: true));
        }
      } catch (e) {
        rethrow;
      }
  }

  // Delete a list of outcome measures
  Future<void> deleteOutcomeMeasures(
      List<OutcomeMeasure> outcomeMeasures) async {
    await Future.forEach(outcomeMeasures,
        (OutcomeMeasure outcomeMeasure) async {
      await deleteOutcomeMeasure(http.Client(), outcomeMeasure.entityId!);
    });
  }

  // Delete each outcome measure
  Future<void> deleteOutcomeMeasure(http.Client client, String entityId,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _deleteGenericEntityApi + entityId;

    //requires authorization
    Map<String, String> header = {
      'Accept': '*/*',
    };

    http.Request request = http.Request('delete', Uri.parse(url));
    request.headers.addAll(header);
    request.headers.addAll(requestHeadersAuthorization);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));

      _returnResponse(response);

      _logger.d('successfully deleted outcome measure');
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            deleteOutcomeMeasure(http.Client(), entityId, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCaregiverById(http.Client client,
      {bool isRetry = false}) async {
    _logger.d('');

    const String getCaregiverApi = '/organization/v1/users/caregivers/';
    String url = _endpoint + getCaregiverApi + caregiverId!;
    Map<String, dynamic> responseJson;

    //requires authorization
    Map<String, String> header = {};
    header.addAll(requestHeaders);
    header.addAll(requestHeadersAuthorization);

    try {
      final response = await client.get(Uri.parse(url), headers: header);

      responseJson = _returnResponse(response);

      _logger.d('successfully retrieved caregiver by id');

      caregiverName = responseJson['_name']['firstName'] +
          ' ' +
          responseJson['_name']['lastName'];

      return;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2))
            .then((value) => getCaregiverById(http.Client(), isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> getOrganizationCodeById(http.Client client,
  //     {bool isRetry = false}) async {
  //   _logger.d('');
  //
  //   const String getCaregiverApi = '/organization/v1/organizations/';
  //   String url = _endpoint + getCaregiverApi + ownerOrganizationId;
  //   Map<String, dynamic> responseJson;
  //
  //   //requires authorization
  //   Map<String, String> header = {};
  //   header.addAll(requestHeaders);
  //   header.addAll(requestHeadersAuthorization);
  //
  //   try {
  //     final response = await client.get(Uri.parse(url), headers: header);
  //
  //     responseJson = _returnResponse(response);
  //
  //     _logger.d('successfully get org code by id');
  //     ownerOrganizationCode = responseJson['code'];
  //
  //     return;
  //   } on ExpiredTokenException {
  //     if (isRetry) {
  //       rethrow;
  //     } else {
  //       _logger.d('retry');
  //
  //       await refreshTokens(http.Client(), _refreshToken);
  //       return Future.delayed(const Duration(seconds: 2))
  //           .then((value) => getCaregiverById(http.Client(), isRetry: true));
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> sendSms(http.Client client, String message, String phoneNumber,
      {bool isRetry = false}) async {
    _logger.d('');

    String url = _endpoint + _getGenericEntitiesApi;

    String requestBody = jsonEncode(
        <String, String>{"message": message, "phoneNumber": phoneNumber});

    http.Request request = http.Request('post', Uri.parse(url));
    request.body = requestBody;
    request.headers.addAll(requestHeaders);
    request.headers.addAll(requestHeadersAuthorization);
    //TODO: Jiyun - This might require 'Notification send sms' permission.

    try {
      final response =
          await http.Response.fromStream(await client.send(request));
      _returnResponse(response);

      _logger.d('successfully sent SMS.');

      return;
    } on ExpiredTokenException {
      if (isRetry) {
        rethrow;
      } else {
        _logger.d('retry');

        await refreshTokens(http.Client(), _refreshToken);
        return Future.delayed(const Duration(seconds: 2)).then((value) =>
            sendSms(http.Client(), message, phoneNumber, isRetry: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _returnResponse(http.Response response) {
    //TODO: Jiyun - convert response.request into CRC-16 instead of httpRequestCode
    int httpRequestCode = -1;

    switch (response.statusCode) {
      case >= 200 && < 300:
        if (response.body.isNotEmpty) {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        } else {
          return {};
        }
      case 401:
        if (httpRequestCode != 89) {
          // any calls after logged in
          throw ExpiredTokenException(response);
        } else {
          // TODO: Jiyun - loginWithCredential (89)
          throw BadRequestException(response);
        }
      case 403:
        throw UnauthorisedException(response);
      case 409:
        throw AlreadyExistException(response);
      case >= 400 && < 500:
        throw BadRequestException(response);
      case >= 500:
        throw ServerErrorException(response);
      default:
        throw FetchDataException(response);
    }
  }
}

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  String get message => _message == null ? '' : _message!;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  http.Response response;

  FetchDataException(this.response)
      : super(response.body.toString(),
            "${response.statusCode}-Error During Communication: ");
}

class BadRequestException extends AppException {
  http.Response response;

  BadRequestException(this.response)
      : super(response.body.toString(),
            "${response.statusCode}-Invalid Request: ");
}

class ExpiredTokenException extends AppException {
  http.Response response;

  ExpiredTokenException(this.response)
      : super(
            response.body.toString(), "${response.statusCode}-Expired Token: ");
}

class UnauthorisedException extends AppException {
  http.Response response;

  UnauthorisedException(this.response)
      : super(
            response.body.toString(), "${response.statusCode}-Unauthorised: ");
}

class AlreadyExistException extends AppException {
  http.Response response;

  AlreadyExistException(this.response)
      : super(
            response.body.toString(), "${response.statusCode}-Already Exist: ");
}

class InvalidInputException extends AppException {
  http.Response response;

  InvalidInputException(this.response)
      : super(
            response.body.toString(), "${response.statusCode}-Invalid Input: ");
}

class ServerErrorException extends AppException {
  http.Response response;

  ServerErrorException(this.response)
      : super(
            response.body.toString(), "${response.statusCode}-Server Error: ");
}
