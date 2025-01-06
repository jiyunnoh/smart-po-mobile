import 'package:easy_localization/easy_localization.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_strings.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/outcome_measures/outcome_measure.dart';

class OutcomeMeasureInfoViewModel extends BaseViewModel {
  final OutcomeMeasure outcomeMeasure;
  OutcomeMeasureInfoViewModel({required this.outcomeMeasure});

  String getCurrentOutcomeName() {
    switch (outcomeMeasure.id) {
      case ksPsfs:
        return LocaleKeys.psfs.tr();
      case ksDash:
        return LocaleKeys.dash.tr();
      case ksScs:
        return LocaleKeys.scs.tr();
      case ksTmwt:
        return LocaleKeys.tenMWT.tr();
      case ksFaam:
        return LocaleKeys.faam.tr();
      case ksTug:
        return LocaleKeys.tug.tr();
      case ksPromispi:
        return LocaleKeys.promispi.tr();
      case ksPmq:
        return LocaleKeys.pmq.tr();
      default:
        return outcomeMeasure.name;
    }
  }
}
