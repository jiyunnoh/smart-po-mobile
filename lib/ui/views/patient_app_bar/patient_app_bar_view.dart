import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_strings.dart';
import '../../../model/patient.dart';
import '../../common/ui_helpers.dart';
import '../add_patient_dialog/add_patient_dialog_view.dart';
import 'patient_app_bar_viewmodel.dart';

class PatientAppBarView extends StackedView<PatientAppBarViewModel>
    implements PreferredSizeWidget {
  final Function? onCallBack;
  final Patient? patient;

  const PatientAppBarView(this.patient, {super.key, this.onCallBack});

  @override
  Widget builder(
    BuildContext context,
    PatientAppBarViewModel viewModel,
    Widget? child,
  ) {
    return AppBar(
      centerTitle: false,
      leadingWidth: 50,
      backgroundColor: Colors.black,
      titleSpacing: 0.0,
      title: patient != null
          ? Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (onCallBack != null) {
                      onCallBack!();
                    }

                    viewModel.showBusyDialog();
                    await patient!.populate();
                    viewModel.closeBusyDialog();

                    (Device.get().isTablet)
                        ? showDialog(
                            context: context,
                            builder: (context) => AddPatientDialog(
                                  isEdit: true,
                                  patient: patient,
                                ))
                        : viewModel.navigateToAddPatientView(
                            isEdit: true, patient: patient);
                  },
                  icon: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        child: Text(patient!.initial)),
                  ),
                ),
                horizontalSpaceTiny,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient!.fullName),
                    TextButton(
                      onPressed: () {
                        if (onCallBack != null) {
                          onCallBack!();
                        }
                        viewModel.navigateToEncounterView(
                            patient!, ValueNotifier(patient!.encounters!));
                      },
                      style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(50, 20),
                          padding: EdgeInsets.zero),
                      child: Text(
                          (patient!.encounters != null &&
                                  patient!.encounters!.isNotEmpty)
                              ? 'Last Encounter: ${DateFormat('M/dd/yy').format(patient!.encounters![0].encounterCreatedTime!)} >'
                              : noEncounterText,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            onPressed: () {
              if (onCallBack != null) {
                onCallBack!();
              }
              viewModel.navigateToHomeTab();
            },
            style: OutlinedButton.styleFrom(
                minimumSize: Size.zero, // Set this
                padding: const EdgeInsets.all(8.0),
                foregroundColor: Colors.white,
                side: const BorderSide(width: 2.0, color: Colors.white)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add),
                Device.get().isTablet
                    ? const Text('Encounter')
                    : const Icon(Icons.description_outlined)
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  PatientAppBarViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientAppBarViewModel();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
