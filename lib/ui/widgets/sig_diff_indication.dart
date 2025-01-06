import 'package:biot/model/comparison.dart';
import 'package:flutter/material.dart';

import '../../constants/images.dart';

class SigDiffIndication extends StatefulWidget {
  final DomainComparison domainComparison;

  const SigDiffIndication(this.domainComparison, {super.key});

  @override
  State<StatefulWidget> createState() => _SigDiffIndicationState();
}

class _SigDiffIndicationState extends State<SigDiffIndication> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.domainComparison.hasSigPos ||
            widget.domainComparison.hasSigNeg)
          const Text(
            '[',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        if (widget.domainComparison.hasSigNeg)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Image.asset(
              sigDiffDownIcon,
              color: Colors.red,
              scale: 4.5,
            ),
          ),
        if (widget.domainComparison.hasSigPos)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Image.asset(
              sigDiffUpIcon,
              color: Colors.green,
              scale: 4.5,
            ),
          ),
        if (widget.domainComparison.hasSigPos ||
            widget.domainComparison.hasSigNeg)
          const Text(
            ']',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
      ],
    );
  }
}
