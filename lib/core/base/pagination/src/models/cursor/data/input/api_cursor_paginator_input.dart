import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../custom_pagination.dart';

part 'api_cursor_paginator_input.g.dart';

@JsonSerializable()
class ApiCursorPaginatorInput extends Equatable {
  final String? after;
  final String? before;
  final int limit;

  const ApiCursorPaginatorInput({
    this.after,
    this.before,
    this.limit = 15,
  });

  factory ApiCursorPaginatorInput.fromJson(Map<String, dynamic> json) =>
      _$ApiCursorPaginatorInputFromJson(json);

  Map<String, dynamic> toJson() => _$ApiCursorPaginatorInputToJson(this);

  factory ApiCursorPaginatorInput.fromInput(CursorPaginatorInput data) {
    return ApiCursorPaginatorInput(
      after: data.direction == PaginationDirectionEnum.after ? data.cursor : null,
      before: data.direction == PaginationDirectionEnum.before ? data.cursor : null,
      limit: data.limit,
    );
  }

  @override
  List<Object?> get props => [
    after,
    before,
    limit,
  ];
}
