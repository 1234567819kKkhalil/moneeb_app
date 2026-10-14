library notifications;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/fire_base/fire_base.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omrah_media_inspector_page.dart';
import 'package:moneeb/features/orders/user_orders/user_orders_imports.dart';

import '../../core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_updater.dart';

// Data & Endpoints
part 'src/data/endpoints/notifications_endpoint.dart';
part 'src/data/repository/notifications_repository_impl.dart';

// Domain
part 'src/domain/entities/notification_entity.dart';
part 'src/domain/repositories/notifications_repository.dart';

// Manager
part 'src/presentation/manger/notifications_cubit_state.dart';
part 'src/presentation/manger/notifications_cubit.dart';

// Presentation & Widgets
part 'src/presentation/pages/notifications_page.dart';
part 'src/presentation/widgets/notification_card.dart';
part 'src/presentation/utils/notification_router.dart';
