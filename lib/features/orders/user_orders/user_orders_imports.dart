library user_orders;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
// import 'package:json_annotation/json_annotation.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/mixins/notification_actions_mixin.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/pagination/custom_pagination.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/core/ui/tab_bar_switcher/tab_bar_imports.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/omrah/common/widgets/omrah_start_countdown.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omrah_inspector.dart';

import '../provider_orders/provider_orders_imports.dart';

// import 'package:moneeb/features/omrah/user/presentation/pages/omrah_inspector.dart';

// Data & Endpoints
part 'src/data/endpoints/user_orders_endpoint.dart';
part 'src/data/repository/user_orders_repository_impl.dart';

// Domain
part 'src/domain/entities/user_order_entity.dart';
part 'src/domain/repositories/user_orders_repository.dart';

// Old Domain (Commented out inside)
/* part 'src/domain/entities/orders_dummy_data.dart';
 */
// Manager
part 'src/presentation/manger/user_orders_cubit_state.dart';
part 'src/presentation/manger/user_orders_cubit.dart';

// Old Manager (Commented out inside)
/* part 'src/presentation/manger/orders_state.dart';
part 'src/presentation/manger/orders_cubit.dart';
 */
// Presentation & Widgets
part 'src/presentation/pages/user_orders_page.dart';
part 'src/presentation/widgets/user_order_card.dart';

// Old Widgets (Commented out inside)
/* part 'src/presentation/widgets/order_type_item.dart';
part 'src/presentation/widgets/order_item.dart';
 */
