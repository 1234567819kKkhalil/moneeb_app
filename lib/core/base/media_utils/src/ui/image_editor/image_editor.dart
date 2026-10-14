library image_editor;

import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image/image.dart' as img;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../../app_material/material.dart';
import '../../../../../utils/utils_imports.dart';
import '../../../../helpers/helpers.dart';
import '../../../../localization/localization.dart';


part 'src/models/edit_image_info_model.dart';

part 'src/controllers/ruler_controller.dart';

part 'src/helpers/image_editor_helper.dart';

part 'src/models/aspect_ratio_model.dart';

part 'src/painters/aspect_ratio_painter.dart';
part 'src/painters/circle_editor_crop_painter.dart';

part 'src/presentation/manager/image_editor_cubit.dart';
part 'src/presentation/manager/image_editor_state.dart';

part 'src/presentation/pages/image_editor_page.dart';
part 'src/presentation/widgets/change_notifier_builder.dart';

