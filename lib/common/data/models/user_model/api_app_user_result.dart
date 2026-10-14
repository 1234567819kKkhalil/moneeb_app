import 'package:moneeb/common/data/models/api_token_model.dart';
import 'package:moneeb/common/data/models/user_model/api_user_base_model.dart';
import 'package:moneeb/common/domain/models/user_model/app_user_model.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

class ApiAppUserModel {
  final ApiUserBaseModel baseUserData;
  final ApiTokenModel tokenModel;
  final ApiProviderData? providerData;
  ApiAppUserModel({
    required this.baseUserData,
    required this.tokenModel,
    required this.providerData,
  });

  factory ApiAppUserModel.fromJson({
    required Map<String, dynamic>? providerMap,
    required List<dynamic>? certificatesList,
    required Map<String, dynamic> userMap,
    required Map<String, dynamic>? tokenMap,
  }) {
    return ApiAppUserModel(
      baseUserData: ApiUserBaseModel.fromJson(userMap),
      tokenModel: ApiTokenModel.fromJson(tokenMap??{}),
      providerData: providerMap != null ? ApiProviderData.fromJson(
          providerMap:providerMap,
          certificatesList: certificatesList
      ) : null
    );
  }

  AppUserModel mapToAppUser() {
    return AppUserModel(
      id: baseUserData.id,
      email: baseUserData.email,
      fullName: baseUserData.fullName,
      isVerified: baseUserData.isVerified,
      location: baseUserData.location?.toEntity(),
      phoneCountryCode: baseUserData.phoneCountryCode,
      phoneNumber: baseUserData.phoneNumber,
      role: baseUserData.role,
      username: baseUserData.username,
      avatarUrl: baseUserData.avatarUrl,
      gender: baseUserData.gender,
      country: baseUserData.country,
      providerData: providerData?.toEntity(),
    );
  }
}

class ApiProviderData {
  final String? bio;
  final bool isOnline;
  final bool isVerified;
  final String? introVideoUrl;
  final String? introImageUrl;
  final String totalRating;
  final int executedCount;
  final int rejectedCount;
  final bool isHafiz;
  final bool hafizBadgeEnabled;
  final String registrationStatus;
  final String? registrationRejectionReason;
  final int umrahCount;
  final String? identificationNumber;
  final String? identificationDocumentUrl;
  final List<ApiCertificateModel>? certificates;

  const ApiProviderData({
    this.bio,
    required this.isOnline,
    required this.isVerified,
    this.introVideoUrl,
    this.introImageUrl,
    required this.totalRating,
    required this.executedCount,
    required this.rejectedCount,
    required this.isHafiz,
    required this.hafizBadgeEnabled,
    required this.registrationStatus,
    this.registrationRejectionReason,
    required this.umrahCount,
    this.identificationNumber,
    this.identificationDocumentUrl,
    this.certificates,
  });

  factory ApiProviderData.fromJson({
    required Map<String, dynamic> providerMap,
    required List<dynamic>? certificatesList
  }) {
    return ApiProviderData(
      bio: providerMap['bio'],
      isOnline: providerMap['isOnline'] ?? false,
      isVerified: providerMap['isVerified'] ?? false,
      introVideoUrl: providerMap['introVideoUrl'],
      introImageUrl: providerMap['introImageUrl'],
      totalRating: (providerMap['totalRating'] ?? '').toString(),
      executedCount: providerMap['executedCount'] ?? 0,
      rejectedCount: providerMap['rejectedCount'] ?? 0,
      isHafiz: providerMap['isHafiz'] ?? false,
      hafizBadgeEnabled: providerMap['hafizBadgeEnabled'] ?? false,
      registrationStatus: providerMap['registrationStatus'] ?? '',
      registrationRejectionReason: providerMap['registrationRejectionReason'],
      umrahCount: providerMap['umrahCount'] ?? 0,
      identificationNumber: providerMap['identificationNumber'],
      identificationDocumentUrl: providerMap['identificationDocumentUrl'],
      certificates: certificatesList
          ?.map((e) => ApiCertificateModel.fromJson(e)).toList()
    );
  }

  ProviderDataEntity toEntity(){
    return ProviderDataEntity(
      bio: bio,
      isOnline: isOnline,
      isVerified: isVerified,
      introVideoUrl: introVideoUrl?.addBaseUrl,
      introImageUrl: introImageUrl?.addBaseUrl,
      totalRating: totalRating,
      executedCount: executedCount,
      // rejectedCount: rejectedCount,
      isHafiz: isHafiz,
      hafizBadgeEnabled: hafizBadgeEnabled,
      // registrationStatus: registrationStatus,
      // registrationRejectionReason: registrationRejectionReason,
      umrahCount: umrahCount,
      identificationNumber: identificationNumber,
      identificationDocumentUrl: identificationDocumentUrl?.addBaseUrl,
      certificates: certificates?.map((e) => e.toEntity()).toList()
    );
  }
}

class ApiCertificateModel{
  final String id;
  final String imageUrl;
  final String title;
  ApiCertificateModel({required this.id, required this.imageUrl, required this.title});

  factory ApiCertificateModel.fromJson(Map<String, dynamic> json){
    return ApiCertificateModel(
      id: json['id']??'',
      imageUrl: (json['imageUrl'] as String?)?.addBaseUrl??'',
      title: json['title'] ?? '',
    );
  }

  CertificateEntity toEntity(){
    return CertificateEntity(
      id: id,
      url: imageUrl,
      title: title
    );
  }
}

