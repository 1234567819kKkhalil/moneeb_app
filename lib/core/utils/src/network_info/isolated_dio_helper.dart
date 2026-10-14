part of config;

class IsolatedDioHelper {
  final IsolatedTokenManager _tokenManager = IsolatedTokenManager();
  final dio = Dio(
    BaseOptions(
      baseUrl: Constants.endpoint,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    )
  );

  Future<Options> _getOptions() async {
    final TokenEntity? token = await _tokenManager.token;

    return Options(
      headers: {
        if (token?.accessToken.isNotEmpty ?? false)
          "Authorization": "Bearer ${token?.accessToken}",
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
        options: await _getOptions(),
      );
    });
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
      logDebug(
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
        throw ServerFailure(
          "Could not get the data from the server",
        );
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
