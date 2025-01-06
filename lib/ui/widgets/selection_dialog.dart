import 'package:biot/constants/enum.dart';
import 'package:biot/model/encounter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/ui_helpers.dart';

class SelectionDialog extends StatefulWidget {
  final Function(List<Encounter?>) onTapCompare;
  final List<Encounter> encounters;
  final List<Encounter?> selectedEncounters;
  List<bool> isSelectedList = [];
  final int defaultEncounterIndex;
  bool isLoading = false;

  SelectionDialog(
      {super.key,
      required this.onTapCompare,
      required this.encounters,
      required this.defaultEncounterIndex,
      required this.selectedEncounters}) {
    isSelectedList = List.generate(encounters.length, (index) => false);
    encounters.asMap().entries.map((entry) {
      int index = entry.key;
      Encounter encounter = entry.value;
      if (selectedEncounters.contains(encounter)) {
        isSelectedList[index] = true;
      }
    }).toList();
  }

  @override
  State<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  @override
  Widget build(BuildContext context) {
    bool selectionValidation =
        widget.isSelectedList.where((element) => element == true).length > 4;
    return Stack(
      children: [
        AlertDialog(
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Encounters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              const Text(
                'You can compare up to 4 encounters.',
                style: TextStyle(fontSize: 14),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      children:
                          List.generate(widget.encounters.length, (index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Center(
                            child: Text(
                              widget.encounters[index].encounterCreatedTime!
                                  .toLocal()
                                  .toFormattedString(DateFormat.yMd().add_jm()),
                              style: TextStyle(
                                  color: widget.isSelectedList[index]
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          onTap: (widget.defaultEncounterIndex == index)
                              ? null
                              : () => setState(() {
                                    widget.isSelectedList[index] =
                                        !widget.isSelectedList[index];
                                  }),
                          tileColor: (widget.defaultEncounterIndex == index)
                              ? Colors.grey
                              : widget.isSelectedList[index]
                                  ? Colors.black
                                  : Colors.transparent,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Divider(height: 0),
                        ),
                      ],
                    );
                  })),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: selectionValidation
                    ? null
                    : () async {
                        List<Encounter?> selectedEncounters =
                            List.generate(widget.encounters.length, (index) {
                          if (widget.defaultEncounterIndex == index) {
                            return null;
                          } else if (widget.isSelectedList[index]) {
                            return widget.encounters[index];
                          } else {
                            return null;
                          }
                        }).where((element) => element != null).toList();
                        try {
                          setState(() {
                            widget.isLoading = true;
                          });
                          await widget.onTapCompare(selectedEncounters);
                          setState(() {
                            widget.isLoading = false;
                          });
                        } catch (e) {
                        }
                        Navigator.of(context).pop();
                      },
                child: const SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist_rounded),
                      horizontalSpaceTiny,
                      Text(
                        'Compare',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        if (widget.isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
