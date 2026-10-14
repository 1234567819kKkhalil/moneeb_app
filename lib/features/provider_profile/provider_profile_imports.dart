library provider_profile;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intel;
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';

import '../../common/domain/models/enums/user_role_enum.dart';

// Data Layer
part 'src/data/endpoints/provider_profile_endpoint.dart';
part 'src/data/models/provider_profile_model.dart';
part 'src/data/models/provider_review_model.dart';
part 'src/data/repository/provider_profile_repository_impl.dart';

// Domain Layer
part 'src/domain/entities/provider_profile_entity.dart';
part 'src/domain/entities/provider_review_entity.dart';
part 'src/domain/repositories/provider_profile_repository.dart';
part 'src/domain/use_cases/get_provider_profile_use_case.dart';

// Presentation Layer
part 'src/presentation/manger/provider_profile_cubit.dart';
part 'src/presentation/manger/provider_profile_state.dart';
part 'src/presentation/pages/provider_profile_page.dart';
part 'src/presentation/widgets/provider_profile_widgets.dart';
