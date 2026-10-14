library auth;

import 'dart:async';
import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/models/enums/device_type.dart';
import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/common/domain/models/user_model/app_user_model.dart';
import 'package:moneeb/common/domain/usecases/upload_avatar_usecase.dart';
import 'package:moneeb/common/domain/usecases/upload_certificates_usecase.dart';
import 'package:moneeb/common/domain/usecases/upload_identification_usecase.dart';
import 'package:moneeb/common/domain/usecases/upload_provider_avatar_usecase.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/ui/app_glow_background.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_tracking_service.dart';
import '../../core/base/di/data_injector.dart';
import '../../core/base/fire_base/fire_base.dart';
import '../../core/base/helpers/helpers.dart';
import '../../core/base/localization/localization.dart';
import '../../core/config/config.dart';
import '../../core/ui/tab_bar_switcher/tab_bar_imports.dart';
import '../../core/utils/utils_imports.dart';
import 'package:flutter/material.dart' as direction;


import 'package:pinput/pinput.dart';

import '../../core/app_material/material.dart';

import 'dart:convert';
import 'dart:developer';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moneeb/common/data/models/api_token_model.dart';
import 'package:moneeb/common/domain/models/token_entity.dart';
import 'package:moneeb/common/data/models/user_model/api_app_user_result.dart';


// Data
part 'src/data/endpoints/auth_endpoint.dart';
part 'src/data/models/register/api_register_result.dart';
part 'src/data/repository/authentication_repositories_imp.dart';

// Domain
part 'src/domain/entities/enums/quran_memorize_enum.dart';
part 'src/domain/entities/inputs/login_input.dart';
part 'src/domain/entities/inputs/register_input.dart';
part 'src/domain/entities/inputs/complete_provider_profile_input.dart';
part 'src/domain/entities/resend_otp_input.dart';
part 'src/domain/repositories/authentication_repositories.dart';
part 'src/domain/use_cases/delete_account_use_case.dart';
part 'src/domain/use_cases/set_fcm_token_use_case.dart';
part 'src/domain/use_cases/get_user_data_use_case.dart';
part 'src/domain/use_cases/is_user_authenticated_use_case.dart';
part 'src/domain/use_cases/complete_provider_profile_use_case.dart';
part 'src/domain/use_cases/login_use_case.dart';
part 'src/domain/use_cases/logout_use_case.dart';
part 'src/domain/use_cases/register_use_case.dart';
part 'src/domain/use_cases/send_otp_use_case.dart';
part 'src/domain/use_cases/forgot_password_use_case.dart';
part 'src/domain/use_cases/verify_forgot_password_use_case.dart';
part 'src/domain/use_cases/reset_password_use_case.dart';

// Presentation
part 'src/presentation/manger/authentication_bloc.dart';
part 'src/presentation/manger/authentication_events.dart';
part 'src/presentation/manger/authentication_states.dart';
part 'src/presentation/manger/token_manager/token_manager.dart';
part 'src/presentation/manger/token_manager/isolated_token_manager.dart';
part 'src/presentation/ui/common/email_widget.dart';
part 'src/presentation/ui/common/identifier_type_toggle.dart';
part 'src/presentation/ui/common/otp_pin_code_widget.dart';
part 'src/presentation/ui/login/cubit/login_cubit.dart';
part 'src/presentation/ui/login/login_page.dart';
part 'src/presentation/ui/login/cubit/login_state.dart';
part 'src/presentation/ui/register/user/cubit/user_register_cubit.dart';
part 'src/presentation/ui/register/user/user_register_input_provider.dart';
part 'src/presentation/ui/register/user/cubit/user_register_state.dart';
part 'src/presentation/ui/register/user/user_register_page.dart';
part 'src/presentation/ui/register/user/steps/user_register_step_one.dart';

// Provider Register
part 'src/presentation/ui/complete_profile/provider_complete_profile_page.dart';
part 'src/presentation/ui/complete_profile/cubit/provider_complete_profile_cubit.dart';
part 'src/presentation/ui/complete_profile/cubit/provider_complete_profile_state.dart';
part 'src/presentation/ui/complete_profile/steps/complete_profile_certifications_step.dart';
part 'src/presentation/ui/complete_profile/steps/complete_profile_provider_info_step.dart';
part 'src/presentation/ui/complete_profile/steps/kasam/provider_kasam_page.dart';
part 'src/presentation/ui/complete_profile/steps/kasam/provider_kasam_success_page.dart';
part 'src/presentation/ui/register/provider/provider_register_page.dart';
part 'src/presentation/ui/register/provider/cubit/provider_register_cubit.dart';
part 'src/presentation/ui/register/provider/cubit/provider_register_state.dart';

// Forgot Password
part 'src/presentation/ui/forgot_password/forgot_password_page.dart';
part 'src/presentation/ui/forgot_password/reset_password_page.dart';
part 'src/presentation/ui/forgot_password/cubit/reset_password_cubit.dart';
part 'src/presentation/ui/forgot_password/cubit/reset_password_state.dart';

// OTP
part 'src/presentation/ui/otp/cubit/otp_state.dart';
part 'src/presentation/ui/otp/cubit/otp_cubit.dart';
part 'src/presentation/ui/otp/verification_page.dart';

// Unified passwordless OTP auth (/auth/otp/*)
part 'src/data/models/otp/otp_auth_results.dart';
part 'src/domain/entities/enums/otp_channel_enum.dart';
part 'src/domain/entities/inputs/otp_identifier.dart';
part 'src/domain/entities/inputs/otp_start_input.dart';
part 'src/domain/entities/inputs/otp_verify_input.dart';
part 'src/domain/entities/inputs/otp_register_input.dart';
part 'src/domain/use_cases/get_otp_config_use_case.dart';
part 'src/domain/use_cases/otp_start_use_case.dart';
part 'src/domain/use_cases/otp_verify_use_case.dart';
part 'src/domain/use_cases/otp_register_use_case.dart';
part 'src/domain/use_cases/otp_resend_use_case.dart';
part 'src/presentation/ui/otp_auth/cubit/otp_auth_state.dart';
part 'src/presentation/ui/otp_auth/cubit/otp_auth_cubit.dart';
part 'src/presentation/ui/otp_auth/widgets/auth_identifier_form.dart';
part 'src/presentation/ui/otp_auth/otp_auth_verification_page.dart';
part 'src/presentation/ui/register/provider/provider_identity_verification_page.dart';