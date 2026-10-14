library video_maestro;

import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../core/app_material/material.dart';
import '../../../../../../core/base/di/data_injector.dart';
import '../../../../../../core/utils/utils_imports.dart';

import '../../../../../base/helpers/helpers.dart';
import '../../../../../base/localization/localization.dart';
import '../../../media_utils.dart';
import '../video/models/states/video_player_state.dart';

part 'src/controller/meastro_controller.dart';
part 'src/models/options_visibility_control.dart';
part 'src/widgets/maestro_bottom_controls.dart';
part 'src/widgets/maestro_double_speed_view.dart';
part 'src/widgets/maestro_play_pause_button.dart';
part 'src/widgets/maestro_seek_control_bar.dart';
part 'src/widgets/maestro_time_view.dart';
part 'src/video_maestro.dart';
part 'src/video_maestro_full_screen.dart';