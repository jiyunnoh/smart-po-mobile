import 'package:biot/constants/current_sex.dart';
import 'package:biot/constants/enum.dart';
import 'package:biot/constants/ethnicity.dart';
import 'package:biot/ui/views/patient_form/patient_form_viewmodel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../constants/race.dart';
import '../../../constants/sex_at_birth.dart';
import '../../../model/chart_data.dart';
import '../../../model/patient.dart';
import '../../common/ui_helpers.dart';

class PatientFormView extends StackedView<PatientFormViewModel> {
  final bool isEdit;
  final Patient? patient;

  PatientFormView({super.key, this.isEdit = false, this.patient});

  Row _buildButtons(PatientFormViewModel viewModel, BuildContext context) {
    if (viewModel.currentPage > 0 && viewModel.currentPage < pages.length - 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                viewModel.resetFormValidation();
                viewModel.onTabEditDevices(alwaysClose: true);
                viewModel.controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: const Text(
                'Previous',
                style: navigatorButtonStyle,
              )),
          TextButton(
              onPressed: () {
                viewModel.capitalizeInitial(viewModel.firstNameController);
                viewModel.capitalizeInitial(viewModel.lastNameController);
                viewModel.onTabEditDevices(alwaysClose: true);
                viewModel.onSubmitDiagnosesForm();
                final isValid =
                    viewModel.conditionsFormKey.currentState?.validate();
                if (isValid! && viewModel.isDiagnosesFormSubmitted) {
                  viewModel.controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
              },
              child: const Text(
                'Next',
                style: navigatorButtonStyle,
              )),
        ],
      );
    } else if (viewModel.currentPage == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                final isValid = viewModel.infoFormKey.currentState?.validate();
                if (isValid!) {
                  viewModel.controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
              },
              child: const Text(
                'Next',
                style: navigatorButtonStyle,
              )),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () => viewModel.controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut),
              child: const Text(
                'Previous',
                style: navigatorButtonStyle,
              )),
          TextButton(
              onPressed: (viewModel.shouldEnable())
                  ? () {
                      Navigator.of(context).pop();
                      viewModel.showBusyDialog();
                      viewModel.isEdit
                          ? viewModel.onEditPatient()
                          : viewModel.onAddPatient();
                      viewModel.closeBusyDialog();
                    }
                  : null,
              child: Text(
                (viewModel.isEdit) ? 'Save' : 'Add',
                style: navigatorButtonStyle,
              )),
        ],
      );
    }
  }

  final List<Widget> pages = [
    const _BuildPatientInfoForm(),
    const _BuildDevicesForm(),
    const _BuildDomainPrioritization()
  ];

  @override
  Widget builder(
    BuildContext context,
    PatientFormViewModel viewModel,
    Widget? child,
  ) {
    return GestureDetector(
      onTap: () {
        viewModel.onTabEditDevices(alwaysClose: true);
      },
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: viewModel.controller,
              onPageChanged: (index) => viewModel.updatePage(index),
              children: pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: _buildButtons(viewModel, context),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(PatientFormViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize();
  }

  @override
  PatientFormViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientFormViewModel(isEdit: isEdit, patient: patient);
}

class _BuildPatientInfoForm extends ViewModelWidget<PatientFormViewModel> {
  const _BuildPatientInfoForm();

  @override
  Widget build(BuildContext context, PatientFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Patient Info', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            verticalSpaceSmall,
            Form(
              key: viewModel.infoFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPatientId(viewModel),
                    verticalSpaceSmall,
                    _buildFirstName(viewModel),
                    verticalSpaceSmall,
                    _buildLastName(viewModel),
                    verticalSpaceSmall,
                    _buildEmail(viewModel),
                    verticalSpaceSmall,
                    _buildDob(viewModel, context),
                    verticalSpaceSmall,
                    _buildSexAtBirth(viewModel),
                    verticalSpaceSmall,
                    _buildCurrentSex(viewModel),
                    verticalSpaceSmall,
                    _buildRace(viewModel),
                    verticalSpaceSmall,
                    _buildEthnicity(viewModel)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildDob(PatientFormViewModel viewModel, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: const Key('dob'),
            readOnly: true,
            controller: viewModel.dobController,
            validator: (value) => value != null && value.isEmpty
                ? 'Date of Birth is required'
                : null,
            onTap: () async {
              DateTime now = DateTime.now();
              viewModel.dobPickedDate = await showDatePicker(
                  context: context,
                  keyboardType: TextInputType.text,
                  initialDate: viewModel.dobPickedDate == null
                      ? now
                      : viewModel.dobPickedDate!,
                  firstDate: DateTime(DateTime.now().year - 120),
                  lastDate: now,
                  builder: (context, child) {
                    return Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                onSurface: Colors.black),
                            textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black))),
                        child: child!);
                  });
              if (viewModel.dobPickedDate != null) {
                viewModel.onChangeDob();
              }
              if (viewModel.isEdit &&
                  viewModel.dobPickedDate != viewModel.patient!.dob) {
                viewModel.isDobModified = true;
                viewModel.notifyListeners();
              }
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                filled: true,
                hintText: 'Date of Birth',
                labelText:
                    viewModel.dobPickedDate != null ? 'Date of Birth' : null),
            keyboardType: TextInputType.text,
          ),
        ),
        IconButton(
            onPressed: () async {
              DateTime now = DateTime.now();
              viewModel.dobPickedDate = await showDatePicker(
                  context: context,
                  keyboardType: TextInputType.text,
                  initialDate: viewModel.dobPickedDate == null
                      ? now
                      : viewModel.dobPickedDate!,
                  firstDate: DateTime(DateTime.now().year - 120),
                  lastDate: now,
                  builder: (context, child) {
                    return Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                onSurface: Colors.black),
                            textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black))),
                        child: child!);
                  });
              if (viewModel.dobPickedDate != null) {
                viewModel.onChangeDob();
              }
              if (viewModel.isEdit &&
                  viewModel.dobPickedDate != viewModel.patient!.dob) {
                viewModel.isDobModified = true;
                viewModel.notifyListeners();
              }
            },
            icon: const Icon(Icons.date_range_rounded))
      ],
    );
  }

  TextFormField _buildPatientId(PatientFormViewModel viewModel) {
    return TextFormField(
      key: const Key('patientId'),
      controller: viewModel.patientIdController,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isPatientIdModified = value != viewModel.patient!.entityId;
          viewModel.notifyListeners();
        }
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autocorrect: false,
      enableSuggestions: false,
      validator: (value) =>
          value != null && value.isEmpty ? 'Patient ID is required' : null,
      smartQuotesType: SmartQuotesType.disabled,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"[^\w\-.']+")),
        LengthLimitingTextInputFormatter(20)
      ],
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          hintText: 'Patient ID',
          labelText: viewModel.patientIdController.text.isNotEmpty
              ? 'Patient ID'
              : null),
      keyboardType: TextInputType.text,
    );
  }

  TextFormField _buildFirstName(PatientFormViewModel viewModel) {
    return TextFormField(
      key: const Key('firstName'),
      controller: viewModel.firstNameController,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isFirstNameModified = value != viewModel.patient!.firstName;
          viewModel.notifyListeners();
        }
      },
      onEditingComplete: () {
        viewModel.capitalizeInitial(viewModel.firstNameController);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapOutside: (event) {
        viewModel.capitalizeInitial(viewModel.firstNameController);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autocorrect: false,
      enableSuggestions: false,
      validator: (value) =>
          value != null && value.isEmpty ? 'First name is required' : null,
      textCapitalization: TextCapitalization.words,
      smartQuotesType: SmartQuotesType.disabled,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"[^a-zA-Z\-. ']")),
        LengthLimitingTextInputFormatter(30)
      ],
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          hintText: 'First Name',
          labelText: viewModel.firstNameController.value.text.isNotEmpty
              ? 'First Name'
              : null),
      keyboardType: TextInputType.text,
    );
  }

  TextFormField _buildLastName(PatientFormViewModel viewModel) {
    return TextFormField(
      key: const Key('lastName'),
      controller: viewModel.lastNameController,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isLastNameModified = value != viewModel.patient!.lastName;
          viewModel.notifyListeners();
        }
      },
      onEditingComplete: () {
        viewModel.capitalizeInitial(viewModel.lastNameController);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapOutside: (event) {
        viewModel.capitalizeInitial(viewModel.lastNameController);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autocorrect: false,
      enableSuggestions: false,
      validator: (value) =>
          value != null && value.isEmpty ? 'Last name is required' : null,
      textCapitalization: TextCapitalization.words,
      smartQuotesType: SmartQuotesType.disabled,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"[^a-zA-Z\-. ']")),
        LengthLimitingTextInputFormatter(30)
      ],
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          hintText: 'Last Name',
          labelText: viewModel.lastNameController.value.text.isNotEmpty
              ? 'Last Name'
              : null),
      keyboardType: TextInputType.text,
    );
  }

  TextFormField _buildEmail(PatientFormViewModel viewModel) {
    return TextFormField(
      key: const Key('email'),
      enabled: (viewModel.isEdit) ? false : true,
      controller: viewModel.emailController,
      validator: (value) =>
          EmailValidator.validate(value!) ? null : 'Please enter a valid email',
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: (viewModel.isEdit) ? const TextStyle(color: Colors.grey) : null,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@+._-]"))
      ],
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        filled: true,
        hintText: 'Email',
        labelText:
            viewModel.emailController.value.text.isNotEmpty ? 'Email' : null,
      ),
      keyboardType: TextInputType.text,
    );
  }

  DropdownButtonFormField<SexAtBirth> _buildSexAtBirth(
      PatientFormViewModel viewModel) {
    return DropdownButtonFormField(
      hint: const Text('Sex at birth - Not Selected'),
      disabledHint: null,
      value: viewModel.selectedSexAtBirth,
      items: viewModel.sexAtBirthOptions,
      validator: (value) => value == null ? 'Sex at birth is required' : null,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isSexAtBirthModified =
              value?.index != viewModel.patient!.sexAtBirthIndex;
        }
        viewModel.onChangeSexAtBirth(value);
      },
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          labelText:
              viewModel.selectedSexAtBirth != null ? 'Sex at birth' : null),
    );
  }

  DropdownButtonFormField<CurrentSex> _buildCurrentSex(
      PatientFormViewModel viewModel) {
    return DropdownButtonFormField(
      hint: const Text('Current sex - Not Selected'),
      disabledHint: null,
      value: viewModel.selectedCurrentSex,
      items: viewModel.currentSexOptions,
      validator: (value) => value == null ? 'Current sex is required' : null,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isCurrentSexModified =
              value?.index != viewModel.patient!.currentSexIndex;
        }
        viewModel.onChangeCurrentSex(value);
      },
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          labelText:
              viewModel.selectedCurrentSex != null ? 'Current sex' : null),
    );
  }

  DropdownButtonFormField<Race> _buildRace(PatientFormViewModel viewModel) {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: const Text('Race - Not Selected'),
      disabledHint: null,
      value: viewModel.selectedRace,
      items: viewModel.raceOptions,
      validator: (value) => value == null ? 'Race is required' : null,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isRaceModified =
              value?.index != viewModel.patient!.raceIndex;
        }
        viewModel.onChangeRace(value);
      },
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          labelText: viewModel.selectedRace != null ? 'Race' : null),
    );
  }

  DropdownButtonFormField<Ethnicity> _buildEthnicity(
      PatientFormViewModel viewModel) {
    return DropdownButtonFormField(
      hint: const Text('Ethnicity - Not Selected'),
      disabledHint: null,
      value: viewModel.selectedEthnicity,
      items: viewModel.ethnicityOptions,
      validator: (value) => value == null ? 'Ethnicity is required' : null,
      onChanged: (value) {
        if (viewModel.isEdit) {
          viewModel.isEthnicityModified =
              value?.index != viewModel.patient!.ethnicityIndex;
        }
        viewModel.onChangeEthnicity(value);
      },
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          filled: true,
          labelText: viewModel.selectedEthnicity != null ? 'Ethnicity' : null),
    );
  }
}

