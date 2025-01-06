enum CurrentSex {
  male('male'),
  female('female'),
  other('other'),
  unknown('unknown');

  final String type;

  const CurrentSex(this.type);

  factory CurrentSex.fromType(String type) {
    return values.firstWhere((e) => e.type == type);
  }

  String get stringValue {
    switch (this) {
      case CurrentSex.male:
        return 'current_sex_male';
      case CurrentSex.female:
        return 'current_sex_female';
      case CurrentSex.other:
        return 'current_sex_other';
      default:
        return 'current_sex_unknown';
    }
  }

  String get displayName {
    switch (this) {
      case CurrentSex.male:
        return 'Male';
      case CurrentSex.female:
        return 'Female';
      case CurrentSex.other:
        return 'Other';
      case CurrentSex.unknown:
        return 'Unknown';
    }
  }

  String get shortStrValue {
    switch (this) {
      case CurrentSex.male:
        return "M";
      case CurrentSex.female:
        return "F";
      case CurrentSex.other:
        return "O";
      default:
        return "U";
    }
  }
}
