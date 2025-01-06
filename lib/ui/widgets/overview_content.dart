import 'package:async/async.dart';
import 'package:biot/constants/app_strings.dart';
import 'package:biot/ui/views/insights/insights_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../model/demo_globals.dart';
import '../../model/outcome_measures/progait.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';
import 'chart_legend_widget.dart';
import 'circular_chart.dart';
import 'insights_text_summary.dart';

class OverviewContent extends ViewModelWidget<InsightsViewModel> {
  const OverviewContent({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: Device.get().isTablet
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildEncounterSelection(viewModel, context),
                _buildOlderDateToggle(viewModel, context),
              ],
            ),
            viewModel.isComparisonOn
                ? _buildProgressBar(viewModel)
                : _buildShowProgressButton(viewModel),
            Row(
              children: [
                _buildNewerDateToggle(viewModel),
                _buildSoapNoteButton(viewModel)
              ],
            ),
          ],
        ),
        verticalSpaceSmall,
        const InsightsTextSummary(),
        (Device.get().isTablet)
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 6, child: CircularChart()),
                  Expanded(flex: 4, child: ChartLegendWidget())
                ],
              )
            : const Column(
                children: [CircularChart(), ChartLegendWidget()],
              ),
      ],
    );
  }

  Widget _buildSoapNoteButton(InsightsViewModel viewModel) {
    return IconButton(
      onPressed: () {
        viewModel.stopAnimation();
        viewModel.navigateToSoapNoteView();
        viewModel.onPieSectionTapped(-1);
        viewModel.stopAnimation();
      },
      padding: const EdgeInsets.only(left: 10),
      visualDensity: VisualDensity.compact,
      icon: Image.asset(
        'assets/images/insight_icon.png',
      ),
      iconSize: 30,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildShowProgressButton(InsightsViewModel viewModel) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: viewModel.olderEncounter != null
                  ? viewModel.isComparisonOn
                      ? null
                      : viewModel.startAnimation
                  : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Show Progress '), Icon(Icons.play_arrow)],
              )),
        ],
      ),
    );
  }

  ElevatedButton _buildOlderDateToggle(
      InsightsViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.olderEncounter != null
          ? viewModel.showOlderCircularChart
          : null,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: viewModel.isComparisonOn
              ? Colors.white
              : viewModel.isOlderCircularChartOn
                  ? kcOlderEncounterColor
                  : Colors.white,
          side: const BorderSide(color: kcOlderEncounterColor, width: 3)),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          child: SizedBox(
            width: 150,
            height: 60,
            child: viewModel.olderEncounter != null
                ? Row(
                    children: [
                      Text(
                        viewModel.olderEncounter!.unweightedTotalScore!
                            .round()
                            .toString(),
                        style: TextStyle(
                            fontSize: 40,
                            color: viewModel.isComparisonOn
                                ? Colors.black
                                : viewModel.isOlderCircularChartOn
                                    ? Colors.white
                                    : Colors.black),
                      ),
                      horizontalSpaceSmall,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.getTimeDifference(viewModel
                                .olderEncounter!.encounterCreatedTime!),
                            style: TextStyle(
                                fontSize: 18,
                                color: viewModel.isComparisonOn
                                    ? Colors.black
                                    : viewModel.isOlderCircularChartOn
                                        ? Colors.white
                                        : Colors.black),
                          ),
                          Text(
                            DateFormat('MM/dd/yy').format(viewModel
                                .olderEncounter!.encounterCreatedTime!),
                            style: TextStyle(
                                fontSize: 12,
                                color: viewModel.isComparisonOn
                                    ? Colors.black54
                                    : viewModel.isOlderCircularChartOn
                                        ? Colors.white
                                        : Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  )
                : viewModel.encounters.length >= 2
                    ? ElevatedButton(
                        onPressed: viewModel.encounters.length >= 2
                            ? () {
                                viewModel.stopAnimation();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    viewModel.tempIsSelectedEncounter =
                                        List<bool>.from(
                                            viewModel.isSelectedEncounter);
                                    return _buildSelectComparisonDialog(
                                        viewModel);
                                  },
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        child: const Center(
                            child: Text(
                          'Select an encounter to compare.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        )),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          viewModel.stopAnimation();
                          viewModel.navigateToHomeTab();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        child: const Center(
                            child: Text(
                          'Add a new encounter to compare.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
          )),
    );
  }

  Widget _buildEncounterSelection(
      InsightsViewModel viewModel, BuildContext context) {
    return IconButton(
      //TODO: use dialog service
      // onPressed: () => viewModel.showComparisonSelectDialog(),
      onPressed: viewModel.encounters.length >= 2
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  viewModel.tempIsSelectedEncounter =
                      List<bool>.from(viewModel.isSelectedEncounter);
                  return _buildSelectComparisonDialog(viewModel);
                },
              );
              viewModel.onPieSectionTapped(-1);
              viewModel.stopAnimation();
            }
          : null,
      padding: const EdgeInsets.only(right: 10),
      visualDensity: VisualDensity.compact,
      icon: const Icon(Icons.calendar_month),
      iconSize: 30,
      constraints: const BoxConstraints(),
    );
  }

  ElevatedButton _buildNewerDateToggle(InsightsViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.showNewerCircularChart,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: viewModel.isComparisonOn
              ? Colors.white
              : viewModel.isOlderCircularChartOn
                  ? Colors.white
                  : kcNewerEncounterColor,
          side: const BorderSide(color: kcNewerEncounterColor, width: 3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        child: SizedBox(
          width: 150,
          height: 60,
          child: Row(
            children: [
              Text(
                viewModel.isWeighted
                    ? viewModel.newerEncounter!.weightedTotalScore!
                        .round()
                        .toString()
                    : viewModel.newerEncounter!.unweightedTotalScore!
                        .round()
                        .toString(),
                style: TextStyle(
                    fontSize: 40,
                    color: viewModel.isComparisonOn
                        ? viewModel.currentPatient!.encounterCollection
                            .compareEncounterForAnalytics()!
                            .changeDirection!
                            .color
                        : viewModel.isOlderCircularChartOn
                            ? Colors.black
                            : Colors.white),
              ),
              horizontalSpaceSmall,
              Stack(clipBehavior: Clip.none, children: [
                if (viewModel.isSelectedEncounter.first)
                  Positioned(
                      top: -5,
                      child: Text(
                        'Latest',
                        style: TextStyle(
                            fontSize: 12,
                            color: viewModel.isComparisonOn
                                ? Colors.black
                                : viewModel.isOlderCircularChartOn
                                    ? Colors.black
                                    : Colors.white),
                      )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.getTimeDifference(
                          viewModel.newerEncounter!.encounterCreatedTime!),
                      style: TextStyle(
                          fontSize: 18,
                          color: viewModel.isComparisonOn
                              ? Colors.black
                              : viewModel.isOlderCircularChartOn
                                  ? Colors.black
                                  : Colors.white),
                    ),
                    Text(
                      DateFormat('MM/dd/yy').format(
                          viewModel.newerEncounter!.encounterCreatedTime!),
                      style: TextStyle(
                          fontSize: 12,
                          color: viewModel.isComparisonOn
                              ? Colors.black54
                              : viewModel.isOlderCircularChartOn
                                  ? Colors.black54
                                  : Colors.white),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildProgressBar(InsightsViewModel viewModel) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: viewModel.olderEncounter != null
              ? Alignment.center
              : Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: viewModel.progressBar),
              )
            ],
          ),
        ),
      ),
    );
  }

// TODO: create a dialog widget
  StatefulBuilder _buildSelectComparisonDialog(InsightsViewModel viewModel) {
    int latestIndex = viewModel.tempIsSelectedEncounter.indexOf(true);
    int oldestIndex =
        viewModel.tempIsSelectedEncounter.indexOf(true, latestIndex + 1);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: kcOlderEncounterColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        height: 90,
                        width: 230,
                        child: oldestIndex != -1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.encounters[oldestIndex]
                                        .unweightedTotalScore!
                                        .round()
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.getTimeDifference(viewModel
                                            .encounters[oldestIndex]
                                            .encounterCreatedTime!),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        DateFormat('MM/dd/yy').format(viewModel
                                            .encounters[oldestIndex]
                                            .encounterCreatedTime!),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {
                                        viewModel.tempIsSelectedEncounter[
                                            oldestIndex] = false;

                                        latestIndex = viewModel
                                            .tempIsSelectedEncounter
                                            .indexOf(true);
                                        oldestIndex = viewModel
                                            .tempIsSelectedEncounter
                                            .indexOf(true, latestIndex + 1);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      size: 40,
                                    ),
                                    color: Colors.red,
                                  )
                                ],
                              )
                            : const Center(
                                child: Text(
                                  'Select an encounter to compare.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: VerticalDivider(
                        width: 5,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: kcNewerEncounterColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        height: 90,
                        width: 230,
                        child: latestIndex != -1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.encounters[latestIndex]
                                        .unweightedTotalScore!
                                        .round()
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Stack(children: [
                                    if (latestIndex == 0)
                                      const Positioned(
                                          top: -5,
                                          child: Text(
                                            'Latest',
                                            style: TextStyle(fontSize: 12),
                                          )),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          viewModel.getTimeDifference(viewModel
                                              .encounters[latestIndex]
                                              .encounterCreatedTime!),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          DateFormat('MM/dd/yy').format(
                                              viewModel.encounters[latestIndex]
                                                  .encounterCreatedTime!),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ]),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {
                                        viewModel.tempIsSelectedEncounter[
                                            latestIndex] = false;

                                        latestIndex = viewModel
                                            .tempIsSelectedEncounter
                                            .indexOf(true);
                                        oldestIndex = viewModel
                                            .tempIsSelectedEncounter
                                            .indexOf(true, latestIndex + 1);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      size: 40,
                                    ),
                                    color: Colors.red,
                                  )
                                ],
                              )
                            : const Center(
                                child: Text(
                                  'Select an encounter to compare.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ],
                  )),
                ],
              ),
              verticalSpaceSmall,
              SizedBox(
                height: 400,
                width: 480,
                child: Scrollbar(
                  controller: viewModel.scrollController,
                  thumbVisibility: true,
                  child: ListView.separated(
                    controller: viewModel.scrollController,
                    shrinkWrap: true,
                    itemCount: viewModel.encounters.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: Icon(Icons.check_circle,
                              size: 35,
                              color: viewModel.tempIsSelectedEncounter[index]
                                  ? oldestIndex == index
                                      ? kcOlderEncounterColor
                                      : kcNewerEncounterColor
                                  : Colors.transparent),
                          title: Row(
                            children: [
                              Text(
                                  viewModel.getTimeDifference(viewModel
                                      .currentPatient!
                                      .encounterCollection
                                      .encounters[index]
                                      .encounterCreatedTime!),
                                  style: const TextStyle(fontSize: 20)),
                              horizontalSpaceTiny,
                              if (index == 0) const Text('(Latest)')
                            ],
                          ),
                          subtitle: Text(
                            DateFormat('MM/dd/yy').format(viewModel
                                .currentPatient!
                                .encounterCollection
                                .encounters[index]
                                .encounterCreatedTime!),
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            viewModel.currentPatient!.encounterCollection
                                .encounters[index].unweightedTotalScore!
                                .round()
                                .toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            setState(() {
                              bool isSelected =
                                  viewModel.tempIsSelectedEncounter[index];
                              int selectedCount = viewModel
                                  .tempIsSelectedEncounter
                                  .where((element) => element)
                                  .length;

                              if (isSelected) {
                                viewModel.tempIsSelectedEncounter[index] =
                                    false;
                              } else {
                                if (selectedCount < 2) {
                                  viewModel.tempIsSelectedEncounter[index] =
                                      true;
                                } else {
                                  if (latestIndex < index) {
                                    viewModel.tempIsSelectedEncounter[index] =
                                        true;
                                    viewModel.tempIsSelectedEncounter[
                                        oldestIndex] = false;
                                  } else if (latestIndex > index) {
                                    viewModel.tempIsSelectedEncounter[index] =
                                        true;
                                    viewModel.tempIsSelectedEncounter[
                                        latestIndex] = false;
                                  }
                                }
                              }

                              latestIndex = viewModel.tempIsSelectedEncounter
                                  .indexOf(true);
                              oldestIndex = viewModel.tempIsSelectedEncounter
                                  .indexOf(true, latestIndex + 1);
                            });
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 2,
                      indent: 14,
                      endIndent: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          _buildActionButtons(viewModel, context, latestIndex, oldestIndex),
        ],
        actionsAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }

  Widget _buildActionButtons(InsightsViewModel viewModel, BuildContext context,
      int latestIndex, int oldestIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50)),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: (viewModel.tempIsSelectedEncounter
                        .every((element) => element == false))
                    ? null
                    : () async {
                        viewModel.showBusyDialog();
                        FutureGroup futureGroup = FutureGroup();
                        viewModel.isSelectedEncounter =
                            List<bool>.from(viewModel.tempIsSelectedEncounter);

                        viewModel.currentPatient!.encounterCollection
                                .newerComparisonEncounter =
                            viewModel.currentPatient!.encounterCollection
                                .encounters[latestIndex];

                        futureGroup.add(viewModel.newerEncounter!.populate(patient: viewModel.currentPatient));

                        if (isDemo && viewModel.currentPatient!.fullName !=
                                'Brown, Emily' &&
                            viewModel.newerEncounter!.outcomeMeasures!
                                .every((element) => element.id != ksProgait)) {
                          viewModel.newerEncounter!.addOutcomeMeasure(
                              proGaitList[viewModel.encounters.length -
                                  latestIndex -
                                  1]);
                          proGaitList[
                                  viewModel.encounters.length - latestIndex - 1]
                              .buildInfo();
                        }

                        if (viewModel.isSelectedEncounter
                                .where((element) => element == true)
                                .length ==
                            1) {
                          viewModel.currentPatient!.encounterCollection
                              .olderComparisonEncounter = null;
                          viewModel.isComparisonOn = false;
                          futureGroup.close();
                          await futureGroup.future;
                        } else {
                          viewModel.currentPatient!.encounterCollection
                                  .olderComparisonEncounter =
                              viewModel.currentPatient!.encounterCollection
                                  .encounters[oldestIndex];

                          futureGroup.add(viewModel.olderEncounter!.populate(patient: viewModel.currentPatient));
                          futureGroup.close();
                          await futureGroup.future;

                          if (isDemo && viewModel.currentPatient!.fullName !=
                                  'Brown, Emily' &&
                              viewModel.olderEncounter!.outcomeMeasures!.every(
                                  (element) => element.id != ksProgait)) {
                            viewModel.olderEncounter!.addOutcomeMeasure(
                                proGaitList[viewModel.encounters.length -
                                    oldestIndex -
                                    1]);
                            proGaitList[viewModel.encounters.length -
                                    oldestIndex -
                                    1]
                                .buildInfo();
                          }

                          viewModel.startAnimation();
                        }
                        viewModel.isWeighted = false;

                        viewModel.currentEncounterData =
                            viewModel.newerEncounterCircularData;

                        viewModel.notifyListeners();
                        viewModel.closeBusyDialog();
                        Navigator.of(context).pop();
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50)),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
