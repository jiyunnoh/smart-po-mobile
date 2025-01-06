import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/patient.dart';
import '../../model/encounter.dart';

class ComparisonSelectDialog extends StatefulWidget {
  final Patient patient;
  List<bool> tempIsSelectedEncounter;
  List<bool> isSelectedEncounter;
  Encounter newerComparisonEncounter;
  Encounter? olderComparisonEncounter;
  bool isComparisonOn;
  bool isWeighted;
  final Function() prepDataForFlowerChart;

  ComparisonSelectDialog(
      {super.key,
      required this.patient,
      required this.tempIsSelectedEncounter,
      required this.isSelectedEncounter,
      required this.newerComparisonEncounter,
      required this.olderComparisonEncounter,
      required this.isComparisonOn,
      required this.isWeighted,
      required this.prepDataForFlowerChart});

  @override
  State<StatefulWidget> createState() => _ComparisonSelectDialogState();
}

class _ComparisonSelectDialogState extends State<ComparisonSelectDialog> {
  @override
  Widget build(BuildContext context) {
    int latestIndex = widget.tempIsSelectedEncounter.indexOf(true);
    int oldestIndex =
        widget.tempIsSelectedEncounter.indexOf(true, latestIndex + 1);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      if (latestIndex != -1)
                        Text(
                          DateFormat('MM/dd/yy').format(widget.patient
                              .encounters![latestIndex].encounterCreatedTime!),
                          style: const TextStyle(fontSize: 18),
                        ),
                      if (latestIndex != -1)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.tempIsSelectedEncounter[latestIndex] =
                                  false;

                              latestIndex =
                                  widget.tempIsSelectedEncounter.indexOf(true);
                              oldestIndex = widget.tempIsSelectedEncounter
                                  .indexOf(true, latestIndex + 1);
                            });
                          },
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(6),
                              minimumSize: const Size(50, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('Remove'),
                        )
                    ],
                  )),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      'Compared\nTo',
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((oldestIndex != -1))
                        Text(
                          DateFormat('MM/dd/yy').format(widget.patient
                              .encounters![oldestIndex].encounterCreatedTime!),
                          style: const TextStyle(fontSize: 18),
                        ),
                      if ((oldestIndex != -1))
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.tempIsSelectedEncounter[oldestIndex] =
                                  false;

                              latestIndex =
                                  widget.tempIsSelectedEncounter.indexOf(true);
                              oldestIndex = widget.tempIsSelectedEncounter
                                  .indexOf(true, latestIndex + 1);
                            });
                          },
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(6),
                              minimumSize: const Size(50, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('Remove'),
                        )
                    ],
                  )),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              SizedBox(
                height: 400,
                width: 300,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.patient.encounters!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: ListTile(
                        title: Text(
                          DateFormat('MM/dd/yy').format(widget.patient
                              .encounters![index].encounterCreatedTime!),
                          style: TextStyle(
                              color: (widget.tempIsSelectedEncounter[index])
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor: (widget.tempIsSelectedEncounter[index])
                            ? Colors.black
                            : Colors.transparent,
                        trailing: Text(
                          widget
                              .patient.encounters![index].unweightedTotalScore!
                              .round()
                              .toString(),
                          style: TextStyle(
                              color: (widget.tempIsSelectedEncounter[index])
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          setState(() {
                            if (widget.tempIsSelectedEncounter[index]) {
                              widget.tempIsSelectedEncounter[index] = false;
                            } else {
                              if (widget.tempIsSelectedEncounter
                                      .where((element) => element == true)
                                      .length <
                                  2) {
                                widget.tempIsSelectedEncounter[index] = true;
                              }
                            }

                            latestIndex =
                                widget.tempIsSelectedEncounter.indexOf(true);
                            oldestIndex = widget.tempIsSelectedEncounter
                                .indexOf(true, latestIndex + 1);
                          });
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 2),
                ),
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.tempIsSelectedEncounter =
                  List<bool>.from(widget.isSelectedEncounter);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: (widget.tempIsSelectedEncounter
                    .every((element) => element == false))
                ? null
                : () async {
                    FutureGroup futureGroup = FutureGroup();
                    widget.isSelectedEncounter = widget.tempIsSelectedEncounter;

                    widget.newerComparisonEncounter =
                        widget.patient.encounters![latestIndex];

                    futureGroup.add(widget.newerComparisonEncounter.populate(patient: widget.patient));

                    if (widget.isSelectedEncounter
                            .where((element) => element == true)
                            .length ==
                        1) {
                      widget.olderComparisonEncounter = null;
                      widget.isComparisonOn = false;
                      futureGroup.close();
                      await futureGroup.future;
                    } else {
                      widget.olderComparisonEncounter =
                          widget.patient.encounters![oldestIndex];

                      futureGroup
                          .add(widget.olderComparisonEncounter!.populate(patient: widget.patient));
                      futureGroup.close();
                      await futureGroup.future;
                    }
                    widget.isWeighted = false;

                    widget.prepDataForFlowerChart();
                    Navigator.of(context).pop();
                  },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Update'),
          )
        ],
        actionsAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}
