library paginated_search_view;

import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/base/pagination/custom_pagination.dart';
import '../../base/di/data_injector.dart';
import '../../base/helpers/helpers.dart';
import '../../base/localization/localization.dart';
import '../../base/pagination/src/models/page/data/input/api_paginator_input.dart';
import '../helper_widgets/helper_widgets.dart';
import '../../core_imports.dart';
import '../../utils/utils_imports.dart';
import '../../app_material/material.dart';

part 'src/model/search_pagination_input.dart';
part 'src/ui/paginated_search_view.dart';
part 'src/ui/bloc/paginated_search_view_bloc.dart';
part 'src/ui/bloc/paginated_search_view_event.dart';
part 'src/ui/bloc/paginated_search_view_state.dart';

part 'src/utils/search_observer/mixin/search_observer_mixin.dart';
part 'src/utils/search_observer/search_observer.dart';
part 'src/utils/search_observer/search_updater.dart';