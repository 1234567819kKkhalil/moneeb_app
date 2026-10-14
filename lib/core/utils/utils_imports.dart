library app_utils;

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart'
    show Key, AESMode, IV, AES, Encrypter, Encrypted;
import 'package:hijri/hijri_calendar.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:app_links/app_links.dart';
import 'package:moneeb/common/domain/models/location_entity.dart';
import 'package:moneeb/common/domain/models/otp.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intel;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:photo_manager/photo_manager.dart';
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:ui' as td;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates, setLocaleIdentifier;
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

import '../base/fire_base/fire_base.dart';
import '../base/helpers/helpers.dart';
import '../base/localization/localization.dart';
import '../app_material/material.dart';
import '../../core/base/di/data_injector.dart';
import '../../builder_screen.dart';
import 'src/constants/keys/env_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Blocs - Cubits
part 'src/blocs-cubits/app_theme_cubit/app_theme_cubit.dart';

part 'src/chain_of_tasks/chain_of_tasks.dart';

part 'src/constants/dimensions/dimensions.dart';
part 'src/constants/assets_paths/svg_paths.dart';
part 'src/constants/assets_paths/asset_paths.dart';
part 'src/constants/app_limits.dart';
part 'src/constants/directories_paths.dart';
part 'src/constants/style/app_colors.dart';
part 'src/constants/constants.dart';
part 'src/constants/time_format_config.dart';

part 'src/controllers/status_notifier.dart';

part 'src/extensions/formats/text_input_format.dart';
part 'src/extensions/bool.dart';
part 'src/extensions/context.dart';
part 'src/extensions/date_time.dart';
part 'src/extensions/duration.dart';
part 'src/extensions/enum.dart';
part 'src/extensions/file.dart';
part 'src/extensions/global_key.dart';
part 'src/extensions/int.dart';
part 'src/extensions/list.dart';
part 'src/extensions/map.dart';
part 'src/extensions/num.dart';
part 'src/extensions/parse_utils.dart';
part 'src/extensions/scroll_controller.dart';
part 'src/extensions/string.dart';
part 'src/extensions/value_notifier.dart';
part 'src/extensions/widget.dart';

part 'src/keyboard/keyboard_space_builder.dart';
part 'src/keyboard/keyboard_done_overlay.dart';

part 'src/navigation/model/main_host_tab_enum.dart';
part 'src/navigation/page_transitions/drag_to_pop_transition/drag_to_pop_page_transition.dart';
part 'src/navigation/page_transitions/drag_to_pop_transition/pop_gesture_helper.dart';
part 'src/navigation/page_transitions/fade_transition.dart';
part 'src/navigation/page_transitions/slide_transition.dart';
part 'src/navigation/nav_observer.dart';
part 'src/navigation/nav_observer_model.dart';
part 'src/navigation/router_functions.dart';

part 'src/network_info/network_info.dart';
part 'src/network_info/connectivity_mixin.dart';

part 'src/observers/focus_monitor/mixins/focus_monitor_mixin.dart';
part 'src/observers/focus_monitor/models/hide_type_model.dart';
part 'src/observers/focus_monitor/focus_monitor_observer.dart';
part 'src/observers/focus_monitor/focus_monitor_updater.dart';

part 'src/observers/omrah_observer/mixins/omrah_mixin.dart';
part 'src/observers/omrah_observer/omrah_observer.dart';
part 'src/observers/omrah_observer/omrah_updater.dart';

part 'src/preferences/shared_preferences_helper.dart';
part 'src/preferences/shared_preferences_helper_imp.dart';

part 'src/scroll_utils/remove_bluish_scroll_glow.dart';
part 'src/scroll_utils/scroll_behaviours.dart';
part 'src/scroll_utils/scroll_physics.dart';

part 'src/services/launch_links/launch_url_utils.dart';
part 'src/services/share/enums/share_type_enum.dart';
part 'src/services/share/share_utils.dart';
part 'src/services/deep_link/deep_link.dart';
part 'src/services/device_spec_utils.dart';
part 'src/services/nullable.dart';
part 'src/services/random_id_generator.dart';
part 'src/services/security/encryption.dart';
part 'src/services/scheduler/debouncer.dart';
part 'src/services/scheduler/do_after.dart';
part 'src/services/scheduler/throttler.dart';
part 'src/services/real_time_service.dart';
part 'src/services/omrah_schedule.dart';
part 'src/services/location_service/location_service.dart';
part 'src/services/location_service/location_data.dart';
part 'src/validation/validation_rules.dart';
part 'src/validation/regex.dart';
part 'src/common.dart';
