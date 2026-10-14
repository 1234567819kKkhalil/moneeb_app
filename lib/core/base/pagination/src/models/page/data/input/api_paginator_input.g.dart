// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_paginator_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiPaginatorInput _$ApiPaginatorInputFromJson(Map<String, dynamic> json) =>
    ApiPaginatorInput(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 15,
    );

Map<String, dynamic> _$ApiPaginatorInputToJson(ApiPaginatorInput instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
