import 'dart:convert';
import 'dart:io';

import 'package:biot/ui/views/patient/patient_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../helpers/test_helpers.dart';
import '../services/biot_service_test.mocks.dart';

void main() {
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });

  group('Patient view- ', () {
    setUp(() => registerServices());
    tearDown(() => unregisterService());

    testWidgets('This view has a title as "Patients"', (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(
        home: PatientView(),
      ));

      final textFinder = find.text('Patients');

      expect(textFinder, findsOneWidget);
    });

    // testWidgets('This view is scrollable until the end', (widgetTester) async {
    //   await widgetTester.pumpWidget(const MaterialApp(home: PatientView(),));
    //   const Key viewKey = Key('listView');
    //   final textFinder = find.text('John Doe');
    //   final viewFinder = find.byKey(viewKey);
    //
    //   await widgetTester.dragUntilVisible(textFinder, viewFinder, const Offset(0.0, -300));
    //
    // });
  });
}
