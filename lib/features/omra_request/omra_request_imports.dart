library omra_request;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

import 'package:injectable/injectable.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/pagination/custom_pagination.dart';
import 'package:moneeb/core/ui/paginated_search_view/paginated_search_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:moneeb/features/home/home_imports.dart';

import '../../core/config/config.dart';
// import '../../core/utils/src/network_info/dio_helper.dart';

// Data
part 'src/data/endpoints/omra_request_endpoint.dart';
part 'src/data/models/create_order_response.dart';
part 'src/data/repository/omra_request_repository.dart';

// Domain
part 'src/domain/entities/omra_request_dummy_data.dart';
part 'src/domain/entities/umrah_pilgrim_model.dart';
part 'src/domain/use_cases/create_omra_order_use_case.dart';
part 'src/domain/use_cases/get_providers_use_case.dart';

// Manager
part 'src/presentation/manger/omra_request_state.dart';
part 'src/presentation/manger/omra_request_cubit.dart';

// Presentation
part 'src/presentation/pages/omra_request_page.dart';
part 'src/presentation/pages/all_providers_page.dart';

// Widgets
part 'src/presentation/widgets/omra_type_item.dart';
part 'src/presentation/widgets/omra_gender_item.dart';
part 'src/presentation/widgets/umrah_pilgrim_item.dart';
