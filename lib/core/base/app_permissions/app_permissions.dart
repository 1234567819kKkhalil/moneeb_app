library app_permissions;

import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app_material/material.dart';
import '../../utils/utils_imports.dart';
import '../helpers/helpers.dart';
import '../localization/localization.dart';

part 'src/cubit/app_permissions_cubit.dart';
part 'src/cubit/app_permissions_state.dart';

part 'src/manger/app_permissions.dart';