
import 'package:moneeb/common/domain/models/token_entity.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

class ApiTokenModel{
  final String accessToken;
  final int accessTokenExpireTimeInSec;
  final String refreshToken;

  ApiTokenModel({
    required this.accessToken,
    required this.accessTokenExpireTimeInSec,
    required this.refreshToken,
  });

  factory ApiTokenModel.fromJson(Map<String, dynamic> json) {
    return ApiTokenModel(
      accessToken: json['accessToken'] ?? '',
      accessTokenExpireTimeInSec: json['expiresIn'] ?? 0,
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  TokenEntity toEntity(){
    return TokenEntity(
      accessToken: accessToken,
      accessTokenExpirationDate: RealTimeService.instance.getCurrentDateTime().add(Duration(seconds: accessTokenExpireTimeInSec)),
      refreshToken: refreshToken,
    );
  }
}