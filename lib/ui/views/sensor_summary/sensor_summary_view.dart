import 'package:biot/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../model/peripheral_device.dart';
import 'sensor_summary_viewmodel.dart';

class SensorSummaryView extends StackedView<SensorSummaryViewModel> {
  const SensorSummaryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SensorSummaryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Sensor Summary'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25.0),
          child: (viewModel.dataReady)
              ? (viewModel.encounter.type == EncounterType.mg)
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Device Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.type,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Game Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.gameName,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Gain',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.gain.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Time Played',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.totalTimePlayed.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Battery Level At Start',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                  viewModel.data.batteryLevelAtStart.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'mGain Raw Data',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              IconButton(
                                  onPressed: viewModel.downloadFile,
                                  icon: const Icon(
                                      Icons.cloud_download_outlined,
                                      size: 30)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Device Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.type,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Steps Per Day',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.stepsPerDay.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Cadence',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.cadence.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sensitivity',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(viewModel.data.sensitivity.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ProSAT Raw Data',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              IconButton(
                                  onPressed: viewModel.downloadFile,
                                  icon: const Icon(
                                      Icons.cloud_download_outlined,
                                      size: 30)),
                            ],
                          ),
                        ),
                      ],
                    )
              : const Center(child: CircularProgressIndicator())),
    );
  }

  @override
  SensorSummaryViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final PeripheralDevice arguments =
        ModalRoute.of(context)!.settings.arguments as PeripheralDevice;
    return SensorSummaryViewModel(encounter: arguments);
  }
}
