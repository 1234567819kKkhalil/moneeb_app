library custom_pagination;

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';

import '../../app_material/material.dart';
import '../../utils/utils_imports.dart';
import '../helpers/helpers.dart';

part 'src/positioned_paginated_list_view.dart';
part 'src/paginated_list_view.dart';
part 'src/paginated_page_view.dart';
part 'src/paginated_grid_view.dart';
part 'src/test_pagination_page.dart';
part 'src/controller/pagination_controller.dart';
part 'src/controller/pagination_state.dart';
part 'src/controller/super_list_controller.dart';
part 'src/fragments/fragment.dart';

//Models
part 'src/models/page/data/api_page_info.dart';
part 'src/models/page/data/api_paginated_model.dart';

part 'src/models/page/domain/input/paginator_input.dart';
part 'src/models/page/domain/page_info.dart';
part 'src/models/page/domain/pagination.dart';

part 'src/models/cursor/data/api_cursor_page_info.dart';
part 'src/models/cursor/domain/input/cursor_paginator_input.dart';
part 'src/models/cursor/domain/cursor_pagination_data.dart';
part 'src/models/cursor/domain/cursor_page_info.dart';