class _BuildDevicesForm extends ViewModelWidget<PatientFormViewModel> {
  const _BuildDevicesForm();

  @override
  Widget build(BuildContext context, PatientFormViewModel viewModel) {
    final isValid = viewModel.conditionsFormKey.currentState?.validate();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Conditions',
                        style: TextStyle(fontSize: 18),
                      ),
                      if (isValid != null &&
                          !isValid &&
                          viewModel.isDiagnosesFormSubmitted)
                        const Text(
                          'Conditions are required',
                          style: TextStyle(color: Colors.red),
                        )
                    ],
                  ),
                ),
                Form(
                  key: viewModel.conditionsFormKey,
                  child: FormField<bool>(
                    builder: (FormFieldState<bool> state) {
                      return Wrap(
                        spacing: 20.0,
                        children: List<Widget>.generate(
                          viewModel.conditionsCheckboxes.length,
                          (int i) {
                            return ChoiceChip(
                              label: Text(
                                viewModel.conditionsCheckboxLabels[i],
                                style: TextStyle(
                                    color: viewModel.conditionsCheckboxes[i]
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              selected: viewModel.conditionsCheckboxes[i],
                              onSelected: (bool selected) {
                                viewModel.resetFormValidation();
                                viewModel.updateCheckbox(i);
                              },
                              selectedColor: Colors.black.withOpacity(1),
                            );
                          },
                        ).toList(),
                      );
                    },
                    validator: (value) {
                      if (!viewModel.conditionsCheckboxes.contains(true)) {
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
              height: 30,
            ),
            if (viewModel.conditionsCheckboxes[1])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'K-Level',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleButtons(
                      isSelected: viewModel.selectedKLevel,
                      onPressed: (int index) =>
                          viewModel.updateKLevelToggleButton(index),
                      borderColor: Colors.black38,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Colors.black,
                      color: Colors.black,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 78.0,
                      ),
                      children: viewModel.kLevelOptions,
                    ),
                  )
                ],
              ),
            if (viewModel.conditionsCheckboxes[1])
              const Divider(
                thickness: 2,
                height: 30,
              ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Devices',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              _buildAddDeviceDialog(context, viewModel);
                            },
                            icon: const Icon(Icons.add_circle_outline))
                      ],
                    ),
                    if (viewModel.deviceList.isNotEmpty)
                      IconButton(
                          onPressed: viewModel.onTabEditDevices,
                          icon: const Icon(Icons.more_vert)),
                  ],
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: viewModel.deviceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black26),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.deviceList[index].deviceName,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      if (viewModel.deviceList[index].lCode !=
                                          '')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            viewModel.deviceList[index].lCode
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        )
                                    ],
                                  ),
                                  Text(
                                    (viewModel.deviceList[index].amputeeSide ==
                                            AmputeeSide.both)
                                        ? 'Left | Right'
                                        : (viewModel.deviceList[index]
                                                    .amputeeSide ==
                                                AmputeeSide.left)
                                            ? 'Left'
                                            : 'Right',
                                    style: const TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (viewModel.isDeviceEdit)
                          Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _buildAddDeviceDialog(context, viewModel,
                                        isEdit: true, index: index);
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  )),
                              TextButton(
                                  onPressed: () =>
                                      viewModel.showConfirmDeleteDialog(index),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildAddDeviceDialog(
          BuildContext context, PatientFormViewModel viewModel,
          {bool isEdit = false, int index = -1}) =>
      showDialog(
          context: context,
          builder: (context) => AddDeviceDialog(
              viewModel: viewModel, isEdit: isEdit, index: index));
}

