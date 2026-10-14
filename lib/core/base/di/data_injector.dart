import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_injector.config.dart';

import '../../utils/utils_imports.dart';
import '../localization/localization.dart';

final injector = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
//this will call only when the app starts
Future<void> initializeDependencies() async {
  await injector.initPersistentScope();
  injector.pushNewScope();
  await configureDependencies();
}

Future<void> configureDependencies() async {
  await injector.init();
}

Future<void> resetDependenciesScope() async {
  await injector.resetScope();
  await configureDependencies();
}

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dioConfig {
    final dio = Dio(
      BaseOptions(
        baseUrl: Constants.endpoint,
        receiveDataWhenStatusError: true,
      ),
    );

    //This for websites that does not have valid certificate
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    return dio;
  }

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  @Scope("persistent")
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
