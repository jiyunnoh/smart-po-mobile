enum Race {
  americanIndianOrAlaskaNative('americanIndianOrAlaskaNative'),
  asian('asian'),
  blackOrAfricanAmerican('blackOrAfricanAmerican'),
  nativeHawaiianOrOtherPacificIslander('nativeHawaiianOrOtherPacificIslander'),
  white('white'),
  unknown('unknown');

  final String type;

  const Race(this.type);

  factory Race.fromType(String type) {
    return values.firstWhere((e) => e.type == type);
  }

  String get stringValue {
    switch (this) {
      case Race.americanIndianOrAlaskaNative:
        return 'race_1';
      case Race.asian:
        return 'race_2';
      case Race.blackOrAfricanAmerican:
        return 'race_3';
      case Race.nativeHawaiianOrOtherPacificIslander:
        return 'race_5';
      case Race.white:
        return 'race_6';
      default:
        return 'race_u';
    }
  }

  String get displayName {
    switch (this) {
      case Race.americanIndianOrAlaskaNative:
        return 'American Indian or Alaska Native';
      case Race.asian:
        return 'Asian';
      case Race.blackOrAfricanAmerican:
        return 'Black or African American';
      case Race.nativeHawaiianOrOtherPacificIslander:
        return 'Native Hawaiian or Other Pacific Islander';
      case Race.white:
        return 'White';
      case Race.unknown:
        return 'Unknown';
    }
  }

  String get shortStrValue {
    switch (this) {
      case Race.americanIndianOrAlaskaNative:
        return "1";
      case Race.asian:
        return "2";
      case Race.blackOrAfricanAmerican:
        return "3";
      case Race.nativeHawaiianOrOtherPacificIslander:
        return "5";
      case Race.white:
        return "6";
      default:
        return "U";
    }
  }
}
