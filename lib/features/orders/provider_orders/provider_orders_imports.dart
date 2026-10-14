library provider_orders;

import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdfx/pdfx.dart' show PdfDocument, PdfPageImageFormat;
import 'package:share_plus/share_plus.dart';
import 'package:moneeb/common/data/models/user_model/api_user_base_model.dart';
import 'package:moneeb/common/domain/models/enums/gender_enum.dart';
import 'package:moneeb/common/domain/models/user_model/user_base_entity.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/base/pagination/custom_pagination.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/home_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/floating_omrah_manager.dart';
import 'package:moneeb/features/omrah/common/widgets/omrah_start_countdown.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_tracking_service.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/features/orders/provider_orders/src/domain/entities/enums/provider_order_status_enum.dart';

import '../../omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import '../user_orders/user_orders_imports.dart';

// Endpoints
part 'src/data/endpoints/provider_orders_endpoint.dart';

// Models
part 'src/domain/entities/provider_order_entity.dart';
part 'src/domain/entities/order_certificate_entity.dart';

// Repositories
part 'src/domain/repositories/provider_orders_repository.dart';
part 'src/data/repository/provider_orders_repository_impl.dart';

// Presentation
part 'src/presentation/pages/provider_orders_page.dart';
part 'src/presentation/pages/order_certificate_page.dart';

// Widgets
part 'src/presentation/widgets/provider_order_card.dart';
part 'src/presentation/widgets/my_certificates_section.dart';

// Manager
part 'src/presentation/manager/provider_orders_cubit/provider_orders_cubit.dart';
part 'src/presentation/manager/provider_orders_cubit/provider_orders_state.dart';
part 'src/presentation/manager/provider_actions_cubit/provider_actions_cubit.dart';
part 'src/presentation/manager/provider_actions_cubit/provider_actions_state.dart';
part 'src/presentation/manager/order_certificate_cubit/order_certificate_cubit.dart';
part 'src/presentation/manager/order_certificate_cubit/order_certificate_state.dart';
part 'src/presentation/manager/my_certificates_cubit/my_certificates_cubit.dart';
