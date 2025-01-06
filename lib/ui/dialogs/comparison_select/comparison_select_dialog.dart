import 'package:flutter/material.dart';
import 'package:biot/ui/common/app_colors.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'comparison_select_dialog_model.dart';

const double _graphicSize = 60;

class ComparisonSelectDialog extends StackedView<ComparisonSelectDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ComparisonSelectDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    ComparisonSelectDialogModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      // content: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           Expanded(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   if (latestIndex != -1)
      //                     Text(
      //                       DateFormat('MM/dd/yy').format(viewModel
      //                           .currentPatient!
      //                           .encounters![latestIndex]
      //                           .encounterCreatedTime!),
      //                       style: const TextStyle(fontSize: 18),
      //                     ),
      //                   if (latestIndex != -1)
      //                     TextButton(
      //                       onPressed: () {
      //                         setState(() {
      //                           viewModel.tempIsSelectedEncounter[latestIndex] =
      //                           false;
      //
      //                           latestIndex = viewModel.tempIsSelectedEncounter
      //                               .indexOf(true);
      //                           oldestIndex = viewModel.tempIsSelectedEncounter
      //                               .indexOf(true, latestIndex + 1);
      //                         });
      //                       },
      //                       style: TextButton.styleFrom(
      //                           padding: const EdgeInsets.all(6),
      //                           minimumSize: const Size(50, 20),
      //                           tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      //                       child: const Text('Remove'),
      //                     )
      //                 ],
      //               )),
      //           const Padding(
      //             padding: EdgeInsets.symmetric(vertical: 14.0),
      //             child: Text(
      //               'Compared\nTo',
      //               style: TextStyle(fontSize: 10),
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //           Expanded(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   if ((oldestIndex != -1))
      //                     Text(
      //                       DateFormat('MM/dd/yy').format(viewModel
      //                           .currentPatient!
      //                           .encounters![oldestIndex]
      //                           .encounterCreatedTime!),
      //                       style: const TextStyle(fontSize: 18),
      //                     ),
      //                   if ((oldestIndex != -1))
      //                     TextButton(
      //                       onPressed: () {
      //                         setState(() {
      //                           viewModel.tempIsSelectedEncounter[oldestIndex] =
      //                           false;
      //
      //                           latestIndex = viewModel.tempIsSelectedEncounter
      //                               .indexOf(true);
      //                           oldestIndex = viewModel.tempIsSelectedEncounter
      //                               .indexOf(true, latestIndex + 1);
      //                         });
      //                       },
      //                       style: TextButton.styleFrom(
      //                           padding: const EdgeInsets.all(6),
      //                           minimumSize: const Size(50, 20),
      //                           tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      //                       child: const Text('Remove'),
      //                     )
      //                 ],
      //               )),
      //         ],
      //       ),
      //       const Divider(
      //         height: 0,
      //         thickness: 1.5,
      //       ),
      //       SizedBox(
      //         height: 400,
      //         width: 300,
      //         child: ListView.separated(
      //           shrinkWrap: true,
      //           itemCount: viewModel
      //               .currentPatient!.encounterCollection.encounters.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return Material(
      //               child: ListTile(
      //                 title: Text(
      //                   DateFormat('MM/dd/yy').format(viewModel
      //                       .currentPatient!
      //                       .encounterCollection
      //                       .encounters[index]
      //                       .encounterCreatedTime!),
      //                   style: TextStyle(
      //                       color: (viewModel.tempIsSelectedEncounter[index])
      //                           ? Colors.white
      //                           : Colors.black),
      //                 ),
      //                 tileColor: (viewModel.tempIsSelectedEncounter[index])
      //                     ? Colors.black
      //                     : Colors.transparent,
      //                 trailing: Text(
      //                   viewModel.currentPatient!.encounterCollection
      //                       .encounters[index].unweightedTotalScore!
      //                       .round()
      //                       .toString(),
      //                   style: TextStyle(
      //                       color: (viewModel.tempIsSelectedEncounter[index])
      //                           ? Colors.white
      //                           : Colors.black,
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold),
      //                 ),
      //                 onTap: () {
      //                   setState(() {
      //                     if (viewModel.tempIsSelectedEncounter[index]) {
      //                       viewModel.tempIsSelectedEncounter[index] = false;
      //                     } else {
      //                       if (viewModel.tempIsSelectedEncounter
      //                           .where((element) => element == true)
      //                           .length <
      //                           2) {
      //                         viewModel.tempIsSelectedEncounter[index] = true;
      //                       }
      //                     }
      //
      //                     latestIndex =
      //                         viewModel.tempIsSelectedEncounter.indexOf(true);
      //                     oldestIndex = viewModel.tempIsSelectedEncounter
      //                         .indexOf(true, latestIndex + 1);
      //                   });
      //                 },
      //               ),
      //             );
      //           },
      //           separatorBuilder: (BuildContext context, int index) =>
      //           const Divider(height: 2),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      // actions: [
      //   ElevatedButton(
      //     onPressed: () {
      //       viewModel.tempIsSelectedEncounter =
      //       List<bool>.from(viewModel.isSelectedEncounter);
      //       Navigator.of(context).pop();
      //     },
      //     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      //     child: const Text('Cancel'),
      //   ),
      //   ElevatedButton(
      //     onPressed: (viewModel.tempIsSelectedEncounter
      //         .every((element) => element == false))
      //         ? null
      //         : () async {
      //       FutureGroup futureGroup = FutureGroup();
      //       viewModel.isSelectedEncounter =
      //           viewModel.tempIsSelectedEncounter;
      //
      //       viewModel.currentPatient!.encounterCollection
      //           .newerComparisonEncounter =
      //       viewModel.currentPatient!.encounterCollection
      //           .encounters[latestIndex];
      //
      //       futureGroup.add(viewModel.currentPatient!
      //           .encounterCollection.newerComparisonEncounter!
      //           .populate());
      //
      //       if (viewModel.isSelectedEncounter
      //           .where((element) => element == true)
      //           .length ==
      //           1) {
      //         viewModel.currentPatient!.encounterCollection
      //             .olderComparisonEncounter = null;
      //         // viewModel.isComparisonOn = false;
      //         futureGroup.close();
      //         await futureGroup.future;
      //       } else {
      //         // viewModel.isComparisonOn = true;
      //         viewModel.currentPatient!.encounterCollection
      //             .olderComparisonEncounter =
      //         viewModel.currentPatient!.encounterCollection
      //             .encounters[oldestIndex];
      //
      //         futureGroup.add(viewModel.currentPatient!
      //             .encounterCollection.olderComparisonEncounter!
      //             .populate());
      //         futureGroup.close();
      //         await futureGroup.future;
      //       }
      //       viewModel.isWeighted = false;
      //
      //       viewModel.currentPatient!.encounterCollection
      //           .newerComparisonEncounter
      //           ?.sortDomainListByPatientDomainWeightDistribution(
      //           viewModel.currentPatient!.domainWeightDist
      //               .domainSortedByWeight);
      //       viewModel.currentPatient!.encounterCollection
      //           .olderComparisonEncounter
      //           ?.sortDomainListByPatientDomainWeightDistribution(
      //           viewModel.currentPatient!.domainWeightDist
      //               .domainSortedByWeight);
      //
      //       viewModel.notifyListeners();
      //       Navigator.of(context).pop();
      //     },
      //     style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      //     child: const Text('Update'),
      //   )
      // ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );

    // return Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   backgroundColor: Colors.white,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Expanded(
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     request.title ?? 'Hello Stacked Dialog!!',
    //                     style: const TextStyle(
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.w900,
    //                     ),
    //                   ),
    //                   if (request.description != null) ...[
    //                     verticalSpaceTiny,
    //                     Text(
    //                       request.description!,
    //                       style: const TextStyle(
    //                         fontSize: 14,
    //                         color: kcMediumGrey,
    //                       ),
    //                       maxLines: 3,
    //                       softWrap: true,
    //                     ),
    //                   ],
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               width: _graphicSize,
    //               height: _graphicSize,
    //               decoration: const BoxDecoration(
    //                 color: Color(0xFFF6E7B0),
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(_graphicSize / 2),
    //                 ),
    //               ),
    //               alignment: Alignment.center,
    //               child: const Text('⭐️', style: TextStyle(fontSize: 30)),
    //             )
    //           ],
    //         ),
    //         verticalSpaceMedium,
    //         GestureDetector(
    //           onTap: () => completer(DialogResponse(confirmed: true)),
    //           child: Container(
    //             height: 50,
    //             width: double.infinity,
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               color: Colors.black,
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //             child: const Text(
    //               'Got it',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 16,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  @override
  ComparisonSelectDialogModel viewModelBuilder(BuildContext context) =>
      ComparisonSelectDialogModel();
}