class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog(
      {super.key,
      required this.viewModel,
      this.isEdit = false,
      this.index = -1});

  final PatientFormViewModel viewModel;
  final bool isEdit;
  final int index;

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  @override
  void dispose() {
    widget.viewModel.selectedDeviceSide = [false, false];
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      widget.viewModel.deviceNameController.text =
          widget.viewModel.deviceList[widget.index].deviceName;
      widget.viewModel.lCodeController.text =
          widget.viewModel.deviceList[widget.index].lCode!;

      if (widget.viewModel.deviceList[widget.index].amputeeSide ==
          AmputeeSide.both) {
        widget.viewModel.selectedDeviceSide = [true, true];
      } else if (widget.viewModel.deviceList[widget.index].amputeeSide ==
          AmputeeSide.left) {
        widget.viewModel.selectedDeviceSide[0] = true;
      } else {
        widget.viewModel.selectedDeviceSide[1] = true;
      }
      widget.viewModel.deviceList[widget.index].isEdited = false;
    } else {
      widget.viewModel.deviceNameController.text = '';
      widget.viewModel.lCodeController.text = '';
      widget.viewModel.selectedDeviceSide = [false, false];
    }

    widget.viewModel.isNewDeviceFormSubmitted = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text((widget.isEdit) ? 'Edit device' : 'Add new device'),
      content: Form(
        key: widget.viewModel.addDeviceFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const Key('deviceName'),
              controller: widget.viewModel.deviceNameController,
              onChanged: (value) {},
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              autocorrect: false,
              enableSuggestions: false,
              validator: (value) => value != null && value.isEmpty
                  ? 'Device Name is required'
                  : null,
              smartQuotesType: SmartQuotesType.disabled,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"[^\w\-.' ]+")),
                LengthLimitingTextInputFormatter(20)
              ],
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                filled: true,
                hintText: 'Device Name',
              ),
              keyboardType: TextInputType.text,
            ),
            verticalSpaceSmall,
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  widget.viewModel.selectedDeviceSide[index] =
                      !widget.viewModel.selectedDeviceSide[index];
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderColor: (widget.viewModel.isNewDeviceFormSubmitted &&
                      widget.viewModel.selectedDeviceSide
                          .every((element) => element == false))
                  ? Colors.red
                  : Colors.black38,
              selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              fillColor: Colors.black,
              color: Colors.black,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 120.0,
              ),
              isSelected: widget.viewModel.selectedDeviceSide,
              children: widget.viewModel.deviceSide,
            ),
            if (widget.viewModel.isNewDeviceFormSubmitted &&
                widget.viewModel.selectedDeviceSide
                    .every((element) => element == false))
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: Text(
                  'Side is required',
                  style: TextStyle(color: Color(0xFFD43333), fontSize: 12),
                ),
              ),
            verticalSpaceSmall,
            TextFormField(
              key: const Key('L-code'),
              controller: widget.viewModel.lCodeController,
              onChanged: (value) {},
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              autocorrect: false,
              enableSuggestions: false,
              smartQuotesType: SmartQuotesType.disabled,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"[^\w\-.', ]+")),
                LengthLimitingTextInputFormatter(20)
              ],
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                filled: true,
                hintText: 'LXXXX, LYYYY, LZZZZ',
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.viewModel.isNewDeviceFormSubmitted = true;
            });
            final bool isValid =
                (widget.viewModel.addDeviceFormKey.currentState?.validate())! &&
                    widget.viewModel.validateToggleButtons();
            if (isValid) {
              if (widget.isEdit) {
                widget.viewModel.onEditSingleDevice(widget.index);
              } else {
                widget.viewModel.onAddNewDevice();
              }

              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: Text((widget.isEdit) ? 'Edit' : 'Add'),
        )
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
    );
  }
}

