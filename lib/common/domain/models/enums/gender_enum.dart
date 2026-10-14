import 'package:moneeb/core/base/localization/localization.dart';

enum GenderEnum {
  male,
  female;

  factory GenderEnum.fromApi(String? apiValue) {
    switch (apiValue) {
      case "MALE":
        return GenderEnum.male;
      case 'FEMALE':
        return GenderEnum.female;
      default:
        return GenderEnum.male;
    }
  }

  /// API representation, e.g. `MALE`.
  String toApi() {
    switch (this) {
      case GenderEnum.male:
        return "MALE";
      case GenderEnum.female:
        return "FEMALE";
    }
  }

  String get localizedName {
    switch (this) {
      case GenderEnum.male:
        return appLocalizer.male;
      case GenderEnum.female:
        return appLocalizer.female;
    }
  }
}
