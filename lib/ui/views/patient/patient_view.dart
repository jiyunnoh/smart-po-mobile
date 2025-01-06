import 'package:biot/ui/common/ui_helpers.dart';
import 'package:biot/ui/views/add_patient/add_patient_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../model/demo_globals.dart';
import '../../../model/patient.dart';
import 'patient_viewmodel.dart';

class PatientView extends StackedView<PatientViewModel> {
  const PatientView({super.key});

  void _confirmDelete(
      BuildContext context, PatientViewModel viewModel, Patient patient) {
    viewModel.showConfirmDeleteDialog(patient);
  }

  Widget _buildPatientList(BuildContext context, PatientViewModel viewModel,
      List<Patient> patients) {
    return RefreshIndicator(
      onRefresh: viewModel.onPullRefresh,
      child: (patients.isEmpty)
          ? const CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text('There is no patient.'),
                    ],
                  ),
                )
              ],
            )
          : SlidableAutoCloseBehavior(
              child: ListView.separated(
                key: const Key('patientsListView'),
                itemCount: patients.length,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    groupTag: 0,
                    endActionPane: ActionPane(
                      extentRatio: 0.5,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            (Device.get().isTablet)
                                ? showDialog(
                                    context: context,
                                    builder: (context) => AddPatientView(
                                        isEdit: true, patient: patients[index]))
                                : viewModel.navigateToAddPatientView(
                                    isEdit: true, patient: patients[index]);
                          },
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) => {
                            _confirmDelete(context, viewModel, patients[index])
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      leading: const Icon(Icons.person),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            patients[index].id,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                      title: Text(
                        patients[index].fullName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                  'Year of Birth: ${patients[index].dob!.year} • Sex: ${patients[index].sexAtBirth.displayName} • '),
                              Image.asset(
                                'assets/images/icon-stethoscope.png',
                                width: 10,
                              ),
                              horizontalSpaceTiny,
                              Text(patients[index].caregiverName != null
                                  ? patients[index].caregiverName!
                                  : "Not Assigned"),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        viewModel.onPatientTapped(patients[index]);
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 0);
                },
              ),
            ),
    );
  }

  @override
  Widget builder(
    BuildContext context,
    PatientViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('Patients')),
      body: viewModel.dataReady
          ? ValueListenableBuilder<Box<Patient>>(
              valueListenable: viewModel.patientBox.listenable(),
              builder: (context, box, _) {
                // TODO: patients = patients.isSetToDelete == false
                late List<Patient> patients;
                if (isDemo) {
                  patients = viewModel.demoPatients;
                } else {
                  patients = box.values.toList().cast<Patient>();
                }
                patients.sort((a, b) => a.lastName.compareTo(b.lastName));
                return _buildPatientList(context, viewModel, patients);
              },
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        heroTag: "add new patient",
        onPressed: () async {
          (Device.get().isTablet)
              ? showDialog(
                  context: context,
                  builder: (context) => const AddPatientView())
              : viewModel.navigateToAddPatientView();
        },
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }

  @override
  PatientViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientViewModel();
}
