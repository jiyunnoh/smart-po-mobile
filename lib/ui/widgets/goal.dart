import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../views/insights/insights_viewmodel.dart';

class Goal extends ViewModelWidget<InsightsViewModel> {
  const Goal({super.key});

  @override
  Widget build(BuildContext context, InsightsViewModel viewModel) {
    return Card(
        elevation: 2,
        // child: Container(height: 200,
        // ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              ListTile(
                leading: const Text(
                  '1',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Get up from a seated position'),
                    SfLinearGauge(
                        maximum: 10.0,
                        minorTicksPerInterval: 0,
                        showLabels: false,
                        showTicks: false,
                        axisTrackStyle: const LinearAxisTrackStyle(
                            thickness: 20, edgeStyle: LinearEdgeStyle.bothCurve),
                        barPointers: const [
                          LinearBarPointer(
                              value: 8,
                              thickness: 20,
                              edgeStyle: LinearEdgeStyle.bothCurve)
                        ])
                  ],
                ),
                // Slider(value: 0.5, onChanged: null)
                trailing: Text(
                  '8',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Text(
                  '2',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Walk around my neighborhood'),
                    SfLinearGauge(
                        maximum: 10.0,
                        minorTicksPerInterval: 0,
                        showLabels: false,
                        showTicks: false,
                        axisTrackStyle: const LinearAxisTrackStyle(
                            thickness: 20, edgeStyle: LinearEdgeStyle.bothCurve),
                        barPointers: const [
                          LinearBarPointer(
                              value: 9,
                              thickness: 20,
                              edgeStyle: LinearEdgeStyle.bothCurve)
                        ])
                  ],
                ),
                // Slider(value: 0.5, onChanged: null)
                trailing: Text(
                  '9',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Text(
                  '3',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wear shoes'),
                    SfLinearGauge(
                        maximum: 10.0,
                        minorTicksPerInterval: 0,
                        showLabels: false,
                        showTicks: false,
                        axisTrackStyle: const LinearAxisTrackStyle(
                            thickness: 20, edgeStyle: LinearEdgeStyle.bothCurve),
                        barPointers: const [
                          LinearBarPointer(
                              value: 4,
                              thickness: 20,
                              edgeStyle: LinearEdgeStyle.bothCurve)
                        ])
                  ],
                ),
                // Slider(value: 0.5, onChanged: null)
                trailing: Text(
                  '4',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}
