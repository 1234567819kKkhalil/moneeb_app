import 'package:moneeb/common/data/models/api_location.dart';
import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/common/domain/models/user_model/user_base_entity.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

//todo: add gender
class ApiUserBaseModel {
  final String id;
  final UserRoleEnum role;
  final String fullName;
  final String username;
  final String email;
  final String avatarUrl;
  final String phoneCountryCode;
  final String phoneNumber;
  final bool isVerified;
  final ApiLocationModel? location;
  final GenderEnum gender;
  final String country;
  // final GenderEnum gender;

  ApiUserBaseModel({
    required this.id,
    required this.role,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.isVerified,
    required this.location,
    required this.gender,
    required this.country,
  });

  factory ApiUserBaseModel.fromJson(Map<String, dynamic> json) =>
      ApiUserBaseModel(
        id: json["id"] ?? '',
        role: UserRoleEnum.fromApi(json["role"]),
        fullName: json["fullName"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        phoneCountryCode: json["phoneCountryCode"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        avatarUrl: ((json["avatarUrl"] as String?)?.addBaseUrl) ?? '',
        isVerified: json["isVerified"] ?? false,
        location: ApiLocationModel.fromJson(json["effectiveLocation"]??{}),
        gender: GenderEnum.fromApi(json["gender"]),
        country: json["country"] ?? '',
      );

  UserBaseEntity mapToEntity() {
    return UserBaseEntity(
      fullName: fullName,
      id: id,
      role: role,
      username: username,
      email: email,
      phoneCountryCode: phoneCountryCode,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
      location: location?.toEntity(),
      gender: gender,
      country: country,
    );
  }
}
