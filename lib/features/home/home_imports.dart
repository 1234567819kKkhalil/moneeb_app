library home;

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/common/domain/models/location_entity.dart';
import 'package:moneeb/common/domain/models/user_model/app_user_model.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/mixins/notification_actions_mixin.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/floating_omrah_manager.dart';
import 'package:moneeb/features/omrah/common/widgets/omrah_start_countdown.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:moneeb/features/omrah/provider/domain/repo/omrah_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_tracking_service.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omrah_inspector.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/user_omrah_map_inspector_page.dart';
import 'package:moneeb/l10n/app_localizations.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

import '../../core/base/fire_base/fire_base.dart';
import '../../core/ui/helper_widgets/helper_widgets.dart';
import '../edit_profiles/edit_provider_profile/edit_provider_profile_imports.dart';
import '../edit_profiles/edit_user_profile/edit_user_profile_imports.dart';
import '../notifications/notifications_imports.dart';
import '../omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import '../orders/provider_orders/provider_orders_imports.dart';
import '../orders/provider_orders/src/domain/entities/enums/provider_order_status_enum.dart';
import 'src/presentation/widgets/user_omrah_floating_steps/user_omrah_overlay_manager.dart';
import '../provider_profile/provider_profile_imports.dart';
import '../orders/user_orders/user_orders_imports.dart';
import 'package:moneeb/features/zad/zad_imports.dart';

// Endpoints
part 'src/data/endpoints/home_endpoint.dart';

// Repositories
part 'src/data/repository/home_repositories_imp.dart';

// Models
part 'src/data/models/story_model.dart';
part 'src/data/models/story_provider_model.dart';
part 'src/data/models/provider_model.dart';
part 'src/data/models/banner_model.dart';
part 'src/data/models/stream_model.dart';

// Entities
part 'src/domain/entities/story_entity.dart';
part 'src/domain/entities/story_provider_entity.dart';
part 'src/domain/entities/provider_entity.dart';
part 'src/domain/entities/banner_entity.dart';
part 'src/domain/entities/stream_entity.dart';
part 'src/domain/entities/upcoming_omrah_entity.dart';

// Domain
part 'src/domain/entities/home_dummy_data.dart';
part 'src/domain/repositories/home_repositories.dart';
part 'src/domain/use_cases/get_home_feed_use_case.dart';
part 'src/domain/use_cases/get_story_providers_use_case.dart';
part 'src/domain/use_cases/get_provider_stories_use_case.dart';
part 'src/domain/use_cases/get_best_providers_use_case.dart';
part 'src/domain/use_cases/get_verified_providers_use_case.dart';
part 'src/domain/use_cases/get_banners_use_case.dart';
part 'src/domain/use_cases/view_story_use_case.dart';
part 'src/domain/use_cases/get_streams_use_case.dart';

// Presentation
part 'src/presentation/manger/home_state.dart';
part 'src/presentation/manger/home_cubit.dart';
part 'src/presentation/manger/stories_state.dart';
part 'src/presentation/manger/stories_cubit.dart';
part 'src/presentation/pages/home_page.dart';
part 'src/presentation/pages/story_viewer_screen.dart';
part 'src/presentation/pages/banner_preview_page.dart';
part 'src/presentation/widgets/home_widgets.dart';

// Sections (Widgets)
part 'src/presentation/widgets/countdown_card.dart';
part 'src/presentation/widgets/stories_section.dart';
part 'src/presentation/widgets/banners_section.dart';
part 'src/presentation/widgets/videos_section.dart';
part 'src/presentation/widgets/azkar_section.dart';
part 'src/presentation/widgets/live_section.dart';
part 'src/presentation/widgets/trusted_pilgrims_section.dart';
part 'src/presentation/widgets/rituals_documentation_section.dart';
part 'src/presentation/widgets/umrah_tracking_section.dart';
part 'src/presentation/widgets/upcoming_omrah_section.dart';
part 'src/presentation/widgets/home_app_bar.dart';
part 'src/presentation/widgets/home_location_button.dart';
part 'src/presentation/widgets/welcome_section.dart';
part 'src/presentation/widgets/best_providers_section.dart';
part 'src/presentation/widgets/verified_providers_section.dart';
part 'src/presentation/widgets/streams_section.dart';

// Widget Items
part 'src/presentation/widgets/video_home_item.dart';
part 'src/presentation/widgets/azkar_home_item.dart';
part 'src/presentation/widgets/live_home_item.dart';
part 'src/presentation/widgets/trustworthy_pilgrim_item.dart';
part 'src/presentation/widgets/real_trust_item.dart';
part 'src/presentation/widgets/umrah_stage_item.dart';
part 'src/presentation/widgets/umrah_stepper_widget.dart';
part 'src/presentation/widgets/provider_card_item.dart';
