library my_reviews;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/core/app_material/material.dart';

import '../../core/base/localization/localization.dart';

// Data Layer
part 'src/data/endpoints/my_reviews_endpoint.dart';
part 'src/data/models/my_review_model.dart';
part 'src/data/repository/my_reviews_repository_impl.dart';

// Domain Layer
part 'src/domain/entities/my_review_entity.dart';
part 'src/domain/repositories/my_reviews_repository.dart';
part 'src/domain/use_cases/get_my_reviews_use_case.dart';

// Presentation Layer
part 'src/presentation/manger/my_reviews_cubit.dart';
part 'src/presentation/manger/my_reviews_state.dart';
part 'src/presentation/pages/my_reviews_page.dart';
part 'src/presentation/widgets/my_review_item_widget.dart';
