import 'package:biot/constants/enum.dart';

import '../app/app.locator.dart';
import '../constants/app_strings.dart';
import '../services/cloud_service.dart';
import 'package:http/http.dart' as http;

class DomainWeightDistribution {
  String? entityId;
  num? hrqol;
  num? function;
  num? goals;
  num? comfort;
  num? satisfaction;

  final _apiService = locator<BiotService>();

  DomainWeightDistribution(
      {this.entityId,
      this.hrqol,
      this.function,
      this.goals,
      this.comfort,
      this.satisfaction});

  factory DomainWeightDistribution.equalDistribute() {
    return DomainWeightDistribution(
        hrqol: 20, function: 20, goals: 20, comfort: 20, satisfaction: 20);
  }

  List<DomainType> get domainSortedByWeight {
    List<Map<String, dynamic>> numList = [
      {'type': DomainType.hrqol, 'value': hrqol},
      {'type': DomainType.function, 'value': function},
      {'type': DomainType.goals, 'value': goals},
      {'type': DomainType.comfort, 'value': comfort},
      {'type': DomainType.satisfaction, 'value': satisfaction},
    ];
    numList.sort((a, b) => b['value'].compareTo(a['value']));
    return numList.map<DomainType>((e) => e['type']).toList();
  }

  num getDomainWeightValue(DomainType type) {
    switch (type) {
      case DomainType.function:
        return function!;
      case DomainType.goals:
        return goals!;
      case DomainType.comfort:
        return comfort!;
      case DomainType.satisfaction:
        return satisfaction!;
      case DomainType.hrqol:
        return hrqol!;
    }
  }

  factory DomainWeightDistribution.fromJson(Map<String, dynamic> data) {
    DomainWeightDistribution domainWeightDist = DomainWeightDistribution(
        entityId: data['_id'] ?? data['id'],
        hrqol: data[ksHrQoLWeightVal],
        function: data[ksFunctionWeightVal],
        goals: data[ksGoalsWeightVal],
        comfort: data[ksComfortWeightVal],
        satisfaction: data[ksSatisfactionWeightVal]);
    return domainWeightDist;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> body = {
      "_templateId": ksDomainWeightDistTemplateId,
      ksHrQoLWeightVal: hrqol,
      ksFunctionWeightVal: function,
      ksGoalsWeightVal: goals,
      ksComfortWeightVal: comfort,
      ksSatisfactionWeightVal: satisfaction,
    };

    if (entityId != null) {
      body.addAll({"id": entityId});
    }

    return body;
  }

  Future populate() async {
    DomainWeightDistribution temp =
        await _apiService.getDomainWeightDistribution(http.Client(), entityId!);
    hrqol = temp.hrqol;
    function = temp.function;
    goals = temp.goals;
    comfort = temp.comfort;
    satisfaction = temp.satisfaction;
  }
}
