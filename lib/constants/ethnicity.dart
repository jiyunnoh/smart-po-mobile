enum Ethnicity {
  hispanic('hispanic'),
  notHispanic('notHispanic'),
  unknown('unknown');

  final String type;

  const Ethnicity(this.type);

  factory Ethnicity.fromType(String type) {
    return values.firstWhere((e) => e.type == type);
  }

  String get stringValue {
    switch (this) {
      case Ethnicity.hispanic:
        return 'ethnicity_1';
      case Ethnicity.notHispanic:
        return 'ethnicity_2';
      default:
        return 'ethnicity_u';
    }
  }

  String get displayName {
    switch (this) {
      case Ethnicity.hispanic:
        return 'Hispanic or Latino';
      case Ethnicity.notHispanic:
        return 'Not Hispanic or Latino';
      case Ethnicity.unknown:
        return 'Unknown';
    }
  }

  String get shortStrValue {
    switch (this) {
      case Ethnicity.hispanic:
        return "1";
      case Ethnicity.notHispanic:
        return "2";
      default:
        return "U";
    }
  }
}
