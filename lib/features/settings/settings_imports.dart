library settings;

import 'package:flutter_svg/svg.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/l10n/app_localizations.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/tazkiyah/tazkiyah_imports.dart';
import 'package:moneeb/features/my_reviews/my_reviews_imports.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../common/domain/models/enums/user_role_enum.dart';
import '../../common/domain/models/user_model/app_user_model.dart';
import '../../core/ui/helper_widgets/helper_widgets.dart';
import '../edit_profiles/edit_user_profile/edit_user_profile_imports.dart';
import '../edit_profiles/edit_provider_profile/edit_provider_profile_imports.dart';
import '../orders/user_orders/user_orders_imports.dart';

// Repositories
part 'src/data/endpoints/settings_endpoint.dart';
part 'src/data/models/app_settings_model.dart';
part 'src/data/repository/settings_repositories_imp.dart';

// Domain
part 'src/domain/repositories/settings_repositories.dart';
part 'src/domain/entities/setting_item.dart';
part 'src/domain/entities/app_settings_lang.dart';
part 'src/domain/use_cases/get_app_settings_use_case.dart';
part 'src/domain/use_cases/get_social_links_use_case.dart';
part 'src/domain/use_cases/request_account_deletion_use_case.dart';

// Presentation
part 'src/presentation/manger/settings_state.dart';
part 'src/presentation/manger/settings_cubit.dart';
part 'src/presentation/pages/settings_page.dart';
part 'src/presentation/widgets/settings_widgets.dart';
part 'src/presentation/widgets/settings_bottom_sheet.dart';
