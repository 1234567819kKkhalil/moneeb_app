// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_cursor_paginator_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiCursorPaginatorInput _$ApiCursorPaginatorInputFromJson(
        Map<String, dynamic> json) =>
    ApiCursorPaginatorInput(
      after: json['after'] as String?,
      before: json['before'] as String?,
      limit: (json['limit'] as num?)?.toInt() ?? 15,
    );

Map<String, dynamic> _$ApiCursorPaginatorInputToJson(
        ApiCursorPaginatorInput instance) =>
    <String, dynamic>{
      'after': instance.after,
      'before': instance.before,
      'limit': instance.limit,
    };