class _BuildDomainPrioritization extends ViewModelWidget<PatientFormViewModel> {
  const _BuildDomainPrioritization();

  @override
  Widget build(BuildContext context, PatientFormViewModel viewModel) {
    return viewModel.isBusy
        ? Container()
        : Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Priority of Domains',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(
                      height: 40,
                      child: ToggleButtons(
                        isSelected: viewModel.selectedToggles,
                        onPressed: (int index) =>
                            viewModel.onTapToggleButton(index),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.white,
                        fillColor: Colors.black87,
                        color: Colors.black,
                        constraints: const BoxConstraints(
                          minHeight: 30.0,
                          minWidth: 50.0,
                        ),
                        children: viewModel.sliderTypes,
                      ),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfCircularChart(
                            tooltipBehavior: viewModel.tooltipBehavior,
                            legend: Legend(
                              isVisible: Device.get().isTablet ? true : false,
                              position: (Device.get().isTablet)
                                  ? LegendPosition.right
                                  : LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                            series: <CircularSeries>[
                              // Render pie chart
                              PieSeries<SliderChartData, String>(
                                radius: '110%',
                                animationDuration: 0,
                                dataSource: viewModel.chartData,
                                xValueMapper: (SliderChartData data, _) =>
                                    data.domainName,
                                yValueMapper: (SliderChartData data, _) =>
                                    data.normalizedValue.round(),
                                pointColorMapper: (SliderChartData data, _) =>
                                    data.color,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    textStyle: TextStyle(fontSize: 20)),
                              )
                            ]),
                      ),
                    )),
                const Divider(
                  thickness: 2,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: (viewModel.isSimpleSlider &&
                                                viewModel
                                                    .isSimpleSliderSorted ||
                                            !viewModel.isSimpleSlider &&
                                                viewModel
                                                    .isAdvancedSliderSorted)
                                        ? null
                                        : viewModel.onTapSort,
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(120, 36)),
                                        backgroundColor:
                                            MaterialStatePropertyAll((viewModel
                                                            .isSimpleSlider &&
                                                        viewModel
                                                            .isSimpleSliderSorted ||
                                                    !viewModel.isSimpleSlider &&
                                                        viewModel
                                                            .isAdvancedSliderSorted)
                                                ? Colors.black12
                                                : Colors.black)),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.sort),
                                        horizontalSpaceTiny,
                                        Text(
                                          'Sort',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )),
                                horizontalSpaceMedium,
                                ElevatedButton(
                                    onPressed: viewModel.onTapDefault,
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(120, 36)),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Colors.black)),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.settings_backup_restore),
                                        horizontalSpaceTiny,
                                        Text(
                                          'Default',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            verticalSpaceTiny,
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (viewModel.selectedToggles[0])
                                              ? 'Low'
                                              : '0',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          (viewModel.selectedToggles[0])
                                              ? 'High'
                                              : '100',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: viewModel.chartData.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Row(
                                      children: [
                                        IconButton(
                                            onPressed: () => print('info'),
                                            icon: const Icon(
                                              Icons.info_outline,
                                              color: Colors.black45,
                                            ),
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            constraints: const BoxConstraints(),
                                            iconSize: 20),
                                        SizedBox(
                                            width: 100,
                                            child: Text(
                                              viewModel.chartData[i].domainName,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )),
                                        if (viewModel.selectedToggles[0])
                                          Expanded(
                                            child: SfSliderTheme(
                                              data: SfSliderThemeData(
                                                  activeTrackHeight: 8,
                                                  inactiveTrackHeight: 4,
                                                  activeDividerRadius: 0,
                                                  inactiveDividerRadius: 0,
                                                  activeTrackColor: viewModel
                                                      .chartData[i].color,
                                                  inactiveTrackColor:
                                                      Colors.black26,
                                                  thumbColor: viewModel
                                                      .chartData[i].color),
                                              child: SfSlider(
                                                  min:
                                                      viewModel.simpleSliderMin,
                                                  max:
                                                      viewModel.simpleSliderMax,
                                                  interval: 10,
                                                  stepSize: 1,
                                                  showDividers: true,
                                                  value: viewModel.chartData[i]
                                                      .simpleSliderValue,
                                                  onChanged:
                                                      (dynamic newValue) {
                                                    viewModel
                                                        .updateSimpleSlider(
                                                            newValue, i);
                                                    viewModel
                                                        .updateCircularChart();
                                                  }),
                                            ),
                                          ),
                                        if (!viewModel.selectedToggles[0])
                                          Expanded(
                                              child: SfRangeSliderTheme(
                                            data: SfRangeSliderThemeData(
                                                thumbRadius: 0,
                                                activeTrackHeight: 20,
                                                inactiveTrackHeight: 4),
                                            child: SfRangeSlider(
                                              min: viewModel.advancedSliderMin,
                                              max: viewModel.advancedSliderMax,
                                              values: viewModel.chartData[i]
                                                  .advancedSliderValues,
                                              onChanged:
                                                  (SfRangeValues newValue) {
                                                viewModel.updateRangeSlider(
                                                    newValue.start,
                                                    newValue.end,
                                                    i);
                                                viewModel.updateCircularChart();
                                              },
                                              activeColor:
                                                  viewModel.chartData[i].color,
                                              inactiveColor: Colors.black26,
                                            ),
                                          )),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ))),
              ],
            ),
          );
  }
}
