import 'package:equatable/equatable.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/common/domain/models/location_entity.dart';
import 'package:moneeb/common/domain/models/user_model/user_base_entity.dart';

import '../enums/gender_enum.dart';

class AppUserModel extends UserBaseEntity {
  final ProviderDataEntity? providerData;
  const AppUserModel({
    required super.id,
    required super.role,
    required super.fullName,
    required super.username,
    required super.email,
    required super.phoneCountryCode,
    required super.phoneNumber,
    required super.isVerified,
    required super.location,
    required super.avatarUrl,
    required super.gender,
    required super.country,

    required this.providerData,
  });

  const AppUserModel.initial({UserRoleEnum? userRole})
    : this(
        id: '',
        role: userRole ?? UserRoleEnum.guest,
        email: '',
        phoneCountryCode: '',
        phoneNumber: '',
        fullName: '',
        username: '',
        avatarUrl: '',
        isVerified: false,
        gender: GenderEnum.male,
        country: '',
        location: const LocationEntity(lat: '0', long: '0'),
        providerData: null,
      );

  @override
  AppUserModel copyWith({
    String? id,
    UserRoleEnum? role,
    String? fullName,
    String? username,
    String? email,
    String? phoneCountryCode,
    String? phoneNumber,
    String? avatarUrl,
    bool? isVerified,
    LocationEntity? location,
    ProviderDataEntity? providerData,
    GenderEnum? gender,
    String? country,
  }) {
    return AppUserModel(
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
      providerData: providerData ?? this.providerData,
    );
  }

  @override
  List<Object?> get props => [...super.props, providerData];
}

class ProviderDataEntity extends Equatable {
  final String? bio;
  final bool isOnline;
  final bool isVerified;
  final String? introVideoUrl;
  final String? introImageUrl;
  final String totalRating;
  final int executedCount;
  // final int rejectedCount;
  final bool isHafiz;
  final bool hafizBadgeEnabled;
  // final String registrationStatus; //todo: return these commented fields and handle its logic
  // final String? registrationRejectionReason;
  final int umrahCount;
  final String? identificationNumber;
  final String? identificationDocumentUrl;
  final List<CertificateEntity>? certificates;

  const ProviderDataEntity({
    this.bio,
    required this.isOnline,
    required this.isVerified,
    this.introVideoUrl,
    this.introImageUrl,
    required this.totalRating,
    required this.executedCount,
    // required this.rejectedCount,
    required this.isHafiz,
    required this.hafizBadgeEnabled,
    // required this.registrationStatus,
    // this.registrationRejectionReason,
    required this.umrahCount,
    this.identificationNumber,
    this.identificationDocumentUrl,
    required this.certificates,
  });

  // Certificates are optional — a provider is considered complete once
  // they have submitted their ID document and ID number.
  bool get isCompletedProfile =>
      identificationDocumentUrl != null && identificationNumber != null;

  ProviderDataEntity copyWith({
    String? bio,
    bool? isOnline,
    bool? isVerified,
    String? introVideoUrl,
    String? introImageUrl,
    String? totalRating,
    int? executedCount,
    int? rejectedCount,
    bool? isHafiz,
    bool? hafizBadgeEnabled,
    String? registrationStatus,
    String? registrationRejectionReason,
    int? umrahCount,
    String? identificationNumber,
    String? identificationDocumentUrl,
    List<CertificateEntity>? certificates,
  }) {
    return ProviderDataEntity(
      bio: bio ?? this.bio,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      introVideoUrl: introVideoUrl ?? this.introVideoUrl,
      introImageUrl: introImageUrl ?? this.introImageUrl,
      totalRating: totalRating ?? this.totalRating,
      executedCount: executedCount ?? this.executedCount,
      // rejectedCount: rejectedCount ?? this.rejectedCount,
      isHafiz: isHafiz ?? this.isHafiz,
      hafizBadgeEnabled: hafizBadgeEnabled ?? this.hafizBadgeEnabled,
      // registrationStatus: registrationStatus ?? this.registrationStatus,
      // registrationRejectionReason:
      // registrationRejectionReason ?? this.registrationRejectionReason,
      umrahCount: umrahCount ?? this.umrahCount,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      identificationDocumentUrl:
          identificationDocumentUrl ?? this.identificationDocumentUrl,
      certificates: certificates ?? this.certificates,
    );
  }

  @override
  List<Object?> get props => [
    bio,
    isOnline,
    isVerified,
    introVideoUrl,
    introImageUrl,
    totalRating,
    executedCount,
    // rejectedCount,
    isHafiz,
    hafizBadgeEnabled,
    // registrationStatus,
    // registrationRejectionReason,
    umrahCount,
    identificationNumber,
    identificationDocumentUrl,
    certificates,
  ];
}

class CertificateEntity {
  final String id;
  final String url;
  final String title;
  CertificateEntity({required this.id, required this.url, required this.title});
}
