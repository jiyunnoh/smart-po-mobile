import 'dart:math';

import 'package:biot/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import '../../../model/peripheral_device.dart';
import '../../../model/encounter.dart';
import '../../../model/view_arguments.dart';
import 'encounter_viewmodel.dart';

class EncounterView extends StackedView<EncounterViewModel> {
  const EncounterView({super.key});

  final TextStyle header =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  final TextStyle detail = const TextStyle(fontSize: 14);

  void _confirmDelete(
      BuildContext context, EncounterViewModel viewModel, Encounter encounter) {
    viewModel.showConfirmDeleteDialog(encounter);
  }

  Widget _buildEncounterList(BuildContext context, EncounterViewModel viewModel,
      List<Encounter> encounters) {
    List<Encounter> outcomeMeasureEncounters = encounters
        .where((encounter) => encounter.outcomeMeasures != null)
        .toList();
    List<Encounter> peripheralDeviceEncounters = encounters
        .where((encounter) => encounter.peripheralDevices != null)
        .toList();
    List<Encounter> mGainEncounters = peripheralDeviceEncounters
        .where((encounter) => encounter.peripheralDevices!
            .any((element) => element.type == EncounterType.mg))
        .toList();
    List<Encounter> prosatEncounters = peripheralDeviceEncounters
        .where((encounter) => encounter.peripheralDevices!
            .any((element) => element.type == EncounterType.prosat))
        .toList();
    return RefreshIndicator(
        onRefresh: viewModel.onPullRefresh,
        child: (encounters.isEmpty)
            ? const CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                        Text('There are no encounters.'),
                      ],
                    ),
                  )
                ],
              )
            : SlidableAutoCloseBehavior(
                child: Column(
                  children: [
                    // Outcome measure encounters
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              'Outcome Measures',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              key: const Key('encountersListView'),
                              itemCount: outcomeMeasureEncounters.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Slidable(
                                  groupTag: 0,
                                  endActionPane: ActionPane(
                                    extentRatio: 0.25,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) => {
                                          _confirmDelete(context, viewModel,
                                              outcomeMeasureEncounters[index])
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
                                        vertical: 0.0, horizontal: 16.0),
                                    leading:
                                        const Icon(Icons.description_outlined),
                                    //TODO: Jiyun - comment out for demo purpose (Loading Summary view fails.)
                                    // trailing:
                                    //     const Icon(Icons.chevron_right_rounded),
                                    title: Text(
                                      DateFormat.yMd().add_jm().format(
                                          outcomeMeasureEncounters[index]
                                              .encounterCreatedTime!),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    onTap: () {
                                      null;
                                      //TODO: Jiyun - comment out for demo purpose (Loading Summary view fails.)
                                      // viewModel.navigateToSummaryView(
                                      //     outcomeMeasureEncounters[index]);
                                    },
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(height: 0);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (mGainEncounters.isNotEmpty)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'mGain',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Mgain newMgain = Mgain(
                                            id: 'temp',
                                            name: 'mG-52F4',
                                            creationTime: DateTime.now()
                                                .toUtc()
                                                .toIso8601String(),
                                            gain:
                                                Random().nextInt(19000) + 1000,
                                            totalTimePlayed:
                                                Random().nextInt(240) + 180,
                                            gameName: "Rapid Fire",
                                            gameSettings:
                                                "{\"numberOfSets\":5,\"numberOfRepetitionsPerSet\":\"2\",\"holdTime\":\"160\"}",
                                            mgRawDataId: '',
                                            batteryLevelAtStart: double.parse(
                                                (((Random().nextDouble() *
                                                            0.9) +
                                                        3.3)
                                                    .toStringAsFixed(1))),
                                            startTime: DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1))
                                                .toUtc()
                                                .toIso8601String(),
                                            endTime: DateTime.now()
                                                .toUtc()
                                                .toIso8601String(),
                                            patient: viewModel.patient);
                                        viewModel.addUsageEncounter(newMgain);
                                      },
                                      icon: const Icon(
                                          Icons.upload_file_outlined))
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                key: const Key('encountersListView'),
                                itemCount: mGainEncounters.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: false,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Slidable(
                                    groupTag: 0,
                                    endActionPane: ActionPane(
                                      extentRatio: 0.25,
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) => {
                                            _confirmDelete(context, viewModel,
                                                mGainEncounters[index])
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 16.0),
                                      leading: Image.asset(
                                          'assets/images/mgain.png',
                                          width: 25),
                                      trailing: const Icon(
                                          Icons.chevron_right_rounded),
                                      title: Text(mGainEncounters[index].name!),
                                      subtitle: Text(DateFormat.yMd()
                                          .add_jms()
                                          .format(mGainEncounters[index]
                                              .encounterCreatedTime!)),
                                      onTap: () {
                                        viewModel.navigateToSensorSummaryView(
                                            mGainEncounters[index]);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(height: 0);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (prosatEncounters.isNotEmpty)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'ProSAT',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Prosat newProsat = Prosat(
                                            id: 'temp',
                                            name: 'Euro-5CFE',
                                            creationTime: DateTime.now()
                                                .toUtc()
                                                .toIso8601String(),
                                            patient: viewModel.patient,
                                            stepsPerDay:
                                                Random().nextInt(20000),
                                            cadence: Random().nextInt(8) + 72,
                                            sensitivity:
                                                Random().nextInt(4) + 10,
                                            startTime: DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1))
                                                .toUtc()
                                                .toIso8601String(),
                                            endTime: DateTime.now()
                                                .toUtc()
                                                .toIso8601String());

                                        viewModel.addUsageEncounter(newProsat);
                                      },
                                      icon: const Icon(
                                          Icons.upload_file_outlined))
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                key: const Key('encountersListView'),
                                itemCount: prosatEncounters.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: false,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Slidable(
                                    groupTag: 0,
                                    endActionPane: ActionPane(
                                      extentRatio: 0.25,
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) => {
                                            _confirmDelete(context, viewModel,
                                                prosatEncounters[index])
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 16.0),
                                      leading: const Icon(
                                          Icons.description_outlined),
                                      trailing: const Icon(
                                          Icons.chevron_right_rounded),
                                      title:
                                          Text(prosatEncounters[index].name!),
                                      subtitle: Text(DateFormat.yMd()
                                          .add_jms()
                                          .format(prosatEncounters[index]
                                              .encounterCreatedTime!)),
                                      onTap: () {
                                        viewModel.navigateToSensorSummaryView(
                                            prosatEncounters[index]);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(height: 0);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ));
  }

  @override
  Widget builder(
    BuildContext context,
    EncounterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Encounters')),
      body: ValueListenableBuilder<List<Encounter>>(
        valueListenable: viewModel.encounters,
        builder: (context, encounters, _) {
          return _buildEncounterList(context, viewModel, encounters);
        },
      ),
    );
  }

  @override
  EncounterViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final EncounterViewArguments arguments =
        ModalRoute.of(context)!.settings.arguments as EncounterViewArguments;
    return EncounterViewModel(
        patient: arguments.patient, encounters: arguments.encounters);
  }
}
