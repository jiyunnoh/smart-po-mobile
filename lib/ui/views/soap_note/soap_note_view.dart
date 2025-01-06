import 'dart:io';

import 'package:biot/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'soap_note_viewmodel.dart';

class SoapNoteView extends StackedView<SoapNoteViewModel> {
  const SoapNoteView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SoapNoteViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.copy),
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: const [
              Text(
                'Subjective:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Four months ago, the patient experienced discomfort in their socket, with an SCS value of 4 for before the socket fit, 6 for the after the socket fit. Currently, the patient reports a significant improvement in comfort levels: the before the socket fit score is 5 and the after the socket fit is 9.'),
              verticalSpaceMedium,
              Text(
                'Assessment:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Since Sabrina\'s visit four months ago, there has been noticeable improvement in her General Satisfaction and Goal Achievement. However, her Community Interaction has seen a decline. Meanwhile, both Comfort and Fit and Functional Performance have remained stable.\n\nHer Goal Achievement has shown a significant improvement, as evidenced by the Patient Specific Functional Scale outcome measure. The increase in her average score surpassed the Minimal Clinically Important Difference (MCID) threshold of 4.2. As full achievement of goals is approached, it may be time to discuss whether new goals may have become important for the patient, or if stability is the desired endpoint.\n\nPatient reported satisfaction incorporates their overall value system and any trend of improvement represents a contribution towards successful rehabilitation, even if it just means that for the patient, the prothesis or orthosis is not a barrier to their satisfaction.\n\nA decline in community measures can be a warning sign that mobility challenges may be preventing the patient from engaging a broader community. Roadblocks should be identified and rectified.')
            ],
          ),
        ));
  }

  @override
  SoapNoteViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SoapNoteViewModel();
}
