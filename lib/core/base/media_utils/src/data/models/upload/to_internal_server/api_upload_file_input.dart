// ignore: depend_on_referenced_packages
// ignore_for_file: constant_identifier_names

// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

import '../../../../../../../../core/utils/utils_imports.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../media_utils.dart';

part 'api_upload_file_input.g.dart';

@JsonSerializable()
class ApiUploadFileInput {
  @MultipartJsonConverter()
  final MultipartFile file;

  factory ApiUploadFileInput.fromJson(Map<String, dynamic> json) =>
      _$ApiUploadFileInputFromJson(json);

  ApiUploadFileInput(this.file, );

  Map<String, dynamic> toJson() => _$ApiUploadFileInputToJson(this);
}

class MultipartJsonConverter implements JsonConverter<MultipartFile, dynamic> {
  const MultipartJsonConverter();

  @override
  MultipartFile fromJson(json) {
    throw "";
  }

  @override
  toJson(MultipartFile object) {
    return object;
  }
}

extension UploadInputToApiMapper on Attachment {
  Future<ApiUploadFileInput> get mapToApiInput async {
    final filename = url.split("/").last.replaceAll(' ', '-');
    final file = await MultipartFile.fromFile(url,
        filename: filename, contentType: url.getMimeType);
    return ApiUploadFileInput(file);
  }
}
