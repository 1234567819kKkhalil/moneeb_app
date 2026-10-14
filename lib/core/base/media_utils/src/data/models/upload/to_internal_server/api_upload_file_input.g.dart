// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_upload_file_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiUploadFileInput _$ApiUploadFileInputFromJson(Map<String, dynamic> json) =>
    ApiUploadFileInput(
      const MultipartJsonConverter().fromJson(json['file']),
    );

Map<String, dynamic> _$ApiUploadFileInputToJson(ApiUploadFileInput instance) =>
    <String, dynamic>{
      'file': const MultipartJsonConverter().toJson(instance.file),
    };
