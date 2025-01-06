import 'package:biot/constants/enum.dart';
import 'package:biot/model/outcome_measures/outcome_measure.dart';
import 'package:biot/model/utility.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../constants/images.dart';

abstract class Domain {
  final DomainType type;
  Image icon;

  // TODO: when filled?
  final List<OutcomeMeasure> outcomeMeasures = [];

  num? score;

  Domain(this.type, {this.score, required this.icon});

  factory Domain.withType(DomainType type) {
    switch (type) {
      case DomainType.comfort:
        return ComfortDomain(type: type);
      case DomainType.function:
        return FunctionDomain(type: type);
      case DomainType.satisfaction:
        return SatisfactionDomain(type: type);
      case DomainType.goals:
        return GoalsDomain(type: type);
      case DomainType.hrqol:
        return HrQoLDomain(type: type);
    }
  }

  void calculateScore() {
    double total = 0;
    for (OutcomeMeasure om in outcomeMeasures) {
      total += om.calculateScore() * (1 / outcomeMeasures.length);
    }

    score = total;
  }

  List<OutcomeMeasure> descendingOrder() {
    outcomeMeasures
        .sort((a, b) => b.calculateScore().compareTo(a.calculateScore()));
    return outcomeMeasures;
  }

  Map<String, dynamic> scoreToJson();

  (double scoreChange, ChangeDirection scoreDiff) compareScoreAgainstPrev(
      Domain domainToCompare) {
    return Utility.compareScore(
        score!.toDouble(), domainToCompare.score!.toDouble());
  }

  @override
  int get hashCode => type.hashCode;

  @override
  bool operator ==(Object other) => other is Domain && other.type == type;
}

class ComfortDomain extends Domain {
  ComfortDomain({required type, outcomeMeasures, score})
      : super(type, icon: comfortIcon, score: score);

  @override
  Map<String, dynamic> scoreToJson() {
    if (score == null) {
      return {};
    }
    return {ksComfortDomainScore: score};
  }
}

class FunctionDomain extends Domain {
  FunctionDomain({required type, outcomeMeasures, score})
      : super(type, icon: functionIcon, score: score);

  @override
  Map<String, dynamic> scoreToJson() {
    if (score == null) {
      return {};
    }
    return {
      ksFunctionDomainScore: score,
    };
  }
}

class SatisfactionDomain extends Domain {
  SatisfactionDomain({required type, outcomeMeasures, score})
      : super(type, icon: satisfactionIcon, score: score);

  @override
  Map<String, dynamic> scoreToJson() {
    if (score == null) {
      return {};
    }
    return {
      ksSatisfactionDomainScore: score,
    };
  }
}

class GoalsDomain extends Domain {
  GoalsDomain({required type, outcomeMeasures, score})
      : super(type, icon: goalsIcon, score: score);

  @override
  Map<String, dynamic> scoreToJson() {
    if (score == null) {
      return {};
    }
    return {
      ksGoalsDomainScore: score,
    };
  }
}

class HrQoLDomain extends Domain {
  HrQoLDomain({required type, outcomeMeasures, score})
      : super(type, icon: hrqolIcon, score: score);

  @override
  Map<String, dynamic> scoreToJson() {
    if (score == null) {
      return {};
    }
    return {
      ksHrQoLDomainScore: score,
    };
  }
}
