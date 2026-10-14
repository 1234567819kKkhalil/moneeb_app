library edit_user_profile;

import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';

import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/user_model/app_user_model.dart';
import 'package:moneeb/common/domain/usecases/upload_avatar_usecase.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

import '../../../core/base/localization/localization.dart';

part 'src/data/endpoints/edit_user_profile_endpoint.dart';
part 'src/data/models/update_profile_request.dart';
part 'src/data/repository/edit_user_profile_repository_impl.dart';

part 'src/domain/repositories/edit_user_profile_repository.dart';

part 'src/presentation/manager/edit_user_profile_state.dart';
part 'src/presentation/manager/edit_user_profile_cubit.dart';
part 'src/presentation/pages/edit_user_profile_page.dart';
part 'src/presentation/widgets/edit_user_profile_form.dart';
part 'src/presentation/widgets/edit_user_profile_avatar_section.dart';
