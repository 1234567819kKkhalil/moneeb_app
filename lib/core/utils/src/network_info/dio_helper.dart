part of config;

@lazySingleton
class DioHelper {
  final Dio dio;
  final TokenManager _tokenManager;
  DioHelper(this.dio, this._tokenManager);

  Future<Options> _getOptions({bool isForUpload = false}) async {
    final TokenEntity? token = await _tokenManager.token;

    return Options(
      headers: {
        if (token?.accessToken.isNotEmpty ?? false)
          "Authorization": "Bearer ${token?.accessToken}",

        if (isForUpload) "Content-Type": "multipart/form-data",

        "Accept-Language": injector<LocalizationContainer>().langCode.name,
      },
    );
  }

  Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    return await errorHandler(() async {
      return await dio.get(
        url,
        queryParameters: query,
        options: await _getOptions(),
      );
    });
  }

  Future<Response> patch(String url, {required Object? data}) async {
    return await errorHandler(() async {
      return await dio.patch(url, data: data, options: await _getOptions());
    });
  }

  Future<Response> post(
    String url, {
    required Object? data,
    Map<String, dynamic>? query,
    bool isForUpload = false,
  }) async {
    return await errorHandler(() async {
      return await dio.post(
        url,
        queryParameters: query,
        data: data,
        options: await _getOptions(isForUpload: isForUpload),
      );
    });
  }

  Future<Response> put(
    String url, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await errorHandler(() async {
      return await dio.put(
        url,
        queryParameters: query,
        data: data,
        options: await _getOptions(),
      );
    });
  }

  Future<Response> delete(
    String url, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    return await errorHandler(() async {
      return await dio.delete(
        url,
        queryParameters: query,
        data: data,
        options: await _getOptions(),
      );
    });
  }

  Future<Response> downloadFile({
    required String url,
    required String path,
    Map<String, dynamic>? query,
    bool enableRetry = true,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.download(
        url,
        path,
        queryParameters: query,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw ApiRequestFailure(
          e.response?.statusCode ?? 0,
          e.response?.statusMessage ?? "",
        );
      } else if (e.type == DioExceptionType.cancel) {
        throw UnExpectedFailure("Download cancelled");
        //todo: failure cancel download failure
        // throw const CancelDownloadFileFailure();
      }
      if (e.response?.statusCode == 403 && enableRetry) {
        return downloadFile(
          url: url,
          path: path,
          query: query,
          enableRetry: false,
        );
      }
      throw ServerFailure(appLocalizer.couldNotDownloadFile);
    } catch (e) {
      throw ServerFailure(appLocalizer.couldNotDownloadFile);
    }
  }

  static Future<Response> errorHandler(Future<Response> Function() task) async {
    try {
      final response = await task();

      if (response.statusCode != 200 && response.statusCode != 201) {
        logDebug(response.toString());

        throw ApiRequestFailure(
          response.statusCode ?? 0,
          _getErrMessage(response),
        );
      }
      ServerClock.instance.syncFromResponseBody(response.data);
      log(
        "the requset type is ${response.requestOptions.method} \n"
        "the full request is ${response.realUri} \n"
        "the response is ::> ${response.data}",
      );
      return response;
    } on DioException catch (e) {
      logDebug(e.toString());

      throw ApiRequestFailure(
        e.response?.statusCode ?? 0,
        e.response == null
            ? appLocalizer.unexpectedError
            : _getErrMessage(e.response!),
      );
    } catch (e) {
      logDebug(e.toString());

      if (e is Failure) {
        rethrow;
      } else {
        throw ServerFailure(appLocalizer.couldNotDownloadFile);
      }
    }
  }

  static String _getErrMessage(Response response) {
    if (response.data is Map) {
      return response.data["error"] ?? appLocalizer.unexpectedError;
    } else {
      return response.statusMessage ?? appLocalizer.unexpectedError;
    }
  }
}
