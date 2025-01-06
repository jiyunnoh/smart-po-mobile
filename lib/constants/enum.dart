import 'package:biot/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_strings.dart';

enum EncounterType { mg, prosat, outcomeMeasure, unknown }

enum FilterType {
  performance('performance'),
  patientReported('patientReported'),
  lowerExtremity('lowerExtremity'),
  upperExtremity('upperExtremity');

  final String type;

  const FilterType(this.type);

  factory FilterType.fromType(String type) {
    return values.firstWhere((e) => e.type == type);
  }

  String get displayName {
    switch (this) {
      case FilterType.performance:
        return 'Performance';
      case FilterType.lowerExtremity:
        return 'Lower Extremity';
      case FilterType.upperExtremity:
        return 'Upper Extremity';
      case FilterType.patientReported:
        return 'Patient Reported';
    }
  }
}

enum DomainType {
  goals('goals'),
  satisfaction('satisfaction'),
  comfort('comfort'),
  function('function'),
  hrqol('hrqol');

  final String type;

  const DomainType(this.type);

  factory DomainType.fromType(String type) {
    return values.firstWhere((e) => e.type == type);
  }

  String get displayName {
    if (this == DomainType.hrqol) {
      return 'Quality of Life';
    }
    return name.capitalize();
  }

  Color get color {
    switch (this) {
      case DomainType.comfort:
        return const Color(0xff2F74AF);
      case DomainType.function:
        return const Color(0xff63B6FF);
      case DomainType.satisfaction:
        return const Color(0xffB36F0E);
      case DomainType.hrqol:
        return const Color(0xffF7B43C);
      case DomainType.goals:
        return const Color(0xffF86949);
      default:
        return Colors.black;
    }
  }

  String get header {
    switch (this) {
      case DomainType.comfort:
        return ksComfortAndFit;
      case DomainType.function:
        return ksFunctionalPerformance;
      case DomainType.satisfaction:
        return ksGeneralSatisfaction;
      case DomainType.goals:
        return ksGoalAchievement;
      case DomainType.hrqol:
        return ksQualityOfLife;
    }
  }

  String get improvementSummary {
    switch (this) {
      case DomainType.comfort:
        return ksComfortImprovement;
      case DomainType.function:
        return ksFunctionImprovement;
      case DomainType.satisfaction:
        return ksSatisfactionImprovement;
      case DomainType.goals:
        return ksGoalsImprovement;
      case DomainType.hrqol:
        return ksQualityOfLifeImprovement;
    }
  }

  String get declineSummary {
    switch (this) {
      case DomainType.comfort:
        return ksComfortDecline;
      case DomainType.function:
        return ksFunctionDecline;
      case DomainType.satisfaction:
        return ksSatisfactionDecline;
      case DomainType.goals:
        return ksGoalsDecline;
      case DomainType.hrqol:
        return ksQualityOfLifeDecline;
    }
  }
}

enum ConditionType { orthotic, prosthetic, other, upper, lower }

enum AmputeeSide { left, right, both }

enum ChangeDirection {
  stable,
  positive,
  negative,
  sigPositive,
  sigNegative;

  Color get color {
    switch (this) {
      case ChangeDirection.stable:
        return Colors.black;
      case ChangeDirection.positive:
        return Colors.green;
      case ChangeDirection.negative:
        return Colors.red;
      case ChangeDirection.sigPositive:
        return Colors.green;
      case ChangeDirection.sigNegative:
        return Colors.red;
    }
  }
}

EncounterType getType(String value) {
  if (value.toLowerCase().split('-').first == 'euro') {
    return EncounterType.prosat;
  }
  if (value.toLowerCase().split('-').first == 'mg') {
    return EncounterType.mg;
  }
  return EncounterType.unknown;
}

enum QuestionType {
  basic,
  radial,
  radial_checkbox,
  vas,
  discrete_scale,
  discrete_scale_checkbox,
  discrete_scale_text,
  checkbox,
  vas_checkbox_combo,
  text,
  text_checkbox,
  time,
  unknown
}

extension ParseToString on EncounterType {
  String toStringValue() {
    return toString().split('.').last;
  }
}

extension DateTimeFormat on DateTime {
  String toFormattedString(DateFormat dateFormat) {
    return dateFormat.format(this);
  }
}

extension GetConditionTypeDisplayName on ConditionType {
  String get toDisplayName =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}
