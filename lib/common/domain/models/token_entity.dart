import 'dart:convert';

import 'package:moneeb/core/utils/utils_imports.dart';

class TokenEntity{
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpirationDate;

  TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpirationDate,
  });

  bool get isAccessTokenExpired {
    return accessTokenExpirationDate.isBefore(RealTimeService.instance.getCurrentDateTime());
  }

  TokenEntity copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? accessTokenExpirationDate,
  }) {
    return TokenEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessTokenExpirationDate: accessTokenExpirationDate ?? this.accessTokenExpirationDate,
    );
  }

  factory TokenEntity.fromJson(Map<String, dynamic> json) {
    return TokenEntity(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpirationDate: DateTime.now().add(Duration(seconds: json['expiresIn']??5)),
    );
  }

  factory TokenEntity.fromLocalStorage(Map<String, dynamic> json) {
    return TokenEntity(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpirationDate: json['accessTokenExpirationTime'] == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(json['accessTokenExpirationTime']),
    );
  }
  String toLocalStorage() {
    return json.encode({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessTokenExpirationTime': accessTokenExpirationDate.millisecondsSinceEpoch,
    });
  }
}