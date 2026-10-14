import 'package:equatable/equatable.dart';
import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/common/domain/models/location_entity.dart';

class UserBaseEntity extends Equatable {
  final String id;
  final UserRoleEnum role;
  final String fullName;
  final String username;
  final String email;

  /// Dial code including the leading `+`, e.g. `+966`.
  final String phoneCountryCode;

  /// National number without the dial code, e.g. `500000000`.
  final String phoneNumber;
  final String avatarUrl;
  final bool isVerified;
  final LocationEntity? location;
  final GenderEnum gender;
  final String country;

  const UserBaseEntity({
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

  /// Complete number (`+966500000000`), empty when no phone is set.
  String get phone =>
      phoneNumber.isEmpty ? '' : '$phoneCountryCode$phoneNumber';

  const UserBaseEntity.initial() : this(
    id: '',
    role: UserRoleEnum.user,
    fullName: '',
    username: '',
    email: '',
    phoneCountryCode: '',
    phoneNumber: '',
    avatarUrl: '',
    isVerified: false,
    location: const LocationEntity(lat: '0', long: '0'),
    gender: GenderEnum.male,
    country: '',
  );

  UserBaseEntity copyWith({
    String? id,
    UserRoleEnum? role,
    String? fullName,
    String? username,
    String? email,
    String? phoneCountryCode,
    String? phoneNumber,
    bool? isVerified,
    String? avatarUrl,
    LocationEntity? location,
    GenderEnum? gender,
    String? country,
  }) {
    return UserBaseEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    fullName,
    username,
    email,
    phoneCountryCode,
    phoneNumber,
    isVerified,
    location,
    avatarUrl,
    gender,
    country,
  ];
}
