import 'package:biot/ui/views/outcome_measure_select/outcome_measure_select_view.dart';
import 'package:biot/ui/views/outcome_measure_select/outcome_measure_select_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stacked/stacked.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('Home view-', () {
    setUp(() => registerServices());
    tearDown(() => unregisterService());

    group('title', () {
      testWidgets('Home view has a title as "Welcome!"', (widgetTester) async {
        OutcomeMeasureSelectViewModel viewModel =
            OutcomeMeasureSelectViewModel();

        await widgetTester.pumpWidget(
            ViewModelBuilder<OutcomeMeasureSelectViewModel>.reactive(
          builder: (context, viewModel, child) {
            return MaterialApp(home: (OutcomeMeasureSelectView()));
          },
          viewModelBuilder: () => viewModel,
        ));

        viewModel.notifyListeners();

        const String testValue = 'Welcome!';
        final titleFinder = find.text(testValue);

        expect(titleFinder, findsOneWidget);
      });
    });

    group('textField for id', () {
      testWidgets('Home view has a TextField with "id" key',
          (widgetTester) async {
        await widgetTester
            .pumpWidget(MaterialApp(home: OutcomeMeasureSelectView()));

        const Key textFieldKey = Key('id');
        final textFieldFinder = find.byKey(textFieldKey);

        expect(textFieldFinder, findsOneWidget);
      });

      testWidgets('A textField with "id" key validates user input',
          (widgetTester) async {
        await widgetTester
            .pumpWidget(MaterialApp(home: OutcomeMeasureSelectView()));

        const Key textFieldKey = Key('id');
        final textFieldFinder = find.byKey(textFieldKey);

        await widgetTester.enterText(textFieldFinder, 'any');

        expect(find.widgetWithText(TextField, 'any'), findsOneWidget);
      });
    });

    group('textField for pwd', () {
      testWidgets('Home view has a TextField with "pwd" key',
          (widgetTester) async {
        await widgetTester
            .pumpWidget(MaterialApp(home: OutcomeMeasureSelectView()));

        const Key textFieldKey = Key('pwd');
        final textFieldFinder = find.byKey(textFieldKey);

        expect(textFieldFinder, findsOneWidget);
      });

      testWidgets('A textField with "pwd" key validates user input',
          (widgetTester) async {
        await widgetTester
            .pumpWidget(MaterialApp(home: OutcomeMeasureSelectView()));

        const Key textFieldKey = Key('pwd');
        final textFieldFinder = find.byKey(textFieldKey);

        await widgetTester.enterText(textFieldFinder, 'any');

        expect(find.widgetWithText(TextField, 'any'), findsOneWidget);
      });
    });

    group('login button', () {
      MockNavigationService? mockNavigationService;
      OutcomeMeasureSelectViewModel viewModel;

      setUp(() {
        mockNavigationService = MockNavigationService();
        viewModel = OutcomeMeasureSelectViewModel();
      });

      testWidgets('Home view has a button for login', (widgetTester) async {
        await widgetTester
            .pumpWidget(MaterialApp(home: OutcomeMeasureSelectView()));

        const Key btnKey = Key('loginBtn');
        final btnFinder = find.byKey(btnKey);

        expect(btnFinder, findsOneWidget);
      });

      testWidgets('Login button has a text "Log in"', (widgetTester) async {
        await widgetTester.pumpWidget(MaterialApp(
          home: OutcomeMeasureSelectView(),
        ));

        final textFinder = find.widgetWithText(MaterialButton, 'Log in');

        expect(textFinder, findsOneWidget);
      });

      // testWidgets('When clicked, it navigates to a different view',
      //     (widgetTester) async {
      //   await widgetTester.pumpWidget(const MaterialApp(home: HomeView()));
      //
      //   when(mockNavigationService?.navigateTo(any)).thenAnswer((_) async => true);
      //
      //   const Key btnKey = Key('loginBtn');
      //   final btnFinder = find.byKey(btnKey);
      //
      //   await widgetTester.tap(btnFinder);
      //   await widgetTester.pumpAndSettle();
      //
      //   verify(mockNavigationService?.navigateToStartupView()).called(1);
      // });
    });
  });
}
