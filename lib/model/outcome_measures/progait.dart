import 'package:biot/model/patient.dart';
import '../../constants/app_strings.dart';
import '../chart_data.dart';
import 'outcome_measure.dart';

class ProGait extends OutcomeMeasure {
  double prosthesisDynamicsAP;
  double prosthesisDynamicsML;
  double temporalSymmetry;
  double prosthesisDynamicsMaxYValue = 100;
  double prosthesisDynamicsMinYValue = 0;
  double temporalSymmetryMaxYValue = 150;
  double temporalSymmetryMinYValue = 50;

  ProGait(
      {required super.id,
      super.data,
      required this.prosthesisDynamicsAP,
      required this.prosthesisDynamicsML,
      required this.temporalSymmetry}) {
    numOfGraph = 3;
    rawValue = prosthesisDynamicsML;
  }

  @override
  double calculateScore() {
    rawValue = prosthesisDynamicsML;

    double result;
    result = (prosthesisDynamicsML - prosthesisDynamicsMinYValue) *
        100 /
        (prosthesisDynamicsMaxYValue - prosthesisDynamicsMinYValue);

    return result;
  }

  @override
  TimeSeriesChartData outcomeMeasureChartData() {
    return TimeSeriesChartData(date: outcomeMeasureCreatedTime!, dataList: [
      ChartData(label: 'A/P', value: prosthesisDynamicsAP),
      ChartData(label: 'M/L', value: prosthesisDynamicsML),
      ChartData(label: 'Temporal Symmetry', value: temporalSymmetry)
    ]);
  }

  @override
  void populateWithJson(Map<String, dynamic> json) {
    // TODO: implement populateWithJson
  }

  @override
  // TODO: implement templateId
  String? get templateId => '';

  @override
  Map<String, dynamic> toJson(
      String ownerOrganizationId, Patient patient, int index) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  OutcomeMeasure clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }
}

//Ascending order. proGait1 is the oldest one.
ProGait proGait1 = ProGait(
    id: ksProgait,
    prosthesisDynamicsAP: 60,
    prosthesisDynamicsML: 70,
    temporalSymmetry: 130);

ProGait proGait2 = ProGait(
    id: ksProgait,
    prosthesisDynamicsAP: 75,
    prosthesisDynamicsML: 65,
    temporalSymmetry: 101);

ProGait proGait3 = ProGait(
    id: ksProgait,
    prosthesisDynamicsAP: 90,
    prosthesisDynamicsML: 78,
    temporalSymmetry: 110);

ProGait proGait4 = ProGait(
    id: ksProgait,
    prosthesisDynamicsAP: 77,
    prosthesisDynamicsML: 84,
    temporalSymmetry: 80);

ProGait proGait5 = ProGait(
    id: ksProgait,
    prosthesisDynamicsAP: 95,
    prosthesisDynamicsML: 90,
    temporalSymmetry: 100);

List<ProGait> proGaitList = [proGait1, proGait2, proGait3, proGait4, proGait5];
