import 'package:flutter/material.dart';
import 'package:biot/ui/common/app_colors.dart';
import 'package:biot/ui/common/ui_helpers.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../model/outcome_measures/outcome_measure.dart';
import 'outcome_measure_select_edit_dialog_model.dart';

class OutcomeMeasureSelectEditDialog
    extends StackedView<OutcomeMeasureSelectEditDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const OutcomeMeasureSelectEditDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OutcomeMeasureSelectEditDialogModel viewModel,
    Widget? child,
  ) {
    Widget content = SizedBox(
      width: 500,
      height: 600,
      child: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              // padding: const EdgeInsets.symmetric(horizontal: 40),
              buildDefaultDragHandles: true,
              onReorder: viewModel.onReorder,
              children: [
                for (int index = 0;
                    index < viewModel.outcomeMeasures.length;
                    index += 1)
                  ListTile(
                    key: Key('$index'),
                    leading: Container(
                      width: 80,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              viewModel.onRemove(index);
                            },
                            child: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.circle,
                                  color: Colors.green, size: 30),
                              Text(
                                (index + 1).toString(),
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    title: Text(viewModel.outcomeMeasures[index].name!),
                    subtitle: Text(viewModel.outcomeMeasures[index].shortName!),
                  )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              completer(DialogResponse<List<OutcomeMeasure>>(
                  confirmed: true, data: viewModel.outcomeMeasures));
            },
            child: Container(
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      // child: ListView.separated(
      //   itemCount: request.data!.length,
      //   itemBuilder: (context, index) => ListTile(
      //     leading: Container(
      //       width: 80,
      //       height: 80,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           const Icon(
      //             Icons.remove_circle,
      //             color: Colors.red,
      //             size: 30,
      //           ),
      //           horizontalSpaceSmall,
      //           Stack(
      //             alignment: Alignment.center,
      //             children: [
      //               const Icon(Icons.circle, color: Colors.green, size: 30),
      //               Text(
      //                 index.toString(),
      //                 style: const TextStyle(color: Colors.white),
      //               )
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //     title: Text(outcomeMeasures[index].title!),
      //     subtitle: Text(outcomeMeasures[index].shortTitle!),
      //     trailing: const Icon(Icons.menu, size: 30,),
      //   ),
      //   separatorBuilder: (BuildContext context, int index) {
      //     return const Divider(
      //       height: 1,
      //       thickness: 1,
      //       indent: 10,
      //       endIndent: 10,
      //     );
      //   },
      // )
    );
    return Device.get().isTablet
        ? Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: content
                // child: Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           request.title!,
                //           style: const TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.w900),
                //         ),
                //         verticalSpaceTiny,
                //         if (request.description != null)
                //           Text(
                //             request.description!,
                //             style: const TextStyle(fontSize: 14, color: kcMediumGrey),
                //             maxLines: 3,
                //             softWrap: true,
                //           ),
                //       ],
                //     ),
                //     verticalSpaceMedium,
                //     GestureDetector(
                //       onTap: () => completer(DialogResponse<List<OutcomeMeasure>>(
                //         confirmed: true,
                //         data: []
                //       )),
                //       child: Container(
                //         height: 50,
                //         width: double.infinity,
                //         alignment: Alignment.center,
                //         child: const Text(
                //           'Close',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 16,
                //           ),
                //         ),
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                ),
          )
        : Dialog.fullscreen(
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: content
                // child: Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           request.title!,
                //           style: const TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.w900),
                //         ),
                //         verticalSpaceTiny,
                //         if (request.description != null)
                //           Text(
                //             request.description!,
                //             style: const TextStyle(fontSize: 14, color: kcMediumGrey),
                //             maxLines: 3,
                //             softWrap: true,
                //           ),
                //       ],
                //     ),
                //     verticalSpaceMedium,
                //     GestureDetector(
                //       onTap: () => completer(DialogResponse<List<OutcomeMeasure>>(
                //         confirmed: true,
                //         data: []
                //       )),
                //       child: Container(
                //         height: 50,
                //         width: double.infinity,
                //         alignment: Alignment.center,
                //         child: const Text(
                //           'Close',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 16,
                //           ),
                //         ),
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                ),
          );
  }

  @override
  OutcomeMeasureSelectEditDialogModel viewModelBuilder(BuildContext context) =>
      OutcomeMeasureSelectEditDialogModel(request.data!);
}
