library zad;

import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/models/location_entity.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/app_material/material.dart';

import '../../core/base/localization/localization.dart';
import '../../core/ui/helper_widgets/helper_widgets.dart';
import '../authentication/authentication_imports.dart';
import '../../core/base/fire_base/fire_base.dart';

// Data
part 'src/data/endpoints/zad_endpoint.dart';
part 'src/data/models/azkar_section_model.dart';
part 'src/data/models/azkar_content_model.dart';
part 'src/data/models/dua_model.dart';
part 'src/data/models/tasbeeh_preset_model.dart';
part 'src/data/models/prayer_times_model.dart';
part 'src/data/models/home_feed_model.dart';
part 'src/data/repository/zad_repository.dart';
part 'src/data/repository/zad_repository_imp.dart';

// Domain
part 'src/domain/entities/zad_dummy_data.dart';

// Manager
part 'src/presentation/manger/zad_state.dart';
part 'src/presentation/manger/zad_cubit.dart';
part 'src/presentation/manger/azkar_content_state.dart';
part 'src/presentation/manger/azkar_content_cubit.dart';
part 'src/presentation/manger/tasbeeh_state.dart';
part 'src/presentation/manger/tasbeeh_cubit.dart';
part 'src/presentation/manger/prayer_times_state.dart';
part 'src/presentation/manger/prayer_times_cubit.dart';
part 'src/presentation/manger/events_state.dart';
part 'src/presentation/manger/events_cubit.dart';

// Presentation
part 'src/presentation/pages/zad_page.dart';
part 'src/presentation/pages/tasbeeh_page.dart';
part 'src/presentation/pages/qiblah_page.dart';
part 'src/presentation/pages/prayer_times_page.dart';
part 'src/presentation/pages/events_page.dart';

// Widgets
part 'src/presentation/widgets/azkar_zad_item.dart';
part 'src/presentation/widgets/occasion_zad_item.dart';
// part 'src/presentation/widgets/occasion_item.dart';
// part 'src/presentation/widgets/prayer_item.dart';
// part 'src/presentation/widgets/azkar_bottom_sheet.dart';
part 'src/presentation/widgets/azkar_content_bottom_sheet.dart';
part 'src/presentation/widgets/dua_content_bottom_sheet.dart';
