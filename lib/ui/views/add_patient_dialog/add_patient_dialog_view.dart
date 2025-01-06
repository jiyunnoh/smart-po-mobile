import 'package:biot/ui/views/add_patient_dialog/add_patient_dialog_viewmodel.dart';
import 'package:biot/ui/views/patient_form/patient_form_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/patient.dart';

class AddPatientDialog extends StackedView<AddPatientDialogViewModel> {
  final bool isEdit;
  final Patient? patient;

  const AddPatientDialog({super.key, this.isEdit = false, this.patient});

  @override
  Widget builder(BuildContext context, AddPatientDialogViewModel viewModel,
      Widget? child) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Container(
          color: Colors.black,
          height: 60,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  isEdit ? 'Edit Patient' : 'Add New Patient',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer()
            ],
          )),
      content: SizedBox(
          width: 650,
          height: 800,
          child: PatientFormView(isEdit: isEdit, patient: patient)),
    );
  }

  @override
  AddPatientDialogViewModel viewModelBuilder(BuildContext context) =>
      AddPatientDialogViewModel();
}
