library main_host_page;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/home/home_imports.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/floating_omrah_manager.dart';
import 'package:moneeb/features/home/src/presentation/widgets/user_omrah_floating_steps/user_omrah_overlay_manager.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_tracking_service.dart';
import 'package:moneeb/features/orders/provider_orders/provider_orders_imports.dart';
import 'package:moneeb/features/orders/user_orders/user_orders_imports.dart';
import 'package:moneeb/features/settings/settings_imports.dart';

import '../../core/app_material/material.dart';

import '../../core/utils/utils_imports.dart';
import '../zad/zad_imports.dart';
import '../omra_request/omra_request_imports.dart';

part 'src/presentation/widgets/bottom_nav_bar.dart';
part 'src/presentation/widgets/off_stage.dart';
part 'src/presentation/pages/main_host_page.dart';
