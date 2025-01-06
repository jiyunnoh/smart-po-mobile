import 'package:biot/ui/views/patient_form/patient_form_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/patient.dart';
import 'add_patient_viewmodel.dart';

class AddPatientView extends StackedView<AddPatientViewModel> {
  final bool isEdit;
  final Patient? patient;

  const AddPatientView({super.key, this.isEdit = false, this.patient});

  @override
  Widget builder(
    BuildContext context,
    AddPatientViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(patient != null ? 'Edit Patient' : 'Add New Patient'),
      ),
      body: PatientFormView(isEdit: isEdit, patient: patient),
    );
  }

  @override
  AddPatientViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddPatientViewModel();
}
