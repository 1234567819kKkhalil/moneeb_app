library fire_base;

import 'package:crypto/crypto.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/common/entities/received_notification_entity.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_updater.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/notifications/notifications_imports.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omrah_media_inspector_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../../../core/utils/utils_imports.dart';
import '../../../firebase_options.dart';
import '../../app_material/material.dart';
import '../../config/config.dart';
import '../../ui/helper_widgets/helper_widgets.dart';
import '../di/data_injector.dart';
import '../helpers/helpers.dart';
import '../localization/localization.dart';
import '../pagination/custom_pagination.dart';
import '../pagination/src/models/page/data/input/api_paginator_input.dart';

part 'src/fcm_notification/common/use_cases/get_fcm_token_use_case.dart';

part 'src/fcm_notification/utils/external_forwarding_handler.dart';
part 'src/helper/firebase_helper.dart';
part 'src/helper/local_notification_service.dart';
part 'src/fcm_notification/utils/notification_observer.dart';
part 'src/fcm_notification/utils/notification_style_handler.dart';

