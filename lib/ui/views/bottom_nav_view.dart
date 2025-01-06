import 'package:biot/constants/app_strings.dart';
import 'package:biot/ui/views/home_view_navigator.dart';
import 'package:biot/ui/views/patient_view_navigator.dart';
import 'package:biot/ui/views/settings_view_navigator.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../model/outcome_measures/outcome_measure.dart';
import '../../model/patient.dart';
import '../../services/database_service.dart';
import '../../services/outcome_measure_load_service.dart';
import '../../services/outcome_measure_selection_service.dart';
import '../common/constants.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();
  final _outcomeMeasureSelectionService =
      locator<OutcomeMeasureSelectionService>();
  final _outcomeMeasureLoadService = locator<OutcomeMeasureLoadService>();

  Patient? get currentPatient => _localdbService.currentPatient?.value;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            key: bottomNavKey,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade700,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Patients',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings')
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
                if (_selectedIndex == 0) {
                  _navigationService.popUntil((route) => route.isFirst, id: 0);
                  _localdbService.currentPatient = null;
                  _localdbService.updateCurrentPatient();
                } else if (_selectedIndex == 1) {
                  // Reset selection
                  _outcomeMeasureSelectionService.clear();
                  for (var element in _outcomeMeasureLoadService
                      .defaultOutcomeMeasureCollections) {
                    element.isSelected = false;
                  }
                  for (OutcomeMeasure outcomeMeasure
                  in _outcomeMeasureLoadService
                      .allOutcomeMeasures.outcomeMeasures) {
                    outcomeMeasure.isSelected = false;
                  }

                  Patient? currentPatient =
                      _localdbService.currentPatient?.value;

                  //Retrieve the patient's previous outcome measures set.
                  List<String?>? previousOutcomeMeasuresSet =
                      currentPatient?.outcomeMeasureIds;

                  if (previousOutcomeMeasuresSet != null) {
                    List<OutcomeMeasure> filteredOutcomeMeasures =
                        _outcomeMeasureLoadService
                            .allOutcomeMeasures.outcomeMeasures
                            .where((element) =>
                                previousOutcomeMeasuresSet.contains(element.id))
                            .toList();

                    for (OutcomeMeasure outcomeMeasure
                        in filteredOutcomeMeasures) {
                      if (outcomeMeasure.id != ksProgait) {
                        outcomeMeasure.isSelected = true;
                        _outcomeMeasureSelectionService
                            .addOutcomeMeasure(outcomeMeasure);
                      }
                    }
                  }
                }
              });
            }),
        body: SafeArea(
            top: false,
            child: IndexedStack(index: _selectedIndex, children: const <Widget>[
              PatientViewNavigator(),
              HomeViewNavigator(),
              SettingsViewNavigator()
            ])));
  }
}
