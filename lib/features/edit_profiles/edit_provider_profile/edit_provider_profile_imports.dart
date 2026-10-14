library edit_provider_profile;

import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart' as intel;
import 'package:moneeb/features/my_reviews/my_reviews_imports.dart';

import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/user_model/app_user_model.dart';
import 'package:moneeb/common/domain/usecases/upload_avatar_usecase.dart';
import 'package:moneeb/common/domain/usecases/upload_provider_avatar_usecase.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

// مستخدم فقط مع MyCertificatesSection المتوقفة في my_provider_profile_page
// import 'package:moneeb/features/orders/provider_orders/provider_orders_imports.dart';
import 'package:moneeb/features/provider_profile/provider_profile_imports.dart';

import '../../../core/base/localization/localization.dart';
import '../../../core/ui/helper_widgets/helper_widgets.dart';

part 'src/data/endpoints/edit_provider_profile_endpoint.dart';
part 'src/data/models/update_profile_request.dart';
part 'src/data/repository/edit_provider_profile_repository_impl.dart';

part 'src/domain/repositories/edit_provider_profile_repository.dart';

part 'src/presentation/manager/edit_provider_profile_state.dart';
part 'src/presentation/manager/edit_provider_profile_cubit.dart';
part 'src/presentation/pages/edit_provider_profile_page.dart';
part 'src/presentation/pages/my_provider_profile_page.dart';
part 'src/presentation/widgets/edit_provider_profile_form.dart';
part 'src/presentation/widgets/edit_provider_profile_avatar_section.dart';
part 'src/presentation/widgets/details_section.dart';
part 'src/presentation/widgets/availability_section.dart';
part 'src/presentation/widgets/availability_switcher.dart';
