import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../custom_pagination.dart';

part 'api_paginator_input.g.dart';

@JsonSerializable()
class ApiPaginatorInput extends Equatable {
  final int page;
  final int limit;

  const ApiPaginatorInput({this.page = 1, this.limit = 15});

  factory ApiPaginatorInput.fromJson(Map<String, dynamic> json) =>
      _$ApiPaginatorInputFromJson(json);

  Map<String, dynamic> toJson() => _$ApiPaginatorInputToJson(this);

  factory ApiPaginatorInput.fromInput(PaginatorInput data) {
    return ApiPaginatorInput(
      page: data.page,
      limit: data.limit,
    );
  }

  @override
  List<Object?> get props => [page, limit];
}