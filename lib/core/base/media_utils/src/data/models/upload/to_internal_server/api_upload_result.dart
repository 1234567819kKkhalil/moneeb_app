part of media_utils;

class ApiUploadFileResult {
  ApiUploadFileResult({
    this.uploadFile,
  });

  ApiUploadFileData? uploadFile;

  factory ApiUploadFileResult.fromJson(Map<String, dynamic> json) =>
      ApiUploadFileResult(
        uploadFile: json["data"]?["uploadFile"] == null
            ? null
            : ApiUploadFileData.fromJson(json["data"]?["uploadFile"]),
      );
}

class ApiUploadFileData {
  ApiUploadFileData({
    this.data,
    this.message,
    this.code,
    this.success,
  });

  String? data;
  String? message;
  int? code;
  bool? success;

  factory ApiUploadFileData.fromJson(Map<String, dynamic> json) =>
      ApiUploadFileData(
        data: json["data"],
        message: json["message"],
        code: json["code"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "message": message,
        "code": code,
        "success": success,
      };
}
