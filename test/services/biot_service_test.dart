import 'dart:convert';

import 'package:biot/model/patient.dart';
import 'package:biot/model/encounter.dart';
import 'package:biot/services/cloud_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biot/app/app.locator.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';
import 'biot_service_test.mocks.dart';

//Generate the MockClient and pass it to bio_service
@GenerateMocks([http.Client])
void main() {
  group('BiotServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    group('loginWithCredentials -', () {
      test('Returns a token if the http POST call completes successfully',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.post(any,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                body: jsonEncode(
                    <String, String>{"username": "id", "password": "pwd"})))
            .thenAnswer((_) async => http.Response(
                json.encode({
                  'accessJwt': {'token': 'any'},
                  'refreshJwt': {'token': 'any'}
                }),
                200));

        expect(service.loginWithCredentials(mockClient, 'id', 'pwd'),
            isA<String>());
      });
      test(
          'Returns a NoInternetException if the response status code is 400 in loginWithCredentials',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.post(any,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                body: jsonEncode(
                    <String, String>{"username": "id", "password": "pwd"})))
            .thenAnswer((_) async => http.Response(
                json.encode({
                  'accessJwt': {'token': 'any'},
                  'refreshJwt': {'token': 'any'}
                }),
                400));
        try {
          await service.loginWithCredentials(mockClient, 'id', 'pwd');
        } catch (e) {
          expect(e, isA<BadRequestException>());
        }
      });
      test(
          'Returns an ExpiredTokenException if the response status code is 401 in loginWithCredentials',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.post(any,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                body: jsonEncode(
                    <String, String>{"username": "id", "password": "pwd"})))
            .thenAnswer((_) async => http.Response(
                json.encode({
                  'accessJwt': {'token': 'any'},
                  'refreshJwt': {'token': 'any'}
                }),
                401));
        try {
          await service.loginWithCredentials(mockClient, 'id', 'pwd');
        } catch (e) {
          expect(e, isA<ExpiredTokenException>());
        }
      });
      test(
          'Returns an UnauthorisedException if the response status code is 403 in loginWithCredentials',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.post(any,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                body: jsonEncode(
                    <String, String>{"username": "id", "password": "pwd"})))
            .thenAnswer((_) async => http.Response(
                json.encode({
                  'accessJwt': {'token': 'any'},
                  'refreshJwt': {'token': 'any'}
                }),
                403));
        try {
          await service.loginWithCredentials(mockClient, 'id', 'pwd');
        } catch (e) {
          expect(e, isA<UnauthorisedException>());
        }
      });
    });

    group('getRefreshToken -', () {
      // test(
      //     'Returns a refresh token if the http POST call completes successfully',
      //     () async {
      //   var service = BiotService();
      //   final mockClient = MockClient();
      //
      //   when(mockClient.post(any,
      //           headers: {
      //             'Content-Type': 'application/json',
      //             'Accept': 'application/json',
      //             'Authorization': 'Bearer ',
      //           },
      //           body: jsonEncode(
      //               <String, String>{"refreshToken": "refreshToken"})))
      //       .thenAnswer((_) async => http.Response(
      //           json.encode({
      //             'accessJwt': {'token': 'any'},
      //             'refreshJwt': {'token': 'any'}
      //           }),
      //           200));
      //
      //   expect(
      //       service.getRefreshToken(mockClient, 'refreshToken'), isA<String>());
      // });

      // test(
      //     'Returns a NoInternetException if the response status code is 400 in refreshToken',
      //     () async {
      //   var service = BiotService();
      //   final mockClient = MockClient();
      //
      //   when(mockClient.post(any,
      //           headers: {
      //             'Content-Type': 'application/json',
      //             'Accept': 'application/json',
      //             'Authorization': 'Bearer ',
      //           },
      //           body: jsonEncode(
      //               <String, String>{"refreshToken": "refreshToken"})))
      //       .thenAnswer((_) async => http.Response(
      //           json.encode({
      //             'accessJwt': {'token': 'any'},
      //             'refreshJwt': {'token': 'any'}
      //           }),
      //           400));
      //   try {
      //     await service.getRefreshToken(mockClient, 'refreshToken');
      //   } catch (e) {
      //     expect(e, isA<NoInternetException>());
      //   }
      // });

      // test(
      //     'Returns an ExpiredTokenException if the response status code is 401 in refreshToken',
      //     () async {
      //   var service = BiotService();
      //   final mockClient = MockClient();
      //
      //   when(mockClient.post(any,
      //           headers: {
      //             'Content-Type': 'application/json',
      //             'Accept': 'application/json',
      //             'Authorization': 'Bearer ',
      //           },
      //           body: jsonEncode(
      //               <String, String>{"refreshToken": "refreshToken"})))
      //       .thenAnswer((_) async => http.Response(
      //           json.encode({
      //             'accessJwt': {'token': 'any'},
      //             'refreshJwt': {'token': 'any'}
      //           }),
      //           401));
      //   try {
      //     await service.getRefreshToken(mockClient, 'refreshToken');
      //   } catch (e) {
      //     expect(e, isA<ExpiredTokenException>());
      //   }
      // });

      // test(
      //     'Returns an UnauthorisedException if the response status code is 403 in refreshToken',
      //     () async {
      //   var service = BiotService();
      //   final mockClient = MockClient();
      //
      //   when(mockClient.post(any,
      //           headers: {
      //             'Content-Type': 'application/json',
      //             'Accept': 'application/json',
      //             'Authorization': 'Bearer ',
      //           },
      //           body: jsonEncode(
      //               <String, String>{"refreshToken": "refreshToken"})))
      //       .thenAnswer((_) async => http.Response(
      //           json.encode({
      //             'accessJwt': {'token': 'any'},
      //             'refreshJwt': {'token': 'any'}
      //           }),
      //           403));
      //   try {
      //     await service.getRefreshToken(mockClient, 'refreshToken');
      //   } catch (e) {
      //     expect(e, isA<UnauthorisedException>());
      //   }
      // });
    });

    group('getPatients', () {
      test(
          'Returns a list of Patient if the http GET call completes successfully',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_name': {'firstName': 'any', 'lastName': 'any'},
                  '_id': 'any',
                  '_email': 'any',
                  '_gender': 'any',
                  '_caregiver': {'id': 'any', 'name': 'any'},
                }
              ]
            }),
            200));

        expect(await service.getPatients(mockClient), isA<List<Patient>>());
      });
      test(
          'Returns a NoInternetException if the response status code is 400 in getPatients',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_name': {'firstName': 'any', 'lastName': 'any'},
                  '_id': 'any',
                  '_email': 'any',
                  '_gender': 'any',
                  '_caregiver': {'id': 'any', 'name': 'any'},
                }
              ]
            }),
            400));
        try {
          await service.getPatients(mockClient);
        } catch (e) {
          expect(e, isA<BadRequestException>());
        }
      });
      test(
          'Returns an ExpiredTokenException if the response status code is 401 in getPatients',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_name': {'firstName': 'any', 'lastName': 'any'},
                  '_id': 'any',
                  '_email': 'any',
                  '_gender': 'any',
                  '_caregiver': {'id': 'any', 'name': 'any'},
                }
              ]
            }),
            401));
        // service.getPatients(mockClient);
        try {
          await service.getPatients(mockClient, isRetry: false);
        } catch (e) {
          // expect(e, isA<Future<dynamic>>());
          expect(e, isA<ExpiredTokenException>());
        }
      });
      test(
          'Returns an UnauthorisedException if the response status code is 403 in getPatients',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_name': {'firstName': 'any', 'lastName': 'any'},
                  '_id': 'any',
                  '_email': 'any',
                  '_gender': 'any',
                  '_caregiver': {'id': 'any', 'name': 'any'},
                }
              ]
            }),
            403));
        try {
          await service.getPatients(mockClient);
        } catch (e) {
          expect(e, isA<UnauthorisedException>());
        }
      });
    });

    group('getSessions', () {
      test(
          'Returns a list of Session if the http GET call completes successfully',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_id': 'any',
                  '_patient': {'name': 'any'},
                  '_device': {'name': 'any'},
                  '_ownerOrganization': {'name': 'any'},
                  '_creationTime': 'any',
                  '_state': 'any',
                }
              ]
            }),
            200));

        expect(await service.getEncounters(mockClient, patient: ''),
            isA<List<Encounter>>());
      });
      test(
          'Returns a NoInternetException if the response status code is 400 in getSessions',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_id': 'any',
                  '_patient': {'name': 'any'},
                  '_device': {'name': 'any'},
                  '_ownerOrganization': {'name': 'any'},
                  '_creationTime': 'any',
                  '_state': 'any',
                }
              ]
            }),
            400));
        try {
          await service.getEncounters(mockClient, patient: '');
        } catch (e) {
          expect(e, isA<BadRequestException>());
        }
      });
      test(
          'Returns an ExpiredTokenException if the response status code is 401 in getSessions',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_id': 'any',
                  '_patient': {'name': 'any'},
                  '_device': {'name': 'any'},
                  '_ownerOrganization': {'name': 'any'},
                  '_creationTime': 'any',
                  '_state': 'any',
                }
              ]
            }),
            401));
        try {
          await service.getEncounters(mockClient, patient: '');
        } catch (e) {
          expect(e, isA<ExpiredTokenException>());
        }
      });
      test(
          'Returns an UnauthorisedException if the response status code is 403 in getSessions',
          () async {
        var service = BiotService();
        final mockClient = MockClient();

        when(mockClient.get(any, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ',
        })).thenAnswer((_) async => http.Response(
            jsonEncode({
              'data': [
                {
                  '_name': {'firstName': 'any', 'lastName': 'any'},
                  '_id': 'any',
                  '_email': 'any',
                  '_gender': 'any',
                  '_caregiver': {'id': 'any', 'name': 'any'},
                }
              ]
            }),
            403));
        try {
          await service.getEncounters(mockClient, patient: '');
        } catch (e) {
          expect(e, isA<UnauthorisedException>());
        }
      });
    });
  });
}
