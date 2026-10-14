library media_utils;

import 'dart:collection' show Queue;
import 'dart:convert';
import 'dart:math' show Random;

import 'package:extended_image/extended_image.dart';
import 'package:gal/gal.dart';
import 'package:moneeb/core/base/media_utils/src/data/models/upload/to_internal_server/api_upload_file_input.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as mp;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';
import 'package:image/image.dart' as im;
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as pt;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../base/app_permissions/app_permissions.dart';
import '../../base/helpers/helpers.dart';
import '../../base/localization/localization.dart';
import '../../config/config.dart';
import '../../../core/app_material/material.dart';
import '../../../core/base/di/data_injector.dart';
import '../../../core/utils/utils_imports.dart';
import '../../../core/ui/helper_widgets/helper_widgets.dart';

import 'src/ui/video/models/states/video_player_state.dart';
import 'src/ui/video_maestro/video_maestro.dart';

part 'src/domain/models/upload/enums/upload_directory_enum.dart';
part 'src/media_picker_utils/media_picker.dart';
part 'src/media_picker_utils/helpers/media_utils.dart';

part 'src/ui/video/video_view.dart';
part 'src/ui/video/video_thumbnail_preview.dart';
part 'src/ui/video/manager/video_controllers_manager.dart';
part 'src/ui/video/manager/app_video_controller.dart';
part 'src/ui/video/models/regular_video_view_model.dart';
part 'src/ui/video/models/video_model.dart';

part 'src/ui/attachments_view/attachment_decider.dart';
part 'src/ui/attachments_view/fitted_gridview.dart';
part 'src/ui/attachments_view/grid_attachments_view.dart';
part 'src/ui/all_media_views/all_attachments_horizontal_page.dart';

part 'src/media_picker_utils/helpers/picked_multi_images_limit_handler.dart';
part 'src/domain/models/picker/properties/picker_images_property.dart';
part 'src/domain/models/attachment_entity.dart';
part 'src/domain/models/picker/properties/picker_video_properties.dart';
part "src/domain/use_case/upload/upload_file_use_case.dart";
part "src/domain/use_case/upload/upload_attachment_use_case.dart";
part "src/domain/use_case/compress/compressors/image_compression_use_case.dart";
part "src/domain/use_case/compress/compressors/video_compression_use_case.dart";
part "src/domain/use_case/compress/attachment_compressor.dart";
part 'src/domain/use_case/thumbnail/get_thumbnail/get_video_thumbnail_use_case.dart';
part 'src/domain/use_case/thumbnail/attachment_thumbnail_grabber.dart';
part 'src/domain/repository/media_utils_repository.dart';

part 'src/manger/attachment_cache_manager.dart';

part 'src/data/models/attachment/api_attachment_result.dart';
part 'src/data/repository/media_utils_repository_imp.dart';

part 'src/data/models/upload/to_internal_server/api_upload_result.dart';
