import 'package:biot/model/comparison.dart';
import 'package:biot/ui/widgets/sig_diff_indication.dart';
import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';
import '../../constants/enum.dart';
import '../../constants/images.dart';
import '../common/ui_helpers.dart';

class TextSummaryDialog extends StatefulWidget {
  final List<DomainComparison> domainComparisons;
  final String changeDirection;

  const TextSummaryDialog(this.domainComparisons, this.changeDirection,
      {super.key});

  @override
  State<StatefulWidget> createState() => _TextSummaryDialogState();
}

class _TextSummaryDialogState extends State<TextSummaryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.changeDirection == ksImproved
                ? Icons.arrow_circle_up_outlined
                : widget.changeDirection == ksDeclined
                    ? Icons.arrow_circle_down_outlined
                    : Icons.arrow_circle_right_outlined,
            color: widget.changeDirection == ksImproved
                ? Colors.green
                : widget.changeDirection == ksDeclined
                    ? Colors.red
                    : Colors.black,
            size: 40,
          ),
          horizontalSpaceSmall,
          Text(
            widget.changeDirection == ksImproved
                ? 'Improvement Trend'
                : widget.changeDirection == ksDeclined
                    ? 'Decline Trend'
                    : 'Stable Trend',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: widget.changeDirection == ksImproved
                    ? Colors.green
                    : widget.changeDirection == ksDeclined
                        ? Colors.red
                        : Colors.black),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 800,
            height: 400,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    _buildContent(widget.domainComparisons[index]),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: widget.domainComparisons.length,
              ),
            ),
          ),
          if (widget.domainComparisons.any((element) =>
              element.outcomeMeasureComparisons.any((element) =>
                  element.rawScoreChangeDirection ==
                      ChangeDirection.sigPositive ||
                  element.rawScoreChangeDirection ==
                      ChangeDirection.sigNegative)))
            _buildFootnote()
        ],
      ),
    );
  }

  Widget _buildContent(DomainComparison domainComparison) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              domainComparison.header,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SigDiffIndication(domainComparison),
            ),
          ],
        ),
        widget.changeDirection == ksImproved
            ? Text(
                domainComparison.improvementSummary,
                style: const TextStyle(fontSize: 18),
              )
            : widget.changeDirection == ksDeclined
                ? Text(
                    domainComparison.declineSummary,
                    style: const TextStyle(fontSize: 18),
                  )
                : Text(
                    domainComparison.stableSummary,
                    style: const TextStyle(fontSize: 18),
                  ),
      ],
    );
  }

  Widget _buildFootnote() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.domainComparisons.any((element) =>
                  element.outcomeMeasureComparisons.any((element) =>
                      element.rawScoreChangeDirection ==
                      ChangeDirection.sigPositive)))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    sigDiffUpIcon,
                    color: Colors.green,
                    scale: 3.5,
                  ),
                ),
              if (widget.domainComparisons.any((element) =>
                  element.outcomeMeasureComparisons.any((element) =>
                      element.rawScoreChangeDirection ==
                      ChangeDirection.sigNegative)))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    sigDiffDownIcon,
                    color: Colors.red,
                    scale: 3.5,
                  ),
                ),
              const Text(
                ksSignificantChangeHeader,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const Text(ksSignificantChangeBody, style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
