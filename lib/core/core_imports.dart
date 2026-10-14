library core;

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/initialize_app_configs.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

import 'app_material/material.dart';
import 'base/localization/localization.dart';
import 'ui/helper_widgets/helper_widgets.dart';
import 'app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'utils/utils_imports.dart';

part 'ui/customized_pop_scope.dart';
part '../features/authentication/src/presentation/ui/decider_page/decider_page.dart';
part '../features/authentication/src/presentation/ui/decider_page/splash_page.dart';
