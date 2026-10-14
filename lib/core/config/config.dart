library config;

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/models/token_entity.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../base/helpers/helpers.dart';
import '../base/localization/localization.dart';
import '../utils/utils_imports.dart';

part '../utils/src/network_info/dio_helper.dart';
part '../utils/src/network_info/isolated_dio_helper.dart';
part 'src/app_theme.dart